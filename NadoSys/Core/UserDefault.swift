//
//  UserDefault.swift
//  Recruiment
//
//  Created by Nguyen Phuc Long on 3/22/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//
import Foundation

struct Defaults{
    var name: String
    var email: String
    var id: String
    
    static var saveuser = { (key: String,value: LoginModel) in
        if let encoded = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    static func getUser(key: String) -> LoginModel?{
        if let loginData = UserDefaults.standard.data(forKey: key),
            let login = try? JSONDecoder().decode(LoginModel.self, from: loginData) {
            return login
        }
        return nil
    }
    
    static func clearUserData(key: String){
        UserDefaults.standard.removeObject(forKey: key)
    }
}
