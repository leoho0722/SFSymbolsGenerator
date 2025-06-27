//
//  Release+Extensions.swift
//  SFSymbolsGenerator
//
//  Created by Leo Ho on 2023/10/27.
//

import Foundation

/// Extensions for the `Release` type to provide convenient functionality for availability annotation generation.
///
/// This extension adds computed properties and methods to make it easier to work with
/// OS version release information when generating Swift availability annotations.
///
/// - Author: Leo Ho
/// - Since: 1.0.0
extension Release {

    /// Generates a properly formatted availability string for Swift `@available` attributes.
    ///
    /// This computed property transforms the release dictionary into a string that can be
    /// used directly in Swift `@available` annotations. The string includes all operating
    /// systems and their minimum version requirements, sorted alphabetically for consistency.
    ///
    /// - Returns: A formatted string suitable for use in `@available` attributes.
    ///
    /// ## Format
    ///
    /// The generated string follows the pattern:
    /// ```
    /// available(iOS 13.0, macOS 10.15, *)
    /// ```
    ///
    /// ## Example
    ///
    /// ```swift
    /// let release: Release = ["iOS": "13.0", "macOS": "10.15"]
    /// let annotation = release.availabilty
    /// // Result: "available(iOS 13.0, macOS 10.15, *)"
    ///
    /// // Usage in generated code:
    /// // @available(iOS 13.0, macOS 10.15, *)
    /// // case symbolName = "symbol.name"
    /// ```
    ///
    /// ## Sorting
    ///
    /// The operating systems are automatically sorted alphabetically to ensure
    /// consistent output across different runs of the generator.
    var availabilty: String {
        "available("
            + self.map { os, version in
                os + " " + version
            }.sorted().joined(separator: ", ") + ", *)"
    }
}
