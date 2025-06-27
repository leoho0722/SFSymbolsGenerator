//
//  SFSymbolsError.swift
//  SFSymbolsGenerator
//
//  Created by Leo Ho on 2025/06/27.
//

import Foundation

/// An enumeration representing application dependency errors during SF Symbols processing.
///
/// These errors occur when the required SF Symbols application or its components
/// are not properly installed or accessible on the system.
public enum ApplicationDependencyError: Error, CustomStringConvertible {

    /// The stable SF Symbols.app is not installed on the system
    case sfSymbolsNotInstalled

    /// The beta SF Symbols beta.app is not installed on the system
    case sfSymbolsBetaNotInstalled

    /// The SF Symbols application bundle is corrupted or invalid
    case applicationBundleCorrupted(path: String)

    /// The required metadata file was not found in the expected location
    case metadataFileNotFound(path: String)

    public var description: String {
        switch self {
        case .sfSymbolsNotInstalled:
            return
                "SF Symbols.app is not installed! Please download it from the Apple Developer Website."
        case .sfSymbolsBetaNotInstalled:
            return
                "SF Symbols beta.app is not installed! Please download it from the Apple Developer Website."
        case .applicationBundleCorrupted(let path):
            return "SF Symbols application bundle is corrupted or invalid at path: \(path)"
        case .metadataFileNotFound(let path):
            return "Required metadata file 'name_availability.plist' not found at path: \(path)"
        }
    }
}

/// An enumeration representing file system errors during SF Symbols processing.
///
/// These errors occur when file operations fail due to permissions, disk space,
/// or other file system related issues.
public enum FileSystemError: Error, CustomStringConvertible {

    /// Failed to write the generated Swift file to disk
    case fileWriteFailed(Error)

    /// The specified directory was not found or is not accessible
    case directoryNotAccessible(path: String)

    /// Insufficient permissions to perform file operations
    case permissionDenied(path: String)

    /// Insufficient disk space to complete the operation
    case diskSpaceInsufficient

    public var description: String {
        switch self {
        case .fileWriteFailed(let error):
            return "Failed to write file: \(error.localizedDescription)"
        case .directoryNotAccessible(let path):
            return "Directory not found or not accessible: \(path)"
        case .permissionDenied(let path):
            return "Permission denied for path: \(path)"
        case .diskSpaceInsufficient:
            return "Insufficient disk space to complete the operation"
        }
    }
}

/// An enumeration representing data processing errors during SF Symbols processing.
///
/// These errors occur when parsing or processing SF Symbols metadata fails
/// due to invalid format or corrupted data.
public enum DataProcessingError: Error, CustomStringConvertible {

    /// Failed to parse or serialize the property list file
    case propertyListSerializationFailed(Error)

    /// The data format is invalid or corrupted
    case invalidDataFormat(String)

    /// Required data fields are missing from the source
    case missingRequiredData(String)

    public var description: String {
        switch self {
        case .propertyListSerializationFailed(let error):
            return "Property list serialization failed: \(error.localizedDescription)"
        case .invalidDataFormat(let description):
            return "Invalid data format: \(description)"
        case .missingRequiredData(let description):
            return "Missing required data: \(description)"
        }
    }
}

/// An enumeration representing code generation errors during SF Symbols processing.
///
/// These errors occur during the Swift enumeration code generation process
/// when symbol names or templates cannot be properly processed.
public enum CodeGenerationError: Error, CustomStringConvertible {

    /// A symbol name conflicts with Swift keywords or conventions
    case invalidSymbolName(String)

    /// Failed to generate code from the template
    case templateGenerationFailed(Error)

    /// The specified enum name conflicts with existing types
    case enumNameConflict(String)

    public var description: String {
        switch self {
        case .invalidSymbolName(let symbol):
            return "Invalid symbol name that cannot be converted to Swift identifier: \(symbol)"
        case .templateGenerationFailed(let error):
            return "Template generation failed: \(error.localizedDescription)"
        case .enumNameConflict(let enumName):
            return "Enum name conflicts with existing types: \(enumName)"
        }
    }
}

/// An enumeration representing all possible errors that can occur during SF Symbols generation.
///
/// `SFSymbolsError` provides comprehensive error handling for the SFSymbolsGenerator tool
/// by categorizing errors into specific domains for better error handling and user experience.
///
/// ## Overview
///
/// The error types are organized into the following categories:
/// - **Application Dependencies**: Issues with SF Symbols app installation
/// - **File System**: File operations and disk access problems
/// - **Data Processing**: Metadata parsing and validation failures
/// - **Code Generation**: Swift code generation and template issues
///
/// Each category provides specific error information and actionable user messages.
///
/// - Author: Leo Ho
/// - Since: 1.3.0
public enum SFSymbolsError: Error, CustomStringConvertible {

    /// Application dependency related errors
    case applicationDependency(ApplicationDependencyError)

    /// File system operation related errors
    case fileSystem(FileSystemError)

    /// Data processing and parsing related errors
    case dataProcessing(DataProcessingError)

    /// Code generation related errors
    case codeGeneration(CodeGenerationError)

    /// An unexpected error that doesn't fit into other categories
    case unknown(Error)

    /// A human-readable description of the error.
    ///
    /// This property provides detailed error messages that help users understand
    /// what went wrong and how to potentially resolve the issue.
    ///
    /// - Returns: A localized string describing the error and potential solutions.
    public var description: String {
        switch self {
        case .applicationDependency(let error):
            return error.description
        case .fileSystem(let error):
            return error.description
        case .dataProcessing(let error):
            return error.description
        case .codeGeneration(let error):
            return error.description
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}
