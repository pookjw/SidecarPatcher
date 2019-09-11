# SidecarPatcher

Enable macOS 10.15 Sidecar on old Mac (2015 or older)

Sidecar is disabled on these devices: iMac13,1, iMac13,2, iMac13,3, iMac14,1, iMac14,2, iMac14,3, iMac14,4, iMac15,1, iMac16,1, iMac16,2, MacBook8,1, MacBookAir5,1, MacBookAir5,2, MacBookAir6,1, MacBookAir6,2, MacBookAir7,1, MacBookAir7,2, MacBookPro9,1, MacBookPro9,2, MacBookPro10,1, MacBookPro10,2, MacBookPro11,1, MacBookPro11,2, MacBookPro11,3, MacBookPro11,4, MacBookPro11,5, MacBookPro12,1, Macmini6,1, Macmini6,2, Macmini7,1, MacPro5,1, MacPro6,1

To get the model name of your Mac: `sysctl hw.model`

## With modifying System

This script disables this blacklist. Tested on macOS 10.15 Beta 1 (19A471t). Use at your own risk.

1. Backup `/System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore` file. This script doesn't provide original system file.

2. Disable **System Integrity Protection**. [How to turn off System Integrity Protection on your Mac](https://www.imore.com/how-turn-system-integrity-protection-macos).

3. Download the latest `SidecarPatcher` release from [here](https://github.com/pookjw/SidecarPatcher/releases).

- Safari will download a file named `SidecarPatcher.dms` instead of `SidecarPatcher`. Actually same.

4. Open Terminal and Excute `chmod +x /path/to/SidecarPatcher` and `sudo /path/to/SidecarPatcher`. 

- `/path/to/SidecarPatcher` refers to location of `SidecarPatcher` like `/Users/pook/Downloads/SidecarPatcher`. If you don't know what it is, just Drag & Drop a `SidecarPatcher` to Terminal. It will automatically fill it.

- You will need to enter Password, which is login password.

- If you encounter `Read-only file system` error, follow [this](https://github.com/pookjw/SidecarPatcher/issues/1).

- If you already patched, this script won't work until replacing to original one.

## Without modifying System

**Seems like this method no longer works.**

- `defaults write com.apple.sidecar.display allowAllDevices -bool YES`

- `defaults write com.apple.sidecar.display hasShownPref -bool YES`
