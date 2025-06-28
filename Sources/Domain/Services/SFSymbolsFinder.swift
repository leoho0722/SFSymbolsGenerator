//
//  SFSymbolsFinder.swift
//  SFSymbolsGenerator
//
//  Created by Leo Ho on 2025/06/27.
//

import Foundation

/// A utility struct for locating SF Symbols applications and their metadata files.
///
/// `SFSymbolsFinder` is responsible for discovering the SF Symbols application
/// installation on the system and locating the `name_availability.plist` file
/// that contains symbol metadata.
///
/// ## Overview
///
/// The finder supports both stable and beta versions of the SF Symbols application:
/// - **Stable**: `SF Symbols.app`
/// - **Beta**: `SF Symbols beta.app`
///
/// The tool searches through all application directories in the system and
/// validates that the required metadata file exists within the application bundle.
///
/// ## File Structure
///
/// The expected path to the metadata file within the SF Symbols app:
/// ```
/// SF Symbols.app/Contents/Resources/Metadata/name_availability.plist
/// ```
///
/// - Author: Leo Ho
/// - Since: 1.3.0
struct SFSymbolsFinder {

    /// Finds the SF Symbols application and returns the URL to its metadata plist file.
    ///
    /// This method searches through all application directories on the system to locate
    /// the appropriate SF Symbols application (stable or beta) and validates that the
    /// required `name_availability.plist` file exists.
    ///
    /// - Parameters:
    ///   - isBeta: A Boolean value indicating whether to search for the beta
    ///     version (`SF Symbols beta.app`) or the stable version
    ///     (`SF Symbols.app`) of the application.
    ///
    /// - Returns: A URL pointing to the `name_availability.plist` file within the
    ///   SF Symbols application bundle.
    ///
    /// - Throws: `SFSymbolsError.applicationDependency(.sfSymbolsNotInstalled)` if the stable version is not found.
    /// - Throws: `SFSymbolsError.applicationDependency(.sfSymbolsBetaNotInstalled)` if the beta version is not found.
    /// - Throws: `SFSymbolsError.applicationDependency(.metadataFileNotFound)` if the application is found
    ///           but the required plist file is missing.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Find stable version
    /// let stablePlistURL = try SFSymbolsFinder.find(isBeta: false)
    ///
    /// // Find beta version
    /// let betaPlistURL = try SFSymbolsFinder.find(isBeta: true)
    /// ```
    ///
    static func find(isBeta: Bool) throws -> URL {
        let fileManager = FileManager.default
        let appName = isBeta ? "SF Symbols beta.app" : "SF Symbols.app"
        let applicationsDirectories = fileManager.urls(
            for: .applicationDirectory,
            in: .allDomainsMask
        )

        for directory in applicationsDirectories {
            let appURL = directory.appendingPathComponent(appName)
            if fileManager.fileExists(atPath: appURL.path) {
                let plistURL = appURL.appendingPathComponent(
                    "Contents/Resources/Metadata/name_availability.plist")
                if fileManager.fileExists(atPath: plistURL.path) {
                    return plistURL
                } else {
                    throw SFSymbolsError.applicationDependency(
                        .metadataFileNotFound(path: plistURL.path)
                    )
                }
            }
        }

        if isBeta {
            throw SFSymbolsError.applicationDependency(.sfSymbolsBetaNotInstalled)
        } else {
            throw SFSymbolsError.applicationDependency(.sfSymbolsNotInstalled)
        }
    }
}
