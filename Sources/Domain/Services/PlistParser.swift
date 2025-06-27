//
//  PlistParser.swift
//  SFSymbolsGenerator
//
//  Created by Leo Ho on 2024/6/27.
//

import Foundation

/// A utility struct for parsing SF Symbols metadata from property list files.
///
/// `PlistParser` is responsible for reading and parsing the `name_availability.plist`
/// file from the SF Symbols application. This file contains crucial metadata about
/// symbol names, their release dates, and availability information across different
/// operating system versions.
///
/// ## Overview
///
/// The parser handles the complex structure of the SF Symbols metadata plist, which
/// contains:
/// - Symbol names mapped to their release dates
/// - Release date information mapped to OS version requirements
/// - Proper error handling for malformed data
///
/// ## Plist Structure
///
/// The expected structure of the `name_availability.plist`:
/// ```
/// {
///   "symbols": {
///     "symbol.name": "release_date",
///     ...
///   },
///   "year_to_release": {
///     "release_date": {
///       "iOS": "version",
///       "macOS": "version",
///       ...
///     }
///   }
/// }
/// ```
///
/// - Author: Leo Ho
/// - Since: 1.3.0
struct PlistParser {

    /// Parses SF Symbols metadata from a property list file.
    ///
    /// This method reads the specified plist file, validates its structure, and
    /// extracts symbol information along with release data. The symbols are
    /// automatically sorted by release date and then alphabetically by name.
    ///
    /// - Parameters:
    ///   - url: The file URL pointing to the `name_availability.plist` file
    ///           within the SF Symbols application bundle.
    ///
    /// - Returns: A tuple containing:
    ///           - An array of `SymbolTuple` objects sorted by release date and name
    ///           - A `Releases` dictionary mapping release dates to OS version requirements
    ///
    /// - Throws: `SFSymbolsError.dataProcessing(.propertyListSerializationFailed)` if the file cannot
    ///           be read or parsed, or if the plist structure is invalid.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let plistURL = try SFSymbolsFinder.find(isBeta: false)
    /// let (symbols, releases) = try await PlistParser.parse(from: plistURL)
    ///
    /// for symbol in symbols {
    ///     print("Symbol: \(symbol.symbol), Released: \(symbol.released)")
    /// }
    /// ```
    static func parse(from url: URL) async throws -> ([SymbolTuple], Releases) {
        do {
            let data = try Data(contentsOf: url)
            let propertyList = try PropertyListSerialization.propertyList(
                from: data,
                options: [],
                format: nil
            )
            guard let plistDict = propertyList as? [String: Any],
                let symbols = plistDict["symbols"] as? Symbols,
                let releases = plistDict["year_to_release"] as? Releases
            else {
                throw SFSymbolsError.dataProcessing(
                    .invalidDataFormat(
                        "Invalid plist format: missing required 'symbols' or 'year_to_release' keys"
                    )
                )
            }

            let sortedSymbolTuple =
                symbols
                .sorted {
                    $0.value == $1.value ? $0.key < $1.key : $0.value < $1.value
                }
                .map {
                    SymbolTuple(symbol: $0.key, released: $0.value)
                }

            return (sortedSymbolTuple, releases)
        } catch {
            throw SFSymbolsError.dataProcessing(.propertyListSerializationFailed(error))
        }
    }
}
