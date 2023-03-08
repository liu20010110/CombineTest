//
//  FriendsList.swift
//  CombineTest
//
//  Created by 劉陶恩 on 2023/2/14.
//

import UIKit
import RealmSwift
import MapKit

class FriendsList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var friendsLIst: UITableView!
    @IBOutlet weak var backMainVC: UIButton!
    let mainVC = MainVC()
    let realm = try! Realm()
    //可以用來取得在滑動哪行row
    var orderIndexpathrow :Int = 0
    //用來取的那一行的ID
    var orederPrimarykey : String? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsLIst.delegate = self
        friendsLIst.dataSource = self
        let nib = UINib(nibName: "FriendsListTableView", bundle: nil)
        friendsLIst.register(nib, forCellReuseIdentifier: "FriendsList")
        friendsLIst.reloadData()
    }
    
    @IBAction func pop(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let results = realm.objects(UserInfo.self)
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let results = realm.objects(UserInfo.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsList", for: indexPath) as! FriendsListTableView
        
        print(results)
        print("user: ",results[indexPath.row].localUserName)
        
        cell.friendImage.setImage(UIImage(systemName: "mappin.and.ellipse"), for: .normal)
        cell.friendName.text = results[indexPath.row].localUserName
        cell.type.text = CommandBase.FriendType.Friend.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除") { (action, sourceView, completeHandler) in
            self.orderIndexpathrow = indexPath.row
            self.getPrimaryKey()
            let realm = try! Realm()
            let delete = realm.objects(UserInfo.self).filter("id = '\(self.orederPrimarykey!)'").first
            try! realm.write {
                realm.delete(delete!)
                tableView.reloadData()
            }
            completeHandler(true)
        }
        let trailingSwipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])       
        return trailingSwipeConfiguration
        
    }
    func getPrimaryKey() {
        let realm = try! Realm()
        let id = realm.objects(UserInfo.self)
        if (id.count > 0) {
            self.orederPrimarykey = id[self.orderIndexpathrow].id
        }
    }  
}
