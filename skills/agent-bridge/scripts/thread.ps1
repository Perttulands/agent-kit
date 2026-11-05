# Show bridge threads, or one thread's transcript.
# Usage: thread.ps1            (list threads and their session ids)
#        thread.ps1 -Thread x  (print the transcript of thread x)
param([string]$Thread)
. (Join-Path $PSScriptRoot 'lib.ps1')
if (-not $Thread) { (Get-BridgeThreads).PSObject.Properties | ForEach-Object { '{0,-24} codex={1} claude={2} pi={3}' -f $_.Name, $_.Value.codex, $_.Value.claude, $_.Value.pi }; return }
if (-not (Test-Path $TranscriptPath)) { return }
Get-Content -Encoding UTF8 $TranscriptPath | ForEach-Object { $_ | ConvertFrom-Json } | Where-Object thread -eq $Thread | ForEach-Object {
  "--- $($_.ts) $($_.from) -> $($_.to)"
  $_.text
  foreach ($i in $_.images) { "[image] $i" }
}
