//
//  UserDefaultServices.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 02/10/24.
//

import Foundation

protocol UserDefaultService {
    func getUserData() -> User?
    func saveuserData(user: User)
}
