//
//  Logger.swift
//  HaikinguApp
//
//  Created by I Gusti Ngurah Surya Ardika Dinataputra on 29/09/24.
//

import Foundation
import os

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    #if os(watchOS)
    static let shared = Logger(subsystem: subsystem, category: "HaikinguWatchApp")
    #else
    static let shared = Logger(subsystem: subsystem, category: "HaikinguApp")
    #endif
}
