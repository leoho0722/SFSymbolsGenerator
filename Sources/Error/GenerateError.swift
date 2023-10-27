//
//  GenerateError.swift
//  SFSymbolsGenerator
//
//  Created by Leo Ho on 2023/10/27.
//

import Foundation

enum GenerateError: Error, CustomStringConvertible {
    
    case unknown(Error)
    
    case notInstallSFSymbols
    
    case notInstallSFSymbolsBeta
    
    case propertyList(Error)
    
    var description: String {
        switch self {
        case .unknown(let error):
            "Unknown Error: \(error.localizedDescription)"
        case .notInstallSFSymbols:
            "SF Symbols.app is not installed yet! Please go to Apple Developer Website to download!"
        case .notInstallSFSymbolsBeta:
            "SF Symbols beta.app is not installed yet! Please go to Apple Developer Website to download!"
        case .propertyList(let error):
            "PropertyList Error: \(error.localizedDescription)"
        }
    }
}
