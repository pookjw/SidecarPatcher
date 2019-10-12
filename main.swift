/*
    SidecarPatcher - Version 9

    Enabling Sidecar on old Mac (2015 or older)
    But I don't have Sidecar-unsupported Mac so I don't know it works.

    THIS SCRIPT DOESN'T MAKE SidecarCore BACKUP SO YOU HAVE TO DO THIS MANUALLY. PLEASE BACKUP /System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore. PLEASE. PLEASE. PLEASE.
    And after patching SidecarCore, this script won't work until replacing to original one.
    This script requires disabling SIP, and running as root.
*/
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

// From https://gist.github.com/brennanMKE/a0a2ee6aa5a2e2e66297c580c4df0d66
fileprivate func directoryExistsAtPath(_ path: String) -> Bool {
    var isDirectory = ObjCBool(true)
    let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
    return exists && isDirectory.boolValue
}

func importCore(path: String) -> String{
    return shell("xxd -p \"\(path)/SidecarCore\" | tr -d '\n'")
}

func checkSystem(core: String, code: [String: PatchCode]) -> [PatchCode]{
    var result: [PatchCode] = []
    
    // Check OS
    if #available(macOS 10.15, *){
        ()
    }else{
        assertionFailure("You're not using macOS 10.15 or later!")
    }
    
    // Check the system is patched (macModel and iPadModel)
    for (_, value) in code{
        if !core.contains(value.patched){
            result.append(value)
        }
    }
    if result.isEmpty{
        assertionFailure("Already patched!")
    }
    
    // Check SidecarCore is damaged
    for value in result{
        if !core.contains(value.original){
            assertionFailure("Not supported SidecarCore! or seems like damaged")
        }
    }
    
    // Check SIP status
    if !(shell("csrutil status") == ("System Integrity Protection status: disabled.\n")){
        assertionFailure("System Integrity Protection is enabled")
    }
    
    // Check privilege
    if !(shell("id -u") == "0\n"){
        assertionFailure("Must be run as root")
    }
    
    // return patch code
    return result
}

func patch(core: String, code: [PatchCode]) -> String{
    var core = core
    for value in code{
        core.replaceSubrange(core.range(of: value.original)!, with: value.patched)
    }
    return core
}

func exportCore(core: String, path: String){
    // Remove existing tmp dir
    if directoryExistsAtPath("/tmp/SidecarPatcher"){
        do {
            try fileManager.removeItem(atPath: "/tmp/SidecarPatcher")
        }
        catch let error as NSError {
            assertionFailure("\(error)")
        }
    }

    // Create temp dir
    let temp_dir = URL(fileURLWithPath: "/tmp/").appendingPathComponent("SidecarPatcher").path
    do{
        try fileManager.createDirectory(atPath: temp_dir, withIntermediateDirectories: true, attributes: nil)
    } catch let error as NSError {
        assertionFailure("\(error)")
    }

    // Export code
    let output_path = URL(fileURLWithPath: "/tmp/SidecarPatcher").appendingPathComponent("output.txt")
    do {
        try core.write(to: output_path, atomically: true, encoding: String.Encoding.utf8)
    } catch let error as NSError {
        assertionFailure("\(error)")
    }
    shell("xxd -r -p /tmp/SidecarPatcher/output.txt /tmp/SidecarPatcher/SidecarCore")

    // Mount system (thanks to: https://github.com/pookjw/SidecarPatcher/issues/1)
    shell("sudo mount -uw /")
    
    // Remove existing original system file
    if fileManager.fileExists(atPath: "\(path)/SidecarCore") {
        do {
            try fileManager.removeItem(atPath: "\(path)/SidecarCore")
        }
        catch let error as NSError {
            assertionFailure("\(error)")
        }
    }
    

    // Copy system file
    do {
        try fileManager.copyItem(atPath: "/tmp/SidecarPatcher/SidecarCore", toPath: "\(path)/SidecarCore")
    }
    catch let error as NSError {
        assertionFailure("\(error)")
    }

    // codesign
    shell("sudo codesign -f -s - \"\(path)/SidecarCore\"")
    shell("sudo chmod 755 \"\(path)/SidecarCore\"")
}

struct PatchCode{
    var original: String
    var patched: String
}

let fileManager = FileManager()
let SidecarCorePath = "/System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A"
var patchDictionary: [String: PatchCode] = [:]
patchDictionary["Mac"] = PatchCode(original: "694d616331332c3100694d616331332c3200694d616331332c3300694d616331342c3100694d616331342c3200694d616331342c3300694d616331342c3400694d616331352c3100694d616331362c3100694d616331362c32004d6163426f6f6b382c31004d6163426f6f6b416972352c31004d6163426f6f6b416972352c32004d6163426f6f6b416972362c31004d6163426f6f6b416972362c32004d6163426f6f6b416972372c31004d6163426f6f6b416972372c32004d6163426f6f6b50726f392c31004d6163426f6f6b50726f392c32004d6163426f6f6b50726f31302c31004d6163426f6f6b50726f31302c32004d6163426f6f6b50726f31312c31004d6163426f6f6b50726f31312c32004d6163426f6f6b50726f31312c33004d6163426f6f6b50726f31312c34004d6163426f6f6b50726f31312c35004d6163426f6f6b50726f31322c31004d61636d696e69362c31004d61636d696e69362c32004d61636d696e69372c31004d616350726f352c31004d616350726f362c31", patched: "694d616330302c3000694d616330302c3000694d616330302c3000694d616330302c3000694d616330302c3000694d616330302c3000694d616330302c3000694d616330302c3000694d616330302c3000694d616330302c30004d6163426f6f6b302c30004d6163426f6f6b416972302c30004d6163426f6f6b416972302c30004d6163426f6f6b416972302c30004d6163426f6f6b416972302c30004d6163426f6f6b416972302c30004d6163426f6f6b416972302c30004d6163426f6f6b50726f302c30004d6163426f6f6b50726f302c30004d6163426f6f6b50726f30302c30004d6163426f6f6b50726f30302c30004d6163426f6f6b50726f30302c30004d6163426f6f6b50726f30302c30004d6163426f6f6b50726f30302c30004d6163426f6f6b50726f30302c30004d6163426f6f6b50726f30302c30004d6163426f6f6b50726f30302c30004d61636d696e69302c30004d61636d696e69302c30004d61636d696e69302c30004d616350726f302c30004d616350726f302c30")
patchDictionary["iPad"] = PatchCode(original: "69506164342c310069506164342c320069506164342c330069506164342c340069506164342c350069506164342c360069506164342c370069506164342c380069506164342c390069506164352c310069506164352c320069506164352c330069506164352c340069506164362c31310069506164362c3132", patched: "69506164302c300069506164302c300069506164302c300069506164302c300069506164302c300069506164302c300069506164302c300069506164302c300069506164302c300069506164302c300069506164302c300069506164302c300069506164302c300069506164302c30300069506164302c3030")

print("GitHub : https://github.com/pookjw/SidecarPatcher")
let originalCore = importCore(path: SidecarCorePath) // get code
let patchToCode = checkSystem(core: originalCore, code: patchDictionary) // check availability and get patch code
let patchedCore = patch(core: originalCore, code: patchToCode) // patch code
exportCore(core: patchedCore, path: SidecarCorePath) // copy patched code to system
print("Reboot your macOS.")
