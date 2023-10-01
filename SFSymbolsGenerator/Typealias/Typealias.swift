//
//  Typealias.swift
//  SFSymbolsGenerator
//
//  Created by Leo Ho on 2023/10/2.
//

import Foundation

typealias ReleaseDate = String
typealias Symbol = String
typealias Symbols = [Symbol : ReleaseDate]
typealias Release = [String : String]
typealias Releases = [ReleaseDate : Release]
typealias SymbolTuple = (symbol: Symbol, released: ReleaseDate)
