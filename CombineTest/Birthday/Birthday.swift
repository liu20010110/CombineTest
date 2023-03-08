//
//  Birthday.swift
//  CombineTest
//
//  Created by 劉陶恩 on 2023/2/3.
//

import UIKit

class Birthday: UIViewController {
    
    @IBOutlet weak var btithDay: CustomTextField!
    @IBOutlet weak var nextStep: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBtnUI()
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func initBtnUI(){
        btithDay.layer.cornerRadius = btithDay.frame.height/2
        nextStep.layer.cornerRadius = nextStep.frame.height/2
        
    }


    @IBAction func nextPage(_ sender: Any) {
        if btithDay.text == "" {
            return
        } else {
            GlobalAppSetting.shared.birthDay = btithDay.text!
            btithDay.text = ""
            let toWhenInUse = RequestWhenInUse()
            self.navigationController?.pushViewController(toWhenInUse, animated: true)
        }
    }
    

}
