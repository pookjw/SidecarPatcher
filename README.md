# SidecarPatcher

Enable macOS 10.15 Sidecar on old Mac (2015 or older)

Sidecar is disabled on these devices: iMac13,1, iMac13,2, iMac13,3, iMac14,1, iMac14,2, iMac14,3, iMac14,4, iMac15,1, iMac16,1, iMac16,2, MacBook8,1, MacBookAir5,1, MacBookAir5,2, MacBookAir6,1, MacBookAir6,2, MacBookAir7,1, MacBookAir7,2, MacBookPro9,1, MacBookPro9,2, MacBookPro10,1, MacBookPro10,2, MacBookPro11,1, MacBookPro11,2, MacBookPro11,3, MacBookPro11,4, MacBookPro11,5, MacBookPro12,1, Macmini6,1, Macmini6,2, Macmini7,1, MacPro5,1, MacPro6,1

This script disables this blacklist.

## Before

- Backup `/System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore` file. This script doesn't provide original system file.

- Disable **System Integrity Protection**

## How to

- Download the latest release from [here](https://github.com/pookjw/SidecarPatcher/releases).

- Run `SidecarPatcher` as root.
