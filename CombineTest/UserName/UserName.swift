//
//  UserName.swift
//  CombineTest
//
//  Created by 劉陶恩 on 2023/2/3.
//

import UIKit

class UserName: UIViewController {
    
    
    @IBOutlet weak var userName: CustomTextField!
    @IBOutlet weak var nextStep: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initBtnUI()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func initBtnUI(){
        userName.layer.cornerRadius = userName.frame.height/2
        nextStep.layer.cornerRadius = nextStep.frame.height/2
        
    }
    
    
    @IBAction func nextPage(_ sender: Any) {
        if userName.text == "" {
            return
        } else {
            GlobalAppSetting.shared.userName = userName.text!
            userName.text = ""
            let toBirVC = Birthday()
            self.navigationController?.pushViewController(toBirVC, animated: true)
        }
    }
    
}
