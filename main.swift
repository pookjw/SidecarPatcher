/*
SidecarPatcher - Version 14

Enabling Sidecar on old Mac (2015 or older)
But I don't have Sidecar-unsupported Mac so I don't know it works.

THIS SCRIPT DOESN'T MAKE SidecarCore BACKUP SO YOU HAVE TO DO THIS MANUALLY. PLEASE BACKUP /System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore. PLEASE. PLEASE. PLEASE.
And after patching SidecarCore, this script won't work until replacing to original one.
This script requires disabling SIP, and running as root.
*/

import Foundation

// Run Shell script on Swift from https://gitlab.com/cyril_j/mutils/blob/master/Swift/Exec_shell.swift
@discardableResult
func shell(_ arguments: String, show_log: Bool = false) -> String {
    let task = Process();
    task.launchPath = "/bin/zsh"
    var environment = ProcessInfo.processInfo.environment
    environment["PATH"] = "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    task.environment = environment
    task.arguments = ["-c", arguments]
        
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = String(data: data, encoding: String.Encoding.utf8)!
    task.waitUntilExit()
    pipe.fileHandleForReading.closeFile()
    
    if show_log && output != "" {
        print(output)
    }
    return output
}

// Check directory exists from https://gist.github.com/brennanMKE/a0a2ee6aa5a2e2e66297c580c4df0d66
extension FileManager {
    static func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
}

// Color Scheme from https://github.com/pookjw/SwiftANSIColors
enum ANSIColors: String {
    case black = "\u{001B}[0;30m"
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case yellow = "\u{001B}[0;33m"
    case blue = "\u{001B}[0;34m"
    case magenta = "\u{001B}[0;35m"
    case cyan = "\u{001B}[0;36m"
    case white = "\u{001B}[0;37m"
    case `default` = "\u{001B}[0;0m"
}
func + (left: ANSIColors, right: String) -> String {
    return left.rawValue + right
}
func + (left: String, right: ANSIColors) -> String {
    return left + right.rawValue
}

// Check system that patch is eligible
func checkSystem() {
    // Check OS
    if #available(macOS 10.15, *) {
        ()
    } else {
        fatalError(ANSIColors.red + "You're not using macOS 10.15 or later!" + ANSIColors.default)
    }
    
    // Check SIP status
    if !(shell("csrutil status") == "System Integrity Protection status: disabled.\n") && !(shell("csrutil status").contains("Filesystem Protections: disabled")) {
        fatalError(ANSIColors.red + "Filesystem Protections of System Integrity Protection is enabled" + ANSIColors.default)
    }
    
    // Check privilege
    if !(shell("id -u") == "0\n") {
        fatalError(ANSIColors.red + "Must be run as root" + ANSIColors.default)
    }
}

// Sign SidecarCore from https://github.com/ben-z/free-sidecar/issues/59#issuecomment-603953953
func signSidecarCore(sidecarCore: URL) {
    if #available(macOS 10.15.4, *){
        shell("sudo nvram boot-args=\"amfi_get_out_of_my_way=0x1\"", show_log: true)
    }
    shell("sudo codesign -f -s - \"\(sidecarCore.path)\"", show_log: true)
    shell("sudo chmod 755 \"\(sidecarCore.path)\"", show_log: true)
}

// Patch methods from ben-z/free-sidecar
// @START //
// https://qiita.com/fromage-blanc/items/15731a1d3e6be1c5f56f
extension UnicodeScalar {
    var hexNibble:UInt8 {
        let value = self.value
        if 48 <= value && value <= 57 {
            return UInt8(value - 48)
        }
        else if 65 <= value && value <= 70 {
            return UInt8(value - 55)
        }
        else if 97 <= value && value <= 102 {
            return UInt8(value - 87)
        }
        fatalError("\(self) not a legal hex nibble")
    }
}
extension Data {
    init(hex:String) {
        let scalars = hex.unicodeScalars
        var bytes = Array<UInt8>(repeating: 0, count: (scalars.count + 1) >> 1)
        for (index, scalar) in scalars.enumerated() {
            var nibble = scalar.hexNibble
            if index & 1 == 0 {
                nibble <<= 4
            }
            bytes[index >> 1] |= nibble
        }
        self = Data(bytes)
    }
}

// https://stackoverflow.com/a/40089462
extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}

struct StringMatchResult {
    let matchedStr: String
    let range: NSRange
}

extension String
{
    func match(pattern: String) -> [[StringMatchResult]]
    {
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        {
            let string = self as NSString

            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map { match in
                let res: Array<String> = Array(repeating: "", count: match.numberOfRanges)
                return res.enumerated().map { (idx, _) in
                    return StringMatchResult(matchedStr: string.substring(with: match.range(at: idx)), range: match.range(at: idx))
                }
            }
        }

        return []
    }
}

let devices = ["iMac", "MacBookAir", "MacBookPro", "Macmini", "MacPro", "MacBook", "iPad"]

let hexDict = [
    "iMac": Data("iMac".utf8).hexEncodedString(options: [.upperCase]),
    "MacBook": Data("MacBook".utf8).hexEncodedString(options: [.upperCase]),
    "MacBookAir": Data("MacBookAir".utf8).hexEncodedString(options: [.upperCase]),
    "MacBookPro": Data("MacBookPro".utf8).hexEncodedString(options: [.upperCase]),
    "Macmini": Data("Macmini".utf8).hexEncodedString(options: [.upperCase]),
    "MacPro": Data("MacPro".utf8).hexEncodedString(options: [.upperCase]),
    "iPad": Data("iPad".utf8).hexEncodedString(options: [.upperCase]),
    ",": Data(",".utf8).hexEncodedString(options: [.upperCase]),
    " ": "00",
]

func hexToString(hex: String) -> String? {
    return String(data: Data(hex: hex), encoding: .ascii)
}

struct Model {
    let hex: String
    let str: String
    let type: String
    let model: Int
    let modelHex: String
    let modelHexRange: NSRange
    let version: Int
    let enabled: Bool
}

func dostuff2(sidecarCore: URL) -> [Model] {
    if let contents =  FileManager.default.contents(atPath: sidecarCore.path) {
        let hexStr = contents.hexEncodedString(options: [.upperCase])
        
        let devicesStr = devices.map{ hexDict[$0]! }.joined(separator: "|")
        let matched = hexStr.match(pattern: "(\(devicesStr))((?:(?!\(hexDict[" "]!))[0-9A-Z])+)\(hexDict[","]!)((?:(?!\(hexDict[" "]!))[0-9A-Z])+)\(hexDict[" "]!)")
        
        let models = matched.map({ res -> Model in
            let hex = res[0].matchedStr
            let type = hexToString(hex: res[1].matchedStr)!
            let modelHex = res[2].matchedStr
            let modelHexRange = res[2].range
            let model = Int(String(data: Data([UInt8](Data(hex: modelHex)).map { $0 & ~0xC0 }), encoding: .ascii)!)!
            let version = Int(hexToString(hex: res[3].matchedStr)!)!
            let enabled = [UInt8](Data(hex: modelHex))[0] & 0xC0 != 0
            let str = "\(type)\(model),\(version)"

            return Model(hex: hex, str: str, type: type, model: model, modelHex: modelHex, modelHexRange: modelHexRange, version: version, enabled: enabled)
        })
        
        print("matched: \(models.count)")
        
        return models
    }
    return []
}

func patch(model: [Model], sidecarCore: URL) {
    shell("sudo mount -uw /")
    guard var replacementData = FileManager.default.contents(atPath: sidecarCore.path) else {
        fatalError(ANSIColors.red + "Failed to load SidecarCore." + ANSIColors.default)
    }
    
    for tmp in model {
        if tmp.enabled {
            continue
        }
        let hexStr = replacementData.hexEncodedString(options: [.upperCase])
        
        // Mask the model number
        let replacementModelHex = Data([UInt8](Data(hex: tmp.modelHex)).map { $0 | 0xC0 }).hexEncodedString(options: [.upperCase])
        
        // Generate a new string
        let replacementHexStr = (hexStr as NSString).replacingOccurrences(of: tmp.modelHex, with: replacementModelHex, range: tmp.modelHexRange)
        replacementData = Data(hex: replacementHexStr)
    }
    
    // Write to file
    do {
        try replacementData.write(to: sidecarCore)
    } catch {
        fatalError("\(error)")
    }
}

func unpatch(model: [Model], sidecarCore: URL) {
    shell("sudo mount -uw /")
    guard var replacementData = FileManager.default.contents(atPath: sidecarCore.path) else {
        fatalError(ANSIColors.red + "Failed to load SidecarCore." + ANSIColors.default)
    }
    
    for tmp in model {
        if !tmp.enabled {
            continue
        }
        let hexStr = replacementData.hexEncodedString(options: [.upperCase])
        
        // Mask the model number
        let replacementModelHex = Data([UInt8](Data(hex: tmp.modelHex)).map { $0 & ~0xC0 }).hexEncodedString(options: [.upperCase])
        
        // Generate a new string
        let replacementHexStr = (hexStr as NSString).replacingOccurrences(of: tmp.modelHex, with: replacementModelHex, range: tmp.modelHexRange)
        replacementData = Data(hex: replacementHexStr)
    }
    
    // Write to file
    do {
        print("HIhHI")
        try replacementData.write(to: sidecarCore)
    } catch {
        fatalError("\(error)")
    }
}
// @END //

// main
print("SidecarPatcher (Version 14)")
print("GitHub : https://github.com/pookjw/SidecarPatcher") // don't erase this
checkSystem()
let url = URL(fileURLWithPath: "/System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore")
let models: [Model] = dostuff2(sidecarCore: url)
patch(model: models, sidecarCore: url)
//unpatch(model: models, sidecarCore: url)
signSidecarCore(sidecarCore: url)
