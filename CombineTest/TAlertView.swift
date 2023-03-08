//
//  TAlertView.swift
//  CombineTest
//
//  Created by 劉陶恩 on 2022/12/23.
//

import UIKit

class TAlertView: NSObject{
    class func showAlertWith(title: String?, message: String?, delegate: UIViewController, confirm: (() -> Void)?) {
        DispatchQueue.main.async {
            let message = message ?? ""
            let title = title ?? ""
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let confirmAction = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default) { (UIAlertAction) -> Void in
                confirm?()
            }
            alertController.addAction(confirmAction)
            delegate.present(alertController, animated: true, completion: nil)
            if title == NSLocalizedString("Notification", comment: "") && message == NSLocalizedString("Data upload failed", comment: "") {
                let when = DispatchTime.now() + 10
                DispatchQueue.main.asyncAfter(deadline: when){
                    alertController.dismiss(animated: true, completion: nil)
                }
            }
            
            
        }
    }
}
