# SidecarPatcher

Enable macOS 10.15 Sidecar on old Mac (2015 or older)

Sidecar is disabled on these devices: iMac13,1, iMac13,2, iMac13,3, iMac14,1, iMac14,2, iMac14,3, iMac14,4, iMac15,1, iMac16,1, iMac16,2, MacBook8,1, MacBookAir5,1, MacBookAir5,2, MacBookAir6,1, MacBookAir6,2, MacBookAir7,1, MacBookAir7,2, MacBookPro9,1, MacBookPro9,2, MacBookPro10,1, MacBookPro10,2, MacBookPro11,1, MacBookPro11,2, MacBookPro11,3, MacBookPro11,4, MacBookPro11,5, MacBookPro12,1, Macmini6,1, Macmini6,2, Macmini7,1, MacPro5,1, MacPro6,1

To get the model name of your Mac: `sysctl hw.model`

## With modifying System

This script disables this blacklist. Tested on macOS 10.15 Beta 9 (19A573a). Use at your own risk.

1. Backup `/System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore` file. This script doesn't provide original system file.

2. Disable **System Integrity Protection**. [How to turn off System Integrity Protection on your Mac](https://www.imore.com/how-turn-system-integrity-protection-macos).

- To check SIP is disabled: `csrutil status`

3. Download the latest release from [here](https://github.com/pookjw/SidecarPatcher/releases) and unzip it.

4. Open **Terminal** application and Excute `chmod +x /path/to/SidecarPatcher` and `sudo /path/to/SidecarPatcher`. 

- `/path/to/SidecarPatcher` refers to the location of `SidecarPatcher` like `/Users/pook/Downloads/SidecarPatcher`. If you don't know what it is, just Drag & Drop a `SidecarPatcher` to Terminal. It will automatically fill it.

- You will need to enter Password, which is login password.

- If you already patched, this script won't work until replacing to original one.

## About old iPad

Sidecar is disabled on these devices: iPad4,1, iPad4,2, iPad4,3, iPad4,4, iPad4,5, iPad4,6, iPad4,7, iPad4,8, iPad4,9, iPad5,1, iPad5,2, iPad5,3, iPad5,4, iPad6,11, iPad6,12

In SidecarPathcer [Version 5](https://github.com/pookjw/SidecarPatcher/commit/6c9a528a98254330bca92471cb94bbc0d6027334), it also disables this iPad blacklist. But I don't have Sidecar-unsupported Mac and iPad so I don't know it works. In case, it may require jailbreaking your iPad.

