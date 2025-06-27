//
//  Typealias.swift
//  SFSymbolsGenerator
//
//  Created by Leo Ho on 2023/10/27.
//

import Foundation

/// Type aliases used throughout the SFSymbolsGenerator for improved code clarity and maintainability.
///
/// These type aliases provide semantic meaning to common data structures used in the
/// SF Symbols generation process, making the code more readable and self-documenting.
///
/// ## Overview
///
/// The type aliases represent different aspects of SF Symbols metadata:
/// - **Symbol Information**: Names and release dates
/// - **Release Information**: OS version requirements
/// - **Data Structures**: Collections and tuples for processing
///
/// - Author: Leo Ho
/// - Since: 1.0.0

/// A string representing the release date of an SF Symbol (e.g., "2019", "2020")
typealias ReleaseDate = String

/// A string representing the name of an SF Symbol (e.g., "arrow.left", "star.fill")
typealias Symbol = String

/// A dictionary mapping SF Symbol names to their release dates
typealias Symbols = [Symbol: ReleaseDate]

/// A dictionary mapping operating systems to their minimum version requirements
typealias Release = [String: String]

/// A dictionary mapping release dates to their corresponding OS version requirements
typealias Releases = [ReleaseDate: Release]

/// A tuple containing an SF Symbol name and its release date for convenient processing
typealias SymbolTuple = (symbol: Symbol, released: ReleaseDate)
