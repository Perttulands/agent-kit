# Send a message to Codex on a named bridge thread and print its reply as JSON.
# Same thread name => same Codex session (resumed), so the conversation carries on.
# Images Codex generates (native image gen) are copied to <bridge>\outbox\<thread>\.
# Usage: ask-codex.ps1 -Thread logo -Prompt "Draw a fox" [-From claude] [-Cd C:\repo] [-Sandbox read-only] [-Image a.png]
param(
  [Parameter(Mandatory)][string]$Thread,
  [string]$Prompt,
  [string]$PromptFile,  # prompt from a UTF-8 file: use for long or quoted prompts
  [string]$From = 'claude',
  [string]$Cd = (Get-Location).Path,
  [ValidateSet('read-only', 'workspace-write', 'danger-full-access')][string]$Sandbox = 'workspace-write',
  [string[]]$Image = @(),
  [string]$Model
)
. (Join-Path $PSScriptRoot 'lib.ps1')
if ($PromptFile) { $Prompt = [IO.File]::ReadAllText((Resolve-Path $PromptFile).Path) }
if (-not $Prompt) { throw 'Give -Prompt or -PromptFile' }
$OutputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::new($false)

$state = Get-BridgeThread $Thread
$imgRoot = Join-Path $(if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $env:USERPROFILE '.codex' }) 'generated_images'
$before = @{}
if (Test-Path $imgRoot) { Get-ChildItem $imgRoot -Recurse -File | ForEach-Object { $before[$_.FullName] = 1 } }

$common = @('--json', '--skip-git-repo-check', '-c', "sandbox_mode=`"$Sandbox`"")
# Let Codex call back (ask-claude.ps1): the bridge state and ~/.claude must be writable, and Claude needs network.
# TOML literal strings ('...') because PowerShell 5.1 drops inner double quotes on native calls.
$claudeHome = Join-Path $env:USERPROFILE '.claude'
$common += @('-c', "sandbox_workspace_write.writable_roots=['$($BridgeHome -replace '\\','/')','$($claudeHome -replace '\\','/')']",
             '-c', 'sandbox_workspace_write.network_access=true')
if ($Model) { $common += @('-m', $Model) }
foreach ($i in $Image) { $common += @('-i', (Resolve-Path $i).Path) }
$cliArgs = if ($state.codex) { @('exec', 'resume') + $common + @($state.codex, '-') } else { @('exec', '-C', $Cd) + $common + @('-') }

Add-BridgeLog $Thread $From 'codex' $Prompt
$message = (Get-BridgePreamble $Thread $From) + "`n`n" + $Prompt
Push-Location $Cd
try { $events = $message | & codex @cliArgs 2>$null } finally { Pop-Location }

$threadId = $state.codex; $reply = @(); $errors = @()
foreach ($line in $events) {
  if (-not $line.StartsWith('{')) { continue }
  $e = $line | ConvertFrom-Json
  switch ($e.type) {
    'thread.started' { $threadId = $e.thread_id }
    'item.completed' { if ($e.item.type -eq 'agent_message') { $reply += $e.item.text } }
    'turn.failed'    { $errors += $e.error.message }
    'error'          { $errors += $e.message }
  }
}
if ($threadId) { Set-BridgeThread $Thread 'codex' $threadId }

# Collect new images and copy them out under stable names.
$images = @()
if (Test-Path $imgRoot) {
  $new = Get-ChildItem $imgRoot -Recurse -File | Where-Object { -not $before.ContainsKey($_.FullName) } | Sort-Object LastWriteTime
  if ($new) {
    $out = Join-Path $BridgeHome "outbox\$Thread"; New-Item -ItemType Directory -Force $out | Out-Null
    foreach ($f in $new) {
      $dest = Join-Path $out ("{0}-{1}{2}" -f (Get-Date -Format 'yyyyMMdd-HHmmss'), $f.BaseName.Substring(0, [Math]::Min(13, $f.BaseName.Length)), $f.Extension)
      Copy-Item $f.FullName $dest; $images += $dest
    }
  }
}

$text = ($reply -join "`n`n")
Add-BridgeLog $Thread 'codex' $From $text $images
[ordered]@{ thread = $Thread; codex_thread_id = $threadId; reply = $text; images = $images; errors = $errors; ok = ($LASTEXITCODE -eq 0 -and -not $errors) } |
  ConvertTo-Json -Depth 5
