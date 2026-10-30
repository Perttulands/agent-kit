# Send a message to Claude Code on a named bridge thread and print its reply as JSON.
# Same thread name => same Claude session (resumed), so the conversation carries on.
# Usage: ask-claude.ps1 -Thread review -Prompt "Review bridge\ask-codex.ps1" [-From codex] [-Cd C:\repo] [-PermissionMode acceptEdits]
param(
  [Parameter(Mandatory)][string]$Thread,
  [string]$Prompt,
  [string]$PromptFile,  # prompt from a UTF-8 file: use for long or quoted prompts
  [string]$From = 'codex',
  [string]$Cd = (Get-Location).Path,
  [ValidateSet('default', 'acceptEdits', 'plan', 'bypassPermissions')][string]$PermissionMode = 'acceptEdits',
  [string]$Model
)
. (Join-Path $PSScriptRoot 'lib.ps1')
if ($PromptFile) { $Prompt = [IO.File]::ReadAllText((Resolve-Path $PromptFile).Path) }
if (-not $Prompt) { throw 'Give -Prompt or -PromptFile' }
$OutputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::new($false)

# Run as a fresh top-level Claude, not as a child of whatever Claude session started this chain.
$inherited = @([Environment]::GetEnvironmentVariables().Keys | Where-Object { $_ -eq 'CLAUDECODE' -or $_ -like 'CLAUDE_CODE_*' })
foreach ($n in $inherited) { [Environment]::SetEnvironmentVariable($n, $null) }

$state = Get-BridgeThread $Thread
$cliArgs = @('-p', '--output-format', 'json', '--permission-mode', $PermissionMode)
if ($state.claude) { $cliArgs += @('--resume', $state.claude) }
if ($Model) { $cliArgs += @('--model', $Model) }

Add-BridgeLog $Thread $From 'claude' $Prompt
$message = (Get-BridgePreamble $Thread $From) + "`n`n" + $Prompt
Push-Location $Cd
try { $raw = ($message | & claude @cliArgs 2>$null) -join "`n" } finally { Pop-Location }

$r = try { $raw | ConvertFrom-Json } catch { [pscustomobject]@{ result = $raw; is_error = $true } }
if ($r.session_id -and -not $r.is_error) { Set-BridgeThread $Thread 'claude' $r.session_id }
Add-BridgeLog $Thread 'claude' $From $r.result
[ordered]@{ thread = $Thread; claude_session_id = $r.session_id; reply = $r.result; ok = (-not $r.is_error) } | ConvertTo-Json -Depth 5
