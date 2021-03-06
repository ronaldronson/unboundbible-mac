//
//  Commentary.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation

class Commentary: Module {
    
    private var z = CommentaryAlias()
    
    override init?(atPath: String) {
        super.init(atPath: atPath)
        if format == .mybible { z = mybibleCommentaryAlias }
        if connected && !database!.tableExists(z.commentary) { return nil }
    }

    func getData(_ verse : Verse) -> [String]? {
        let id = encodeID(verse.book)
        let v_from = verse.number
        let v_to   = verse.number + verse.count - 1
        
        let query = "select * from \(z.commentary) " +
                    "where \(z.book) = \(id) " +
                    "and \(z.chapter) = \(verse.chapter) " +
                    "and (( \(v_from) between \(z.fromverse) and \(z.toverse) ) " +
                    "or ( \(z.fromverse) between \(v_from) and \(v_to) )) "
        
        var result = [String]()
        if let results = database!.executeQuery(query) {
            while results.next() {
                if let line = results.string(forColumn: z.data) {
                    if !line.isEmpty { result.append(line) }
                }
            }
        }
        return result.isEmpty ? nil : result
    }

    func getFootnote(_ verse: Verse, marker: String) -> String? {
        let id = encodeID(verse.book)
        let query = "select * from \(z.commentary) where \(z.book) = \(id) and \(z.chapter) = \(verse.chapter) and marker = \"\(marker)\" "
        if let results = database!.executeQuery(query) {
            if results.next() {
                return results.string(forColumn: z.data)
            }
        }
        return nil
    }
    
}

var commentaries = Commentaries()

class Commentaries {
    
    var items = [Commentary]()
    
    private func sort(_ s: String,_ language: String) -> String {
        if !cyrillic(language: languageCode) { return s }
        return cyrillic(language: language) ? " " + s : s
    }
    
    init() {
        load()
        items.sort(by: { sort($0.name, $0.language) < sort($1.name, $1.language) } )
    }
    
    private func load() {
        let files = databaseList().filter { $0.containsAny([".cmt.",".commentaries."]) }
        for file in files {
            if let item = Commentary(atPath: file) {
                items.append(item)
            }
        }
    }
    
    func getFootnote(module: String, verse: Verse, marker: String) -> String? {
        let name = module.lastPathComponentWithoutExtension
        
        for item in items {
            if !item.footnotes { continue }
            if !item.fileName.hasPrefix(name) { continue }
            return item.getFootnote(verse, marker: marker)
        }
        return nil
    }
    
}
