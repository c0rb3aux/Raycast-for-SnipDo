param(
    [string]$PLAIN_TEXT
)

# ── 1. Copy the selected text to the clipboard ──────────────────────────────
Set-Clipboard -Value $PLAIN_TEXT

# ── 2. Ensure Raycast is running ─────────────────────────────────────────────
$proc = Get-Process -Name "Raycast" -ErrorAction SilentlyContinue | Select-Object -First 1

if (-not $proc) {
    Start-Process "explorer.exe" -ArgumentList "shell:AppsFolder\Raycast.Raycast_qypenmj9wpt2a!App"
    Start-Sleep -Milliseconds 2000
}

# ── 3. Send Alt+Space as PHYSICAL scan codes ─────────────────────────────────
#    Raycast v0.56+ switched to physical-key-based hotkey detection — virtual
#    key codes alone no longer trigger the search bar. We send the raw scan
#    codes for Left Alt (0x38) and Space (0x39) with KEYEVENTF_SCANCODE.
#
#    Using keybd_event (not SendInput) to avoid 32-/64-bit struct alignment
#    issues — SnipDo is an x86 host so the INPUT struct size differs.
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Kbd {
    [DllImport("user32.dll")]
    public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
}
"@ -ErrorAction SilentlyContinue

$SCAN_LALT       = [byte]0x38
$SCAN_SPACE      = [byte]0x39
$KEYUP           = [uint32]0x0002
$SCANCODE        = [uint32]0x0008

[Kbd]::keybd_event(0, $SCAN_LALT,  $SCANCODE,                [UIntPtr]::Zero)  # Alt down
Start-Sleep -Milliseconds 30
[Kbd]::keybd_event(0, $SCAN_SPACE, $SCANCODE,                [UIntPtr]::Zero)  # Space down
Start-Sleep -Milliseconds 30
[Kbd]::keybd_event(0, $SCAN_SPACE, $SCANCODE -bor $KEYUP,    [UIntPtr]::Zero)  # Space up
[Kbd]::keybd_event(0, $SCAN_LALT,  $SCANCODE -bor $KEYUP,    [UIntPtr]::Zero)  # Alt up

# ── 4. Wait for the Raycast search bar, then paste ───────────────────────────
Start-Sleep -Milliseconds 400

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait("^v")

Write-Output "Sent to Raycast: $PLAIN_TEXT"
