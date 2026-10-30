# Shared state for the Codex <-> Claude bridge. Dot-source from the bridge scripts.
# State lives outside git: $env:AGENT_BRIDGE_HOME, default ~\.agent-bridge
#   threads.json      named thread -> { codex: <codex thread id>, claude: <claude session id> }
#   transcript.jsonl  one line per message: ts, thread, from, to, text, images
#   outbox\<thread>\  files (images) produced on a thread, copied out of the agent's own store
$ErrorActionPreference = 'Stop'
$BridgeHome = if ($env:AGENT_BRIDGE_HOME) { $env:AGENT_BRIDGE_HOME } else { Join-Path $HOME '.agent-bridge' }
New-Item -ItemType Directory -Force $BridgeHome | Out-Null
$ThreadsPath = Join-Path $BridgeHome 'threads.json'
$TranscriptPath = Join-Path $BridgeHome 'transcript.jsonl'

function Get-BridgeThreads {
  if (Test-Path $ThreadsPath) { Get-Content -Raw $ThreadsPath | ConvertFrom-Json } else { [pscustomobject]@{} }
}

function Get-BridgeThread([string]$Name) {
  $all = Get-BridgeThreads
  if ($all.$Name) { $all.$Name } else { [pscustomobject]@{ codex = $null; claude = $null } }
}

function Set-BridgeThread([string]$Name, [string]$Side, [string]$Id) {
  $all = Get-BridgeThreads
  if (-not $all.$Name) { $all | Add-Member -NotePropertyName $Name -NotePropertyValue ([pscustomobject]@{ codex = $null; claude = $null }) }
  $all.$Name.$Side = $Id
  [IO.File]::WriteAllText($ThreadsPath, ($all | ConvertTo-Json -Depth 5))
}

function Add-BridgeLog([string]$Thread, [string]$From, [string]$To, [string]$Text, [string[]]$Images = @()) {
  $line = [ordered]@{ ts = (Get-Date).ToString('o'); thread = $Thread; from = $From; to = $To; text = $Text; images = @($Images) } |
    ConvertTo-Json -Compress -Depth 5
  [IO.File]::AppendAllText($TranscriptPath, $line + "`n")
}

# Prompt sent with every message so the receiving agent knows it is talking to another agent
# and how to answer back over the bridge.
function Get-BridgePreamble([string]$Thread, [string]$From) {
  @"
[agent-bridge] Message from $From on bridge thread "$Thread". Your final reply is returned to $From verbatim.
Keep it self-contained: results, file paths, open questions. Earlier messages on this thread: $TranscriptPath
"@
}
