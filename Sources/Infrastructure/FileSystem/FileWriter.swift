//
//  FileWriter.swift
//  SFSymbolsGenerator
//
//  Created by Leo Ho on 2023/10/27.
//

import Foundation

/// A utility struct for writing generated Swift code to the file system.
///
/// `FileWriter` handles the file operations required to save the generated
/// SF Symbols enumeration code to disk. It provides safe file writing with
/// proper error handling and automatic file replacement if needed.
///
/// ## Overview
///
/// The writer ensures that:
/// - Output directories exist and are writable
/// - Existing files are safely replaced
/// - Content is written with proper encoding (UTF-8)
/// - File operations are performed atomically when possible
///
/// ## File Management
///
/// If a file already exists at the target location, it will be automatically
/// removed before writing the new content. This ensures that the generated
/// code is always up-to-date and prevents conflicts with previous versions.
///
/// - Author: Leo Ho
/// - Since: 1.0.0
struct FileWriter {

    /// Writes the generated Swift code content to a file at the specified location.
    ///
    /// This method creates a Swift file with the provided content at the given path.
    /// If a file with the same name already exists, it will be replaced with the
    /// new content.
    ///
    /// - Parameters:
    ///   - content: The Swift source code content to write to the file.
    ///   - path: The directory path where the file should be created.
    ///   - name: The filename (without extension) for the generated Swift file.
    ///
    /// - Throws: `SFSymbolsError.fileSystem(.fileWriteFailed)` if any file operation fails,
    ///           including directory access, file removal, or content writing.
    ///
    /// ## File Creation Process
    ///
    /// 1. Constructs the full file path with `.swift` extension
    /// 2. Checks if a file already exists at the target location
    /// 3. Removes the existing file if present
    /// 4. Writes the new content atomically with UTF-8 encoding
    ///
    /// ## Example
    ///
    /// ```swift
    /// let swiftCode = "public enum SFSymbols: String { ... }"
    /// try await FileWriter.write(
    ///     content: swiftCode,
    ///     to: "/Users/username/Desktop",
    ///     with: "SFSymbols+Enum"
    /// )
    /// // Creates: /Users/username/Desktop/SFSymbols+Enum.swift
    /// ```
    ///
    static func write(
        content: String,
        to path: String,
        with name: String
    ) async throws {
        let fileManager = FileManager.default
        let fileURL = URL(fileURLWithPath: path).appendingPathComponent("\(name).swift")

        do {
            if fileManager.fileExists(atPath: fileURL.path) {
                try fileManager.removeItem(at: fileURL)
            }
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            throw SFSymbolsError.fileSystem(.fileWriteFailed(error))
        }
    }
}
