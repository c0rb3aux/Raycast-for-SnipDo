param(
    [string]$PLAIN_TEXT
)

# ── 1. Copy the selected text to the clipboard ──────────────────────────────
Set-Clipboard -Value $PLAIN_TEXT

# ── 2. Find Raycast exe via WMI (SnipDo is x86, can't read 64-bit proc path)
$wmi = Get-CimInstance Win32_Process -Filter "Name='Raycast.exe'" -ErrorAction SilentlyContinue | Select-Object -First 1

if (-not $wmi) {
    Start-Process "explorer.exe" -ArgumentList "shell:AppsFolder\Raycast.Raycast_qypenmj9wpt2a!App"
    Start-Sleep -Milliseconds 2000
    $wmi = Get-CimInstance Win32_Process -Filter "Name='Raycast.exe'" -ErrorAction SilentlyContinue | Select-Object -First 1
}

# ── 3. Open Raycast search bar ───────────────────────────────────────────────
if ($wmi) {
    Start-Process $wmi.ExecutablePath -ArgumentList "--show"
}

# ── 4. Wait for Raycast to be the foreground window, then paste ──────────────
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class FG {
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] public static extern int GetWindowThreadProcessId(IntPtr hWnd, out int pid);
}
"@ -ErrorAction SilentlyContinue

$timeout = 2000
$waited = 0
$raycastPid = $wmi.ProcessId
while ($waited -lt $timeout) {
    $hwnd = [FG]::GetForegroundWindow()
    $fgPid = 0
    [FG]::GetWindowThreadProcessId($hwnd, [ref]$fgPid) | Out-Null
    if ($fgPid -eq $raycastPid) { break }
    Start-Sleep -Milliseconds 100
    $waited += 100
}

Start-Sleep -Milliseconds 200

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait("^v")

Write-Output "Sent to Raycast: $PLAIN_TEXT"
