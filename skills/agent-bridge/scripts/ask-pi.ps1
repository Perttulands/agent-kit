# Send a message to Pi on a named bridge thread and print its reply as JSON.
param(
  [Parameter(Mandatory)][string]$Thread,
  [string]$Prompt,
  [string]$PromptFile,
  [string]$From = 'codex',
  [string]$Cd = (Get-Location).Path,
  [string]$Model
)
. (Join-Path $PSScriptRoot 'lib.ps1')
if ($PromptFile) { $Prompt = [IO.File]::ReadAllText((Resolve-Path $PromptFile).Path) }
if (-not $Prompt) { throw 'Give -Prompt or -PromptFile' }
$OutputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::new($false)
$state = Get-BridgeThread $Thread
$sessionId = if ($state.pi) { $state.pi } else { [guid]::NewGuid().ToString() }
$cliArgs = @('-p', '--mode', 'json', '--session-id', $sessionId)
if ($Model) { $cliArgs += @('--model', $Model) }
Add-BridgeLog $Thread $From 'pi' $Prompt
$message = (Get-BridgePreamble $Thread $From) + "`n`n" + $Prompt
Push-Location $Cd
try { $raw = @(& pi @cliArgs -- $message); $exitCode = $LASTEXITCODE } finally { Pop-Location }
$reply = $null; $usage = $null; $errors = @()
foreach ($line in $raw) {
  try { $event = $line | ConvertFrom-Json } catch { continue }
  if ($event.type -eq 'message_end' -and $event.message.role -eq 'assistant') {
    if ($event.message.stopReason -eq 'error') { $errors += $event.message.errorMessage }
    $text = @($event.message.content | Where-Object type -eq 'text' | ForEach-Object text) -join "`n"
    if ($text) { $reply = $text }
    if ($event.message.usage) { $usage = $event.message.usage }
  }
}
$ok = $exitCode -eq 0 -and $null -ne $reply -and $errors.Count -eq 0
if ($ok) { Set-BridgeThread $Thread 'pi' $sessionId }
Add-BridgeLog $Thread 'pi' $From $(if ($reply) { $reply } else { ($errors -join '; ') })
[ordered]@{ thread = $Thread; pi_session_id = $sessionId; reply = $reply; ok = $ok; errors = $errors; usage = $usage } | ConvertTo-Json -Depth 10
