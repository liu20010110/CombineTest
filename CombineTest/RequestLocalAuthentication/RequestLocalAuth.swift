//
//  RequestLocalAuth.swift
//  CombineTest
//
//  Created by 劉陶恩 on 2023/1/26.
//

import UIKit
import LocalAuthentication

class RequestLocalAuth: UIViewController {

    @IBOutlet weak var requestAuth: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        requestAuth.layer.cornerRadius = requestAuth.frame.height/2
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    @IBAction func authID(_ sender: Any) {
        useFaceIDandTouchID()
    }
    
    
    
    func useFaceIDandTouchID(){
        // 創建 LAContext 實例
        let userFaceID = LAContext()
        // 設置取消按鈕標題
        userFaceID.localizedCancelTitle = "Enter Password"
        // 宣告一個變數接收 canEvaluatePolicy 返回的錯誤
        var error:NSError?
        // 評估是否可以針對給定方案進行身份驗證
        if userFaceID.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error){
            // 描述使用身份辨識的原因
            let reason = "Log in to this app"
            // 評估指定方案
            userFaceID.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (success, error ) in
                if success {
                    DispatchQueue.main.async { [unowned self] in
                        TAlertView.showAlertWith(title: "Success Log in", message: "Log in", delegate: self) {
                            self.toNextPage()
                        }
                       
                        
                    }
                }else  {
                    DispatchQueue.main.async { [unowned self] in
                        TAlertView.showAlertWith(title: "Failed Log in", message: "Failed", delegate: self, confirm: nil)
                    }
                }
            }
            
        } else {
            return
        }
    }
    
    func toNextPage(){
        if GlobalAppSetting.shared.isSignIn == true && GlobalAppSetting.shared.isFirstSignIn == false {
            let toMainVC = MainVC()
            self.navigationController?.pushViewController(toMainVC, animated: true)
        }else {
            let toUserName = UserName()
            self.navigationController?.pushViewController(toUserName, animated: true)
        }
    }

}
