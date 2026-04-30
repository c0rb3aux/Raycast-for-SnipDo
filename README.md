# Raycast for SnipDo

A [SnipDo](https://snipdo-app.com/) text extension for Windows that sends selected text straight into [Raycast for Windows](https://www.raycast.com/windows).

Select any text → tap the Raycast button in SnipDo → the text is pasted into Raycast's search bar, ready to act on.

Think of it as the Windows equivalent of the [Raycast extension for PopClip](https://www.popclip.app/extensions/x/raycast) on macOS.

![SnipDo + Raycast](https://img.shields.io/badge/SnipDo-Raycast-FF6363?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIGZpbGw9Im5vbmUiIHZpZXdCb3g9IjAgMCAxNiAxNiI+PHBhdGggZmlsbD0id2hpdGUiIGZpbGwtcnVsZT0iZXZlbm9kZCIgZD0iTTQuNTAyIDEwLjAzN3YxLjQ2TDEgNy45OTZsLjczNC0uNzI4IDIuNzY4IDIuNzdabTEuNDYxIDEuNDZoLTEuNDZMOC4wMDQgMTVsLjczLS43My0yLjc3Mi0yLjc3MlpNMTQuMjcgOC43MyAxNSA4IDguMDAyIDFsLS43My43MyAyLjc2NSAyLjc3SDguMzY1bC0xLjkzLTEuOTMtLjczLjczIDEuMjAxIDEuMjAySDYuMDd2NS40MzFoNS40M3YtLjg0bDEuMjAzIDEuMjAzLjczLS43My0xLjkzMi0xLjkzM1Y1Ljk2MWwyLjc3IDIuNzY4Wk00Ljg2OCA0LjEzNGwtLjczLjczLjc4My43ODQuNzMtLjczLS43ODMtLjc4NFptNi4yMTUgNi4yMTUtLjcyOC43My43ODQuNzgzLjczLS43My0uNzg2LS43ODNaTTMuMyA1LjcwMWwtLjczLjczIDEuOTMxIDEuOTMzVjYuOTAybC0xLjItMS4yWm01Ljc5NyA1Ljc5N0g3LjYzNmwxLjkzMiAxLjkzMi43My0uNzMxLTEuMi0xLjIwMVoiIGNsaXAtcnVsZT0iZXZlbm9kZCIvPjwvc3ZnPg==)

## How it works

1. **Select text** anywhere on screen — SnipDo appears
2. **Click "Search in Raycast"** in the SnipDo toolbar
3. The extension:
   - Copies the selected text to the clipboard
   - Opens Raycast's search bar via `Alt+Space` (physical scan codes)
   - Pastes the text into Raycast

## Requirements

- **Windows 11**
- [SnipDo](https://www.microsoft.com/store/productId/9NPZ2TVKJVT7) (v1.5.3+)
- [Raycast for Windows](https://www.raycast.com/windows) with default `Alt+Space` hotkey

## Installation

### Option A — Import the `.pbar` file

1. Download `raycast-search.pbar` from [Releases](../../releases)
2. Open SnipDo → **Load Extensions** → select the `.pbar` file
3. Done!

### Option B — Build from source

1. Clone or download this repo
2. Select all files (`raycast-search.json`, `send_to_raycast.ps1`, `icon.svg`)
3. Compress them into a `.zip` file
4. Rename `.zip` → `.pbar`
5. Import into SnipDo via **Load Extensions**

### Option C — Create manually

1. Open SnipDo → **Create extension** → **Create a script-extension** (under Text extensions)
2. Paste the contents of `send_to_raycast.ps1`
3. Set the icon to `icon.svg`

## Files

| File | Description |
|---|---|
| `raycast-search.json` | SnipDo extension manifest |
| `send_to_raycast.ps1` | PowerShell script — clipboard + Alt+Space + paste |
| `icon.svg` | Raycast logo icon (white on transparent) |
| `icon.png` | Fallback PNG icon |

## Compatibility

- **Raycast v0.56+** — Uses physical scan codes (`KEYEVENTF_SCANCODE`) for the `Alt+Space` hotkey, compatible with Raycast's key-equivalent hotkey system
- **SnipDo x86** — Uses `keybd_event` API (not `SendInput`) to avoid 32-/64-bit struct alignment issues
- **PowerShell 5.1** — No PowerShell 7+ syntax (no `?.` operator, etc.)

## Customization

**Different Raycast hotkey?** Edit `send_to_raycast.ps1` and change the scan codes:

```powershell
$SCAN_LALT  = [byte]0x38   # Left Alt
$SCAN_SPACE = [byte]0x39   # Space
```

Refer to the [scan code table](https://learn.microsoft.com/en-us/windows/win32/inputdev/about-keyboard-input#scan-codes) for other keys.

**Paste delay too slow/fast?** Adjust the milliseconds:

```powershell
Start-Sleep -Milliseconds 400  # wait for Raycast bar
```

## Credits

Built with [Claude Code](https://claude.ai/claude-code). Inspired by the [Raycast extension for PopClip](https://www.popclip.app/extensions/x/raycast) on macOS.

## License

MIT
