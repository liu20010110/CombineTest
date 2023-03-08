//
//  PersonalInformation.swift
//  CombineTest
//
//  Created by 劉陶恩 on 2023/2/1.
//

import UIKit
import Amplify
import AWSCognitoAuthPlugin
import CoreLocation
import RealmSwift

class PersonalInformation: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {
    
   
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var personalTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        personalTableView.delegate = self
        personalTableView.dataSource = self
        let nib = UINib(nibName: "PersonalTableViewCell", bundle: nil)
        personalTableView.register(nib, forCellReuseIdentifier: "PersonalCell")
        personalTableView.reloadData()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func toMainVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signOut(_ sender: Any) {
        Task{ 
            await self.signOutLocally()
        }
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return CommandBase.PersonalInfo.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let realm = try! Realm()
        let results = realm.objects(UserInfo.self)
 
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalCell", for: indexPath) as! PersonalTableViewCell
            cell.personalTitle.text = CommandBase.PersonalInfo.userName.title
            cell.personalTF.text = GlobalAppSetting.shared.userName
            cell.personalTF.isEnabled = false
            cell.personalTF.delegate = self
            return cell
        } else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalCell", for: indexPath) as! PersonalTableViewCell
            cell.personalTitle.text = CommandBase.PersonalInfo.id.title
            cell.personalTF.text = GlobalAppSetting.shared.userName
            cell.personalTF.isEnabled = false
            cell.personalTF.delegate = self
            return cell
        } else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalCell", for: indexPath) as! PersonalTableViewCell
            cell.personalTitle.text = CommandBase.PersonalInfo.birthDay.title
            cell.personalTF.text = GlobalAppSetting.shared.birthDay
            cell.personalTF.delegate = self
            return cell
        } else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalCell", for: indexPath) as! PersonalTableViewCell
            cell.personalTitle.text = CommandBase.PersonalInfo.Friends.title
            cell.personalTF.text = "\(results.count)"
            cell.personalTF.isEnabled = false
            cell.personalTF.delegate = self
            return cell
        } else if indexPath.section == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalCell", for: indexPath) as! PersonalTableViewCell
            cell.personalTitle.text = CommandBase.PersonalInfo.blockAde.title
            cell.personalTF.text = ""
            cell.personalTF.isEnabled = false
            cell.personalTF.delegate = self
            return cell
        } else if indexPath.section == 5{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalCell", for: indexPath) as! PersonalTableViewCell
            cell.personalTitle.text = CommandBase.PersonalInfo.selfWorld.title
            cell.personalTF.text = ""
            cell.personalTF.isEnabled = false
            cell.personalTF.delegate = self
            return cell
        } else if indexPath.section == 6{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalCell", for: indexPath) as! PersonalTableViewCell
            cell.personalTitle.text = CommandBase.PersonalInfo.preferSet.title
            cell.personalTF.text = ""
            cell.personalTF.isEnabled = false
            cell.personalTF.delegate = self
            return cell
        } else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalCell", for: indexPath) as! PersonalTableViewCell
            cell.personalTitle.text = CommandBase.PersonalInfo.notiFication.title
            cell.personalTF.text = ""
            cell.personalTF.isEnabled = false
            cell.personalTF.delegate = self
            return cell
        }
    }
    
    func signOutLocally() async  {
        let result =  await Amplify.Auth.signOut()
        guard let signOutResult = result as? AWSCognitoSignOutResult
        else {
            print("Signout failed")
            return
        }

        print("Local signout successful: \(signOutResult.signedOutLocally)")
       
        switch signOutResult {
        case .complete:
            // Sign Out completed fully and without errors.
            print("Signed out successfully")
            GlobalAppSetting.shared.isSignOut = true
            Task{ @MainActor in
                let toLogVC = LogInViewController()
                self.navigationController?.pushViewController(toLogVC, animated: true)
            }
           

        case let .partial(revokeTokenError, globalSignOutError, hostedUIError):
            // Sign Out completed with some errors. User is signed out of the device.
            
            if let hostedUIError = hostedUIError {
                print("HostedUI erroe \(String(describing: hostedUIError))")
            }

            if let globalSignOutError = globalSignOutError {
                // Optional: Use escape hatch to retry revocation of globalSignOutError.accessToken.
                print("GlobalSignOut error  \(String(describing: globalSignOutError))")
            }

            if let revokeTokenError = revokeTokenError {
                // Optional: Use escape hatch to retry revocation of revokeTokenError.accessToken.
                print("Revoke token error  \(String(describing: revokeTokenError))")
            }

        case .failed(let error):
            // Sign Out failed with an exception, leaving the user signed in.
            print("SignOut failed with \(error)")
        }
    }
}
