//
//  User.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 16/09/24.
//

import Foundation

struct User: Codable {
    let name: String
    let image: String
    let role: UserTypeEnum
}

enum UserTypeEnum: String, Codable {
    case leader
    case member
}
