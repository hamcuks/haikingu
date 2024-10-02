//
//  UserDefaultManager.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 02/10/24.
//

import Foundation

class UserDefaultManager: UserDefaultService {
    
    func saveuserData(user: User) {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        do {
            let encodedUser = try encoder.encode(user)
            defaults.set(encodedUser, forKey: "savedUser")
        } catch {
            print("Failed to encode user: \(error.localizedDescription)")
        }
    }
    
    func getUserData() -> User? {
        let defaults = UserDefaults.standard
        
        // Mengecek apakah data ada di UserDefaults
        if let savedUserData = defaults.data(forKey: "savedUser") {
            let decoder = JSONDecoder()
            do {
                // Decode data menjadi objek User
                let user = try decoder.decode(User.self, from: savedUserData)
                return user
            } catch {
                print("Failed to decode user: \(error.localizedDescription)")
            }
        }
        
        // Return nil jika tidak ada data yang tersimpan
        return nil
    }
    
    
}
