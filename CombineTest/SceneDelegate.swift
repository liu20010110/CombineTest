//
//  SceneDelegate.swift
//  CombineTest
//
//  Created by 劉陶恩 on 2022/12/7.
//

import UIKit
import CoreLocation
import Firebase
import Amplify
import AWSCognitoAuthPlugin

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var locationManager = CLLocationManager()
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let rootVC = UINavigationController(rootViewController: LogInViewController())
        
        
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.allowsBackgroundLocationUpdates = true
       
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = rootVC //navController
        window?.makeKeyAndVisible()
        
        FirebaseApp.configure()
        
//        if locationManager.authorizationStatus == .denied{
//            DispatchQueue.main.async {
//                TAlertView.showAlertWith(title: "使用者拒絕存取定位", message: "在設置>隱私中打開定位服務，來允許地圖確定您當前的位置", delegate: rootVC) {
//                    guard let url = URL(string: UIApplication.openSettingsURLString)
//                    else{
//                        return
//                    }
//                    if UIApplication.shared.canOpenURL(url){
//                        UIApplication.shared.open(url) { (success) in
//                            print("Success")
//                        }
//                    }
//                }
//            }
//        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

