# ClamAV Smart Scanner for Windows

A highly optimized Batch/PowerShell hybrid script to run full system scans with [ClamAV](https://www.clamav.net/) on Windows. 

## 🛑 The Problem
By default, running `clamscan` on Windows forces you to choose between two bad scenarios:
1. **Use `--log` without `--infected`**: You get visual feedback on screen, but ClamAV mirrors *everything* to the log file. On a modern C: drive, this creates an unopenable 20GB+ text file filled with millions of `filename: OK` lines.
2. **Use `--infected`**: The log stays clean, but the terminal freezes completely for hours, giving no visual feedback on the scan's progress.

## 💡 The Solution (This Script)
This script acts as a smart wrapper. It completely drops ClamAV's native `--log` parameter and uses a real-time PowerShell pipe to decouple the terminal output from the log file.

### Key Features:
* **The "Matrix Effect"**: Scanned files scroll on the terminal in real-time, so you always know the engine is working.
* **Surgical Logging**: Only lines containing `FOUND` (actual malware) are written to the `.txt` report on your Desktop. No bloated logs, no system crashes.
* **Smart Exclusions**: Automatically skips disconnected drives, Windows system folders (`System Volume Information`), Recycle Bins, and massive files (>200MB) to speed up the process.
* **Popup Notification**: Plays a sound and shows a Windows GUI popup when the multi-drive scan is fully completed.

## 🚀 Usage
1. Ensure ClamAV is installed in `C:\Program Files\ClamAV`.
2. Edit the script to adjust your drive letters and custom `--exclude-dir` paths.
3. Right-click `clamav-smart-scanner.bat` and select **Run as Administrator** (the script will also attempt to self-elevate if run normally).
