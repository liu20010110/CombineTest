//
//  PersonalTableViewCell.swift
//  CombineTest
//
//  Created by 劉陶恩 on 2023/2/1.
//

import UIKit

class PersonalTableViewCell: UITableViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var personalTitle: UILabel!
    @IBOutlet weak var personalTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        personalTF.delegate = self
        personalTF.text = personalTF.text
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
