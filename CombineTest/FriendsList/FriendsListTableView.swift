//
//  FriendsListTableView.swift
//  CombineTest
//
//  Created by 劉陶恩 on 2023/2/14.
//

import UIKit

class FriendsListTableView: UITableViewCell {
    
    @IBOutlet weak var friendImage: UIButton!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var type: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
