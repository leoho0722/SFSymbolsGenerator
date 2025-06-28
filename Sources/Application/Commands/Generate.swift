//
//  Generate.swift
//  SFSymbolsGenerator
//
//  Created by Leo Ho on 2024/6/27.
//

import ArgumentParser
import Foundation

extension SFSymbolsGenerator {

    /// A command that generates Swift enumeration code for SF Symbols.
    ///
    /// The `GenerateCommand` reads symbol data from Apple's SF Symbols application,
    /// parses the metadata, and generates a Swift enumeration file with proper
    /// availability annotations for each symbol.
    ///
    /// ## Overview
    ///
    /// This command performs the following steps:
    /// 1. Locates the SF Symbols application (stable or beta version)
    /// 2. Reads the `name_availability.plist` file containing symbol metadata
    /// 3. Parses symbol names and their release dates
    /// 4. Generates Swift enumeration code with availability annotations
    /// 5. Writes the generated code to the specified output path
    ///
    /// ## Usage
    ///
    /// ```bash
    /// sf-symbols-generator generate /path/to/output [--name CustomName] [--enum-name CustomEnum] [--use-beta]
    /// ```
    ///
    /// ## Generated Code Structure
    ///
    /// The generated enumeration includes:
    /// - Raw string values for each SF Symbol
    /// - `@available` annotations based on symbol introduction dates
    /// - A custom `allCases` property that respects availability constraints
    /// - Proper handling of Swift keyword conflicts
    ///
    struct GenerateCommand: AsyncParsableCommand {

        /// Configuration for the generate subcommand
        static let configuration = CommandConfiguration(
            commandName: "generate",
            abstract: "Generate a Swift enumeration for SF Symbols."
        )

        /// The file system path where the generated Swift file will be saved.
        ///
        /// This should be a valid directory path where you have write permissions.
        /// The generated file will be named according to the `filename` parameter.
        ///
        /// - Example: `/Users/username/Desktop` or `/path/to/project/Sources`
        @Argument(
            help: "[Required] Specify filepath of output. Example: /Users/<YOUR_USERNAME>/Desktop"
        )
        var filepath: String

        /// The name of the output Swift file (without .swift extension).
        ///
        /// The default value is "SFSymbols+Enum", which will create a file named
        /// "SFSymbols+Enum.swift" in the specified output directory.
        ///
        /// - Default: "SFSymbols+Enum"
        @Option(
            name: .customLong("name"),
            help: "[Optional] Specify filename of output. Example: SFSymbols+Enum"
        )
        var filename: String = "SFSymbols+Enum"

        /// The name of the generated Swift enumeration.
        ///
        /// This controls the actual enum name in the generated Swift code.
        /// The default is "SFSymbols".
        ///
        /// - Default: "SFSymbols"
        @Option(
            name: .customLong("enum-name"),
            help: "[Optional] Specify enum name of output. Example: SFSymbols"
        )
        var enumName: String = "SFSymbols"

        /// Whether to use the beta version of SF Symbols application.
        ///
        /// When enabled, the tool will look for "SF Symbols beta.app" instead of
        /// the stable "SF Symbols.app". This allows access to symbols that are
        /// not yet available in the stable release.
        ///
        /// - Default: `false`
        @Flag(
            name: [.customLong("use-beta")],
            help: "Whether use beta version of SF Symbols or not."
        )
        var isUseBeta: Bool = false

        /// Executes the SF Symbols enumeration generation process.
        ///
        /// This method orchestrates the entire generation workflow:
        /// 1. Finds the appropriate SF Symbols application
        /// 2. Parses the symbol metadata from the plist file
        /// 3. Generates Swift enumeration code
        /// 4. Writes the output to the specified location
        ///
        /// - Throws: `SFSymbolsError` if any step in the process fails
        mutating func run() async throws {
            do {
                let plistURL = try SFSymbolsFinder.find(isBeta: isUseBeta)
                let (symbols, releases) = try await PlistParser.parse(from: plistURL)
                let content = CodeGenerator.generate(
                    from: symbols, releases: releases, enumName: enumName)
                try await FileWriter.write(content: content, to: filepath, with: filename)
                print("Successfully generated \(filename).swift at \(filepath)")
            } catch let error as SFSymbolsError {
                print("Error: \(error.description)")
            } catch {
                print("An unexpected error occurred: \(error.localizedDescription)")
            }
        }
    }
}
