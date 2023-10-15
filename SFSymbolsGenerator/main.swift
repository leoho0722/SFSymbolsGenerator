//
//  main.swift
//  SFSymbolsGenerator
//
//  Created by Leo Ho on 2023/10/2.
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

func readSymbolsAndYears(from fileURL: URL) throws -> ([SymbolTuple], Releases) {
    do {
        let data = try Data(contentsOf: fileURL, options: .mappedIfSafe)
        do {
            let propertyList = try PropertyListSerialization.propertyList(from: data,
                                                                          options: [],
                                                                          format: nil) as! Dictionary<String, Any>
            
            let symbols = propertyList["symbols"] as! Symbols
            let releases = propertyList["year_to_release"] as! Releases
            
            let releaseDatesFromSymbols = Set<ReleaseDate>(symbols.values)
            let releaseDatesFromReleases = Set<ReleaseDate>(releases.keys)
            
            assert(releaseDatesFromReleases.isSubset(of:releaseDatesFromSymbols),
                   "There are symbols with releasedates that have no release versions \(releaseDatesFromReleases) < \(releaseDatesFromSymbols)")
            
            let sortedSymbolTuple = symbols
                .sorted {
                    $0.value == $1.value ? $0.key < $1.key : $0.value < $1.value
                }
                .map {
                    SymbolTuple(symbol: $0.key, released: $0.value)
                }
            
            return (sortedSymbolTuple, releases)
        } catch {
            throw GenerateError.propertyList(error)
        }
    } catch {
        if fileURL.path().contains("SF%20Symbols.app") {
            throw GenerateError.notInstallSFSymbols
        } else if fileURL.path().contains("SF%20Symbols%20beta.app") {
            throw GenerateError.notInstallSFSymbolsBeta
        } else {
            throw GenerateError.unknown(error)
        }
    }
}

do {
    var appURL: URL!
    for argc in CommandLine.arguments {
        switch argc {
        case "--use-beta":
            appURL = URL(fileURLWithPath: "/Applications/SF Symbols beta.app/Contents/Resources/Metadata/name_availability.plist")
        default:
            appURL = URL(fileURLWithPath: "/Applications/SF Symbols.app/Contents/Resources/Metadata/name_availability.plist")
        }
    }
    
    let (sortedSymbolTuple, releaseYears) = try readSymbolsAndYears(from: appURL)
    
    let outputStream = OutputStreamCapture()
    
    outputStream.capturePrint(
"""
import Foundation

public enum SFSymbols: String, CaseIterable {\n
"""
    )
    
    for symbolTuple in sortedSymbolTuple {
        outputStream.capturePrint("    " + "/// SF Symbols's name：" + symbolTuple.symbol)
        outputStream.capturePrint("    @" + releaseYears[symbolTuple.released]!.availabilty + "\n    case " + symbolTuple.symbol.replacementName + " = \"" + symbolTuple.symbol + "\"\n" )
    }
    outputStream.capturePrint(
"""
    public static var allCases: [SFSymbols] {
        var allCases: [SFSymbols] = []\n
"""
    )
    
    for symbolTuple in sortedSymbolTuple {
        outputStream.capturePrint("        if #" + releaseYears[symbolTuple.released]!.availabilty + " {\n            allCases.append(SFSymbols." + symbolTuple.symbol.replacementName + ")\n        }\n")
    }
    outputStream.capturePrint(
"""
        return allCases
    }
}
"""
    )
    
    let writer = FileWriter()
    writer.write(with: outputStream.capturedOutput)
} catch (let error as GenerateError) {
    switch error {
    case .unknown(_), .propertyList(_):
        print(error.description)
    case .notInstallSFSymbols, .notInstallSFSymbolsBeta:
        print("Error：\(error.description)")
    }
    exit(0)
}
