//
//  main.swift
//  SFSymbolsGenerator
//
//  Created by Leo Ho on 2023/10/2.
//

import Foundation

func readSymbolsAndYears(from fileURL: URL) -> ([SymbolTuple], Releases) {
    let data = try! Data(contentsOf: fileURL, options: .mappedIfSafe)
    let propertyList = try! PropertyListSerialization.propertyList(from: data,
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
}

let (sortedSymbolTuple, releaseYears) = readSymbolsAndYears(from: URL(fileURLWithPath: "/Applications/SF Symbols beta.app/Contents/Resources/Metadata/name_availability.plist"))

var outputStream = OutputStreamCapture()

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
