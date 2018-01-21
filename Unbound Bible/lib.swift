//
//  lib.swift
//  ConsoleApp
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation
import Cocoa

let appName = "Unbound Bible"

let slash = "/"

let bibleDirectory = "bibles"
let titleDirectory = "titles"

let homeDirectory = NSHomeDirectory()
let   libraryPath = NSSearchPathForDirectoriesInDomains( .libraryDirectory, .userDomainMask, true)[0] as String
let dataPath = homeDirectory + slash + appName
//let appDataPath = libraryPath + slash + appName

let navyColor = NSColor(red:0.00, green:0.00, blue:0.50, alpha:1.0)

enum Errors : Error {
    case someError
    case someOtherError
}

//    func input() -> String {
//        let keyboard = FileHandle.standardInput
//        let inputData = keyboard.availableData
//        return NSString(data: inputData, encoding: String.Encoding.utf8.rawValue) as! String
//    }

func fileExists(_ path: String) -> Bool {
    let fileManager = FileManager.default
    return fileManager.fileExists(atPath: path)
}

func getFileList(_ path: String) -> [String] {
    do {
        let fileManager = FileManager.default
        let files = try fileManager.contentsOfDirectory(atPath: path)
        return files as [String]
    } catch {
        return []
    }
}

//    func getFileListWithExt(_ path: String, ext: String) -> [String] {
//     return getFileList(path).filter{ $0.hasSuffix(".\(ext)") }
//    }

func StringByDeletingPathExtension(_ path: String) -> String {
    return (NSURL(fileURLWithPath: path).deletingPathExtension?.lastPathComponent)! as String
}

func readFromFile(_ path: String) -> String {
    var text : String
    do {
        try text = NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as String
    }
    catch {
        return ""
    }
    return text
}

func writeToFile(_ path: String, value: String) -> Bool {
    do {
        try value.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
    } catch {
        return false
    }
    return true
}

func copyToClipboard(content: String) {
    let Pasteboard = NSPasteboard.general
    Pasteboard.clearContents()
    Pasteboard.writeObjects([content as NSString])
//  Pasteboard.writeObjects([attrString as NSMutableAttributedString])
}

func showClipboardContent(_ sender: NSButton) {
    let pb = NSPasteboard.general
    for item in pb.pasteboardItems ?? [] {
        if let str = item.string(forType: NSPasteboard.PasteboardType.string) {
            print(str)
        }
    }
}

func + (left: NSMutableAttributedString, right: NSMutableAttributedString) -> NSMutableAttributedString
{
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}

