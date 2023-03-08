//
//  LogInViewController.swift
//  CombineTest
//
//  Created by 劉陶恩 on 2023/1/5.
//

import UIKit
import Amplify
import AWSCognitoAuthPlugin
import Combine
import LocalAuthentication
import RealmSwift

class LogInViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var signBtn: UIButton!
    @IBOutlet weak var signWithApple: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBtnUI()
        userName.textFieldSet()
        
        self.userName.isHidden = true
        self.signBtn.isHidden = true
        self.signWithApple.isHidden = true
        
        useFaceIDandTouchID()
        navigationController?.navigationBar.isHidden = true
        
   
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func initBtnUI(){
        userName.placeholder = "UserName"
        signBtn.layer.cornerRadius = signBtn.frame.height/2
        signWithApple.layer.cornerRadius = signWithApple.frame.height/2
        
    }
    
    
    @IBAction func signIn(_ sender: Any) {
        Task { @MainActor in
            try! await self.fetchCurrentAuthSession()
            //            await self.signInWithWebUI()
        }
    }
    
    @IBAction func signInWithApple(_ sender: Any) {
        Task { @MainActor in
            try! await self.socialSignInWithWebUI()
            //            await self.signInWithWebUI()
        }
    }
    
    
    //    func signInWithWebUI()  {
    //        _ = Amplify.Publisher.create {
    //            try await Amplify.Auth.signInWithWebUI(presentationAnchor: self.view.window!)
    //        }.sink {
    //            if case let .failure(authError) = $0 {
    //                print("Sign in failed \(authError)")
    //            }
    //        }
    //    receiveValue: { signInResult in
    //        if signInResult.isSignedIn {
    //            print("Sign in succeeded")
    //            self.toMainVC()
    //        }
    //    }
    //
    //    }
    
    //登入
    func signInWithWebUI() async throws {
        do {
            let signInResult = try await Amplify.Auth.signInWithWebUI(presentationAnchor: self.view.window!)
//            DispatchQueue.main.async {
//                if signInResult.isSignedIn {
//                    print("Sign in succeeded")
//                    self.toAuthVC()
//                }
//            }
            Task { @MainActor in
                if signInResult.isSignedIn{
                    GlobalAppSetting.shared.isSignOut = false
                    print("Sign in Succeeded")
                    self.toUserName()
                }
            }
        }
        
        catch let error as AuthError {
                print("Sign in failed \(error)")
        } catch {
                print("Unexpected error: \(error)")
        }
    }
    
    //Sign In With Apple
    func socialSignInWithWebUI() async throws {
        do {
            let signInResult = try await Amplify.Auth.signInWithWebUI(for: .apple, presentationAnchor: self.view.window!)
            Task { @MainActor in
                if signInResult.isSignedIn{
                    GlobalAppSetting.shared.isSignOut = false
                    print("Sign in Succeeded")
                    self.toUserName()
                }
            }
        } catch let error as AuthError {
            print("Sign in failed \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    //抓取是否已經登入
    func fetchCurrentAuthSession() async  throws {
        
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            Task { @MainActor in
                if session.isSignedIn == true{
                    self.toMainVC()
                    GlobalAppSetting.shared.isSignOut = false
                    print("Is user signed in - \(session.isSignedIn)")
                    
                } else{
                    print("Is user signed in - \(session.isSignedIn)")
                    try! await self.signInWithWebUI()
                }
            }
            
        } catch let error as AuthError {
                print("Fetch session failed with error \(error)")
        } catch {
                print("Unexpected error: \(error)")
        }
    }
    
    
    
    //登入監聽
    func observeAuthEvent(){
        _ = Amplify.Hub.listen(to: .auth) { [weak self] result in
            switch result.eventName{
            case HubPayload.EventName.Auth.signedIn:
                Task{ @MainActor in
                    self!.toUserName()
                }
              
            case HubPayload.EventName.Auth.signedOut,
                HubPayload.EventName.Auth.sessionExpired:
                
                return
                
            default:
                break
            }
        }
    }
    
    
    func useFaceIDandTouchID(){
        // 創建 LAContext 實例
        let userFaceID = LAContext()
        // 設置取消按鈕標題
        userFaceID.localizedCancelTitle = "Cencel"
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
                            self.userName.isHidden = false
                            self.signBtn.isHidden = false
                            self.signWithApple.isHidden = false
                            if GlobalAppSetting.shared.isSignOut == false {
                                self.toMainVC()
                            }
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
    
    func toUserName(){
        let toUserNameVC = UserName()
        self.navigationController?.pushViewController(toUserNameVC, animated: true)
    }
    
    func toMainVC(){
        let toMainVC = MainVC()
        self.navigationController?.pushViewController(toMainVC, animated: true)
    }
    
}

extension UITextField{
    func textFieldSet(){
        self.borderStyle = .none
        self.layer.cornerRadius = self.bounds.height/2
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
    }
}
