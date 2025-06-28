//
//  SFSymbolsGenerator.swift
//  SFSymbolsGenerator
//
//  Created by Leo Ho on 2023/10/27.
//

import ArgumentParser
import Foundation

/// The main entry point for the SFSymbolsGenerator command-line tool.
///
/// SFSymbolsGenerator is a Swift-based command-line utility that simplifies the generation
/// of Swift enumeration code for SF Symbols. It reads symbol data from Apple's SF Symbols
/// application and creates type-safe enumerations with availability annotations.
///
/// ## Overview
///
/// This tool provides two main commands:
/// - `generate`: Creates Swift enumeration code from SF Symbols data
/// - `version`: Displays the current version of the tool
///
/// ## Usage
///
/// ```bash
/// sf-symbols-generator generate <output-path> [options]
/// sf-symbols-generator version
/// ```
///
/// ## Features
///
/// - Supports both stable and beta versions of SF Symbols
/// - Generates availability annotations for proper iOS/macOS version support
/// - Creates type-safe Swift enumerations
/// - Handles symbol name conflicts with Swift keywords
/// - Customizable output file and enum names
///
@main
struct SFSymbolsGenerator: AsyncParsableCommand {

    /// The configuration for the command-line interface
    static let configuration = CommandConfiguration(
        commandName: "sf-symbols-generator",
        abstract: "Simplifying SF Symbols Enumeration Generation with Swift!",
        version: "1.3.1",
        subcommands: [GenerateCommand.self, VersionCommand.self],
    )
}
