//
//  LocalDatabase.swift
//  CombineTest
//
//  Created by 劉陶恩 on 2023/2/9.
//

import Foundation
import RealmSwift

public class UserInfo: Object{
   
    @objc public dynamic var id = UUID().uuidString
    @objc public dynamic var localCollection = ""
    @objc public dynamic var localUserName = ""
    @objc public dynamic var localField = ""
    @objc public dynamic var localLatitude: Double = 0
    @objc public dynamic var localLongitude: Double = 0
    
    public override static func primaryKey() -> String? {
        return "id"
    }
    
}
