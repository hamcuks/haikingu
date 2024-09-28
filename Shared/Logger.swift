//
//  Logger.swift
//  HaikinguApp
//
//  Created by I Gusti Ngurah Surya Ardika Dinataputra on 28/09/24.
//

import Foundation
import os

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    #if os(watchOS)
    static let shared = Logger(subsystem: subsystem, category: "MirroringWorkoutsSampleForWatch")
    #else
    static let shared = Logger(subsystem: subsystem, category: "MirroringWorkoutsSample")
    #endif
}
