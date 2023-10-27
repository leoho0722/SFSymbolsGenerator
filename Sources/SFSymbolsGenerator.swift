// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import Foundation

import ArgumentParser

@main
struct SFSymbolsGenerator: ParsableCommand {
    
    static let configuration = CommandConfiguration(abstract: "Simplifying SF Symbols Enumeration Generation with Swift!", 
                                                    version: "0.0.1")
    
    @Argument(
        help: "[Required] Specify filepath of output. Example: /Users/<YOUR_USERNAME>/Desktop"
    )
    var filepath: String
    
    @Option(
        name: .customLong("name"),
        help: "[Optional] Specify filename of output. Example: SFSymbols+Enum"
    )
    var filename: String = "SFSymbols+Enum"
    
    @Flag(
        name: [.customLong("use-beta")],
        help: "Whether use beta version of SF Symbols or not."
    )
    var isUseBeta: Bool = false
    
    mutating func run() throws {
        do {
            var appURL: URL!
            if isUseBeta {
                appURL = URL(fileURLWithPath: "/Applications/SF Symbols beta.app/Contents/Resources/Metadata/name_availability.plist")
            } else {
                appURL = URL(fileURLWithPath: "/Applications/SF Symbols.app/Contents/Resources/Metadata/name_availability.plist")
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
            writer.write(with: outputStream.capturedOutput, and: filename, to: filepath)
        } catch (let error as GenerateError) {
            switch error {
            case .unknown(_), .propertyList(_):
                print(error.description)
            case .notInstallSFSymbols, .notInstallSFSymbolsBeta:
                print("Error：\(error.description)")
            }
        }
    }
    
    private func readSymbolsAndYears(from fileURL: URL) throws -> ([SymbolTuple], Releases) {
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
}
