//
//  UserPreferences.swift
//  CombineTest
//
//  Created by 劉陶恩 on 2023/2/2.
//

import Foundation

class GlobalAppSetting{
    static  let shared = GlobalAppSetting()
    private let userPreferences: UserDefaults
    private init() {self.userPreferences = UserDefaults.standard}
    
    func resetUserDefault(){
        let domin = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domin)
    }
    
    enum UserPreference: String{
        case isBLEConnect
        case appstate
        case userName
        case isSignIn
        case isSignOut
        case isFirstSignIn
        case birthDay
        case name
    }
    
    var isBLEConnect: Bool{
        get {return userPreferences.bool(forKey: UserPreference.isBLEConnect.rawValue)}
        set {userPreferences.set(newValue, forKey: UserPreference.isBLEConnect.rawValue)}
    }
    var userName: String{
        get{ return userPreferences.string(forKey: UserPreference.userName.rawValue) ?? ""}
        set{userPreferences.set(newValue, forKey: UserPreference.userName.rawValue) }
    }
    var isSignIn: Bool{
        get {return userPreferences.bool(forKey: UserPreference.isSignIn.rawValue)}
        set {userPreferences.set(newValue, forKey: UserPreference.isSignIn.rawValue)}
    }
    var isFirstSignIn: Bool{
        get {return userPreferences.bool(forKey: UserPreference.isFirstSignIn.rawValue)}
        set {userPreferences.set(newValue, forKey: UserPreference.isFirstSignIn.rawValue)}
    }
    var isSignOut: Bool{
        get {return userPreferences.bool(forKey: UserPreference.isBLEConnect.rawValue)}
        set {userPreferences.set(newValue, forKey: UserPreference.isBLEConnect.rawValue)}
    }
    var birthDay: String{
        get{ return userPreferences.string(forKey: UserPreference.birthDay.rawValue) ?? ""}
        set{userPreferences.set(newValue, forKey: UserPreference.birthDay.rawValue) }
    }
    var name: String{
        get{ return userPreferences.string(forKey: UserPreference.name.rawValue) ?? ""}
        set{userPreferences.set(newValue, forKey: UserPreference.name.rawValue) }
    }
    
    
}

