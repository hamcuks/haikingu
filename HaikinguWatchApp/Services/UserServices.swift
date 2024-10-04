//
//  UserServices.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 29/09/24.
//

import SwiftUI

enum UserType: String, CaseIterable {
    case leader
    case member
}
class UserServices: ObservableObject {
    @Published var userType: UserType = .leader
}
