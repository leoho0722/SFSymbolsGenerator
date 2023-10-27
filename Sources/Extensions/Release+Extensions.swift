//
//  Release+Extensions.swift
//  SFSymbolsGenerator
//
//  Created by Leo Ho on 2023/10/27.
//

import Foundation

extension Release {
    
    var availabilty: String {
        "available(" + self.map { os, version in
            os + " " + version
        }.sorted().joined(separator: ", ") + ", *)"
    }
}
