//
//  Version.swift
//  SFSymbolsGenerator
//
//  Created by Leo Ho on 2024/6/27.
//

import ArgumentParser
import Foundation

extension SFSymbolsGenerator {

    /// A command that displays the current version of SFSymbolsGenerator.
    ///
    /// The `VersionCommand` provides a simple way to check which version of the
    /// SFSymbolsGenerator tool is currently installed. This is useful for
    /// debugging, documentation, and ensuring compatibility.
    ///
    /// ## Usage
    ///
    /// ```bash
    /// sf-symbols-generator version
    /// ```
    ///
    /// ## Output
    ///
    /// The command outputs a formatted string showing the tool name and version:
    /// ```
    /// SFSymbolsGenerator version 1.3.0
    /// ```
    ///
    struct VersionCommand: AsyncParsableCommand {

        /// Configuration for the version subcommand
        static let configuration = CommandConfiguration(
            commandName: "version",
            abstract: "Show the version."
        )

        /// Displays the current version information.
        ///
        /// This method retrieves the version from the main command configuration
        /// and prints it in a user-friendly format.
        func run() async {
            print(
                "SFSymbolsGenerator version \(SFSymbolsGenerator.configuration.version)"
            )
        }
    }
}
