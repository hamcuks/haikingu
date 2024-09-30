//
//  Hiker.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 30/09/24.
//

import Foundation
import UIKit

enum HikerStateEnum { case joined, waiting, rejected, notJoined }

struct Hiker: Hashable {
    var id: UUID
    var name: String
    var avatar: UIImage?
    var state: HikerStateEnum = .notJoined
    
    static func == (lhs: Hiker, rhs: Hiker) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Hiking: Codable {
    var id: String
    var name: String
    var trackLength: Int
    var elevation: Int
}
