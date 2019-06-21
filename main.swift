/*
 SidecarPatcher - Version 4
 
 Enabling Sidecar on old Mac (2015 or older)
 Tested on macOS 10.15 Beta 1 (19A471t). But I don't have old Mac so I don't know it works.
 
 THIS SCRIPT DOESN'T MAKE SidecarCore BACKUP SO YOU HAVE TO DO THIS MANUALLY. PLEASE BACKUP /System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore. PLEASE. PLEASE. PLEASE.
 And after patching SidecarCore, this script won't work until replacing to original one.
 This script requires disabling SIP, and running as root.
 */

import Darwin
import Foundation

func shell(_ command: String) -> String{
    let task = Process()
    task.launchPath = "/bin/bash"
    task.arguments = ["-c", command]
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
    return output
}

func printError(_ message: String){
    print("Ooops! Something went wrong: \(message)")
    exit(1)
}

fileprivate func directoryExistsAtPath(_ path: String) -> Bool {
    var isDirectory = ObjCBool(true)
    let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
    return exists && isDirectory.boolValue
}

let fileManager = FileManager()
let original = shell("xxd -p /System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore | tr -d '\n'")
let original_model_list = "694d616331332c3100694d616331332c3200694d616331332c3300694d616331342c3100694d616331342c3200694d616331342c3300694d616331342c3400694d616331352c3100694d616331362c3100694d616331362c32004d6163426f6f6b382c31004d6163426f6f6b416972352c31004d6163426f6f6b416972352c32004d6163426f6f6b416972362c31004d6163426f6f6b416972362c32004d6163426f6f6b416972372c31004d6163426f6f6b416972372c32004d6163426f6f6b50726f392c31004d6163426f6f6b50726f392c32004d6163426f6f6b50726f31302c31004d6163426f6f6b50726f31302c32004d6163426f6f6b50726f31312c31004d6163426f6f6b50726f31312c32004d6163426f6f6b50726f31312c33004d6163426f6f6b50726f31312c34004d6163426f6f6b50726f31312c35004d6163426f6f6b50726f31322c31004d61636d696e69362c31004d61636d696e69362c32004d61636d696e69372c31004d616350726f352c31004d616350726f362c31"
let patched_model_list = "694d616330302c3000694d616330302c3000694d616330302c3000694d616330302c3000694d616330302c3000694d616330302c3000694d616330302c3000694d616330302c3000694d616330302c3000694d616330302c30004d6163426f6f6b302c30004d6163426f6f6b416972302c30004d6163426f6f6b416972302c30004d6163426f6f6b416972302c30004d6163426f6f6b416972302c30004d6163426f6f6b416972302c30004d6163426f6f6b416972302c30004d6163426f6f6b50726f302c30004d6163426f6f6b50726f302c30004d6163426f6f6b50726f30302c30004d6163426f6f6b50726f30302c30004d6163426f6f6b50726f30302c30004d6163426f6f6b50726f30302c30004d6163426f6f6b50726f30302c30004d6163426f6f6b50726f30302c30004d6163426f6f6b50726f30302c30004d6163426f6f6b50726f30302c30004d61636d696e69302c30004d61636d696e69302c30004d61636d696e69302c30004d616350726f302c30004d616350726f302c30"
var patched: String

if #available(macOS 10.15, *){
    ()
}else{
    printError("You're not using macOS 10.15 or later!")
}

if original.contains(patched_model_list){
    printError("Already patched!")
}

if !original.contains(original_model_list){
    printError("Not supported SidecarCore! or seems like damaged.")
}

if !(shell("csrutil status") == ("System Integrity Protection status: disabled.\n")){
    printError("System Integrity Protection is enabled.")
}

if !(shell("id -u") == "0\n"){
    printError("Must be run as root.")
}

patched = original
patched.replaceSubrange(original.range(of: original_model_list)!, with: patched_model_list)

if directoryExistsAtPath("/tmp/SidecarPatcher"){
    do {
        try fileManager.removeItem(atPath: "/tmp/SidecarPatcher")
    }
    catch let error as NSError {
        printError("\(error)")
    }
}

let temp_dir = URL(fileURLWithPath: "/tmp/").appendingPathComponent("SidecarPatcher").path
do{
    try fileManager.createDirectory(atPath: temp_dir, withIntermediateDirectories: true, attributes: nil)
} catch let error as NSError {
    printError("\(error)")
}

let patched_output_path = URL(fileURLWithPath: "/tmp/SidecarPatcher").appendingPathComponent("output.txt")
do {
    try patched.write(to: patched_output_path, atomically: true, encoding: String.Encoding.utf8)
} catch let error as NSError {
    printError("\(error)")
}
shell("xxd -r -p /tmp/SidecarPatcher/output.txt /tmp/SidecarPatcher/SidecarCore")

if fileManager.fileExists(atPath: "/System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore") {
    do {
        try fileManager.removeItem(atPath: "/System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore")
    }
    catch let error as NSError {
        printError("\(error)")
    }
}

do {
    try fileManager.copyItem(atPath: "/tmp/SidecarPatcher/SidecarCore", toPath: "/System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore")
}
catch let error as NSError {
    printError("\(error)")
}

shell("sudo codesign -f -s - /System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore")
print("Reboot your macOS.")
exit(0)
