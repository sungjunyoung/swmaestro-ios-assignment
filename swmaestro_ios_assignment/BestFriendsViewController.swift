//
//  FriendsViewController.swift
//  swmaestro_ios_assignment
//
//  Created by 성준영 on 2017. 10. 31..
//  Copyright © 2017년 성준영. All rights reserved.
//

import UIKit

class BestFriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {
    
    @IBOutlet weak var friendsTableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private var friendsArray: [Friend] = []
    private let localData = UserDefaults.standard
    @IBOutlet weak var tabBar: UITabBar!
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == (self.tabBar.items)![0]{
            dismiss(animated: false, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // Action to delete data
            friendsArray.remove(at: indexPath.row)
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: friendsArray)
            localData.set(encodedData, forKey: "bestFriends")
            self.friendsTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = friendsArray[indexPath.row]
        let friendImage = friend.imageData
        let friendName = friend.name
        let friendEmail = friend.email
        let friendCellphone = friend.cellphone
        let friendNation = friend.nation
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.friendImageData = friendImage
        detailVC.friendNameText = friendName
        detailVC.friendEmailText = friendEmail
        detailVC.friendCellphoneText = friendCellphone
        detailVC.friendNationText = friendNation
        
        present(detailVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell") as! FriendsTableViewCell
        let email = friendsArray[indexPath.row].email
        cell.friendName.text = friendsArray[indexPath.row].name
        cell.friendEmail.text = email
        cell.friendImage.image = UIImage(data: friendsArray[indexPath.row].imageData as Data)
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let data = localData.data(forKey: "bestFriends")
        var bestFriends: [Friend] = []
        if data != nil {
            bestFriends = (NSKeyedUnarchiver.unarchiveObject(with: data!) as? [Friend])!
        }
        
        friendsArray = bestFriends
        friendsTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = localData.data(forKey: "bestFriends")
        var bestFriends: [Friend] = []
        if data != nil {
            bestFriends = (NSKeyedUnarchiver.unarchiveObject(with: data!) as? [Friend])!
        }
        
        friendsArray = bestFriends
        
        tabBar.delegate = self
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
    }
    
    
}

