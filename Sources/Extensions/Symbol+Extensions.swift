//
//  Symbol+Extensions.swift
//  SFSymbolsGenerator
//
//  Created by Leo Ho on 2023/10/27.
//

import Foundation

extension Symbol {
    
    var replacementName: String {
        guard !Set(["return", "case", "repeat"]).contains(self) else {
            return "`" + self + "`"
        }
        
        let parts = components(separatedBy:".")
        
        let firstElement = parts.first!
        
        let camelCase = firstElement + parts.dropFirst().map {
            $0.prefix(1).uppercased() + $0.dropFirst()
        }.joined(separator: "")
        
        return camelCase.first?.isNumber == true ? "_" + camelCase : camelCase
    }
}
