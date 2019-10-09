# SidecarPatcher

Enable macOS 10.15 Sidecar on old Mac and iPad

Sidecar is disabled on these devices: `iMac13,1, iMac13,2, iMac13,3, iMac14,1, iMac14,2, iMac14,3, iMac14,4, iMac15,1, iMac16,1, iMac16,2, MacBook8,1, MacBookAir5,1, MacBookAir5,2, MacBookAir6,1, MacBookAir6,2, MacBookAir7,1, MacBookAir7,2, MacBookPro9,1, MacBookPro9,2, MacBookPro10,1, MacBookPro10,2, MacBookPro11,1, MacBookPro11,2, MacBookPro11,3, MacBookPro11,4, MacBookPro11,5, MacBookPro12,1, Macmini6,1, Macmini6,2, Macmini7,1, MacPro5,1, MacPro6,1`

and iPad: `iPad4,1, iPad4,2, iPad4,3, iPad4,4, iPad4,5, iPad4,6, iPad4,7, iPad4,8, iPad4,9, iPad5,1, iPad5,2, iPad5,3, iPad5,4, iPad6,11, iPad6,12`

Getting the model identifier of your Mac: `sysctl hw.model`

Getting the model identifier of your iPad: [Mactracker (iOS App Store)](https://apps.apple.com/us/app/mactracker/id311421597)

This script disables this blacklist. Tested on macOS 10.15 (19A583).

## How to patch

It is really unstable. There are many issues. Read [Issues](https://github.com/pookjw/SidecarPatcher/issues). Use at your own risk.

1. Backup `/System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore` file. This script doesn't provide original system file.

2. Disable **System Integrity Protection**. [How to turn off System Integrity Protection on your Mac](https://www.imore.com/how-turn-system-integrity-protection-macos).

- To check SIP is disabled: `csrutil status`

3. Download the latest release from [here](https://github.com/pookjw/SidecarPatcher/releases) and unzip it.

- If you download using Chrome, it will warn of downloading file may dangerous. It's not a virus, but this script modifies system so may be dangerous.

4. Open **Terminal** application and Excute `chmod +x /path/to/SidecarPatcher` and `sudo /path/to/SidecarPatcher`. 

- `/path/to/SidecarPatcher` refers to the location of `SidecarPatcher` like `/Users/pook/Downloads/SidecarPatcher`. If you don't know what it is, just Drag & Drop a `SidecarPatcher` to Terminal. It will automatically fill it.

- You will need to enter a Password, which is a login password.

- If you already patched, this script won't work until replacing to original one.

- About xcrun error and crashing many apps after rebooting: [#4](https://github.com/pookjw/SidecarPatcher/issues/4)

## How to revert

- Really Really Simple Method

Reinstall your macOS using Catalina Installer. Without erasing your disk won't erase your data and just reinstalled.

- Using your backup

1. Disable **System Integrity Protection**. [How to turn off System Integrity Protection on your Mac](https://www.imore.com/how-turn-system-integrity-protection-macos).

To check SIP is disabled: `csrutil status` 

2. Run `sudo mount -uw /` command.

3. Replace `/System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore`.

4. Sign SidecarCore: `sudo codesign -f -s - /System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore`

5. Set permission as 755: `sudo chmod 755 /System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore`

6. Reboot. If you want, enable System Integrity Protection again.

## About developer

Atfer releasing macOS Catalina, I know that many people watching this and there are so many issues. But I am preparing [Winter I-SURF at the University California of Irvine](https://www.urop.uci.edu/i-surf.html) now... I really newbie in English so I am studying English for interview.

I can't read all issues and reply them. Really sorry about this.
