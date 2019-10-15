# SidecarPatcher

Enables Sidecar on old Mac and iPad for macOS 10.15 

Sidecar is disabled on these devices by Apple: `iMac13,1, iMac13,2, iMac13,3, iMac14,1, iMac14,2, iMac14,3, iMac14,4, iMac15,1, iMac16,1, iMac16,2, MacBook8,1, MacBookAir5,1, MacBookAir5,2, MacBookAir6,1, MacBookAir6,2, MacBookAir7,1, MacBookAir7,2, MacBookPro9,1, MacBookPro9,2, MacBookPro10,1, MacBookPro10,2, MacBookPro11,1, MacBookPro11,2, MacBookPro11,3, MacBookPro11,4, MacBookPro11,5, MacBookPro12,1, Macmini6,1, Macmini6,2, Macmini7,1, MacPro5,1, MacPro6,1`

and iPad: `iPad4,1, iPad4,2, iPad4,3, iPad4,4, iPad4,5, iPad4,6, iPad4,7, iPad4,8, iPad4,9, iPad5,1, iPad5,2, iPad5,3, iPad5,4, iPad6,11, iPad6,12`

You can type this in Terminal to get the model identifier of your Mac: `sysctl hw.model`.

You can get the model identifier of your iPad by using this app: [Mactracker (iOS App Store)](https://apps.apple.com/us/app/mactracker/id311421597)

This script disables this blacklist in macOS. This does NOT patch the iPadOS root system. Tested on macOS 10.15 (19A583).

## About the developer

After releasing macOS Catalina, I know that many people looking at this and there are a lot of many issues. I am currently preparing [Winter I-SURF at the University California of Irvine](https://www.urop.uci.edu/i-surf.html) now... I am a newbie in English, I am currently studying English for an interview.

I can't read all the issues and reply to them. I apologies for this.

## How to patch

It is very unstable. There are many known issues. Read [Issues](https://github.com/pookjw/SidecarPatcher/issues). Please use this at your own risk.

1. Backup `/System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore` file. This script doesn't provide original system file.

2. Install **Command Line Tools** from [here](https://developer.apple.com/download/more/).

- Requires Apple Developer Account, you can use a free-tier developer account .

3. Disable **System Integrity Protection**. [How to turn off System Integrity Protection on your Mac](https://www.imore.com/how-turn-system-integrity-protection-macos).

- To check SIP is disabled: `csrutil status`

4. Download the latest release from [here](https://github.com/pookjw/SidecarPatcher/releases) and unzip it.

- If you download using Chrome, it will warn you by notifying that file may dangerous. It's not a virus, but this script modifies the system so it thinks that the script is dangerous.

5. Open **Terminal** application and Excute `chmod +x /path/to/SidecarPatcher` and `sudo /path/to/SidecarPatcher`. 

- `/path/to/SidecarPatcher` refers to the location of `SidecarPatcher` like `/Users/pook/Downloads/SidecarPatcher`. If you don't know what it is, just Drag & Drop a `SidecarPatcher` to the Terminal. It will automatically fill it.

- You will need to enter your macOS password.

- This script will not patch again if you already patched your system until you revert to the original SidecarCore.

- About xcrun error and crashing many apps after rebooting: [#4](https://github.com/pookjw/SidecarPatcher/issues/4)

## How to revert

- Simplest Method

Reinstall your macOS using Catalina Installer. Install it without erasing your disk it won't erase your data and it will just reinstall the system.

- Using your backup

1. Disable **System Integrity Protection**. [How to turn off System Integrity Protection on your Mac](https://www.imore.com/how-turn-system-integrity-protection-macos).

To check SIP is disabled: `csrutil status` 

2. Run `sudo mount -uw /` command.

3. Copy the original SidecarCore: `sudo cp /path/to/original/SidecarCore /System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore`

- Make sure you put the right path for SidecarCore `/path/to/original/SidecarCore`.

4. Sign SidecarCore: `sudo codesign -f -s - /System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore`

5. Set permission as 755: `sudo chmod 755 /System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore`

6. Reboot. If you want to enable System Integrity Protection again, you can do so now.
