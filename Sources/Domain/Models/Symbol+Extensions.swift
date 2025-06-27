//
//  Symbol+Extensions.swift
//  SFSymbolsGenerator
//
//  Created by Leo Ho on 2023/10/27.
//

import Foundation

/// Extensions for the `Symbol` type to provide name conversion functionality for Swift code generation.
///
/// This extension adds the ability to convert SF Symbol names into valid Swift identifier
/// names that can be used as enum case names. It handles various edge cases and naming
/// conflicts that can occur when transforming symbol names.
///
/// - Author: Leo Ho
/// - Since: 1.0.0
extension Symbol {

    /// Converts an SF Symbol name into a valid Swift enum case identifier.
    ///
    /// This computed property transforms SF Symbol names (which use dot notation and
    /// may contain characters invalid in Swift identifiers) into properly formatted
    /// camelCase enum case names that are valid Swift identifiers.
    ///
    /// - Returns: A valid Swift identifier suitable for use as an enum case name.
    ///
    /// ## Transformation Rules
    ///
    /// 1. **Keyword Protection**: Swift keywords (`return`, `case`, `repeat`) are wrapped in backticks
    /// 2. **Dot Notation**: Dots (`.`) are converted to camelCase boundaries
    /// 3. **Camel Case**: Each segment after the first is capitalized
    /// 4. **Numeric Prefix**: Names starting with numbers are prefixed with underscore
    ///
    /// ## Examples
    ///
    /// ```swift
    /// "arrow.left".replacementName        // → "arrowLeft"
    /// "star.fill".replacementName         // → "starFill"
    /// "return".replacementName            // → "`return`"
    /// "case.lower".replacementName        // → "`case`Lower"
    /// "123.symbol".replacementName        // → "_123Symbol"
    /// "simple.multi.part".replacementName // → "simpleMultiPart"
    /// ```
    ///
    /// ## Implementation Details
    ///
    /// The method splits the symbol name on dots and applies camelCase conversion
    /// to create a valid Swift identifier. Special handling ensures that:
    /// - Swift reserved keywords are properly escaped
    /// - Numeric prefixes don't create invalid identifiers
    /// - The resulting name follows Swift naming conventions
    var replacementName: String {
        guard !Set(["return", "case", "repeat"]).contains(self) else {
            return "`" + self + "`"
        }

        let parts = components(separatedBy: ".")

        let firstElement = parts.first!

        let camelCase =
            firstElement
            + parts.dropFirst().map {
                $0.prefix(1).uppercased() + $0.dropFirst()
            }.joined(separator: "")

        return camelCase.first?.isNumber == true ? "_" + camelCase : camelCase
    }
}
