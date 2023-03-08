//
//  CommandBase.swift
//  CombineTest
//
//  Created by 劉陶恩 on 2023/2/2.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class CommandBase: NSObject, Identifiable, Codable{
    
    
    
    static let shareInstance = CommandBase()
    
    enum PersonalInfo: Int, CaseIterable {
        case userName = 0, id, birthDay, Friends, blockAde, selfWorld, preferSet, notiFication
        var title: String {
            switch self {
            case .userName:
                return "暱稱"
            case .id:
                return "LTN id"
            case .birthDay:
                return "生日"
            case .Friends:
                return "朋友"
            case .blockAde:
                return "封鎖的使用者"
            case .selfWorld:
                return "你的世界"
            case .preferSet:
                return "偏好設定"
            case .notiFication:
                return "通知"
                
            }
        }
    }
    
    enum FriendType: Int, CaseIterable {
        case Friend = 0, Companion, FoodStore, Home, School, Company
        var title: String {
            switch self {
            case .Friend:
                return "朋友"
            case .Companion:
                return "伴侶"
            case .FoodStore:
                return "餐廳"
            case .Home:
                return "佳"
            case .School:
                return "學校"
            case .Company:
                return "公司"
            }
        }
    }
    
    struct SpotifyTrack: Identifiable, Codable {
        
        @DocumentID var id : String? //官方寫法var id: String = UUID().uuidString
    }
    
    func showActivityIndicatory(uiView: UIView) {
        // 背景
        var container: UIView = UIView()
        container.tag = 100
        container.frame = UIScreen.main.bounds
        container.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        // loading 的背景
        var loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        // loading 圖案
        var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.style = UIActivityIndicatorView.Style.large
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        actInd.startAnimating()
    }
    
    func removeActivityIndicatory(uiView: UIView) {
        if let viewWithTag = uiView.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    func UIColorFromHex(rgbValue: UInt32, alpha: Double = 1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
}
