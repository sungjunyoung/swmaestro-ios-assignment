//
//  DetailViewController.swift
//  swmaestro_ios_assignment
//
//  Created by 성준영 on 2017. 11. 1..
//  Copyright © 2017년 성준영. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendEmail: UILabel!
    @IBOutlet weak var friendCellphone: UILabel!
    @IBOutlet weak var friendNation: UILabel!
    @IBOutlet weak var addBestFriendButton: UIBarButtonItem!
    private var localData = UserDefaults.standard
    
    var friend: Friend = Friend()
    var bestFriends: [Friend] = []
    var isBestFriend = false
    var bestFriendIndex = -1
    
    @IBAction func onSearchWeb(_ sender: Any) {
        let webVC = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        let searchName = friend.name.replacingOccurrences(of: " ", with: "%20")
        webVC.startUrl = "https://www.google.com/search?q=\(searchName)"

        present(webVC, animated: true, completion: nil)
    }
    
    @IBAction func onBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickBestFriendButton(_ sender: Any) {
        if !isBestFriend {
            bestFriends.append(friend)
            addBestFriendButton.title = "Remove"
            isBestFriend = true
            bestFriendIndex = bestFriends.count - 1
        } else {
            bestFriends.remove(at: bestFriendIndex)
            addBestFriendButton.title = "Add"
            isBestFriend = false
            bestFriendIndex = -1
        }
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: bestFriends)
        localData.set(encodedData, forKey: "bestFriends")
    }
    
    var friendImageData:NSData = NSData()
    var friendNameText = ""
    var friendEmailText = ""
    var friendCellphoneText = ""
    var friendNationText = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendImage.image = UIImage(data: friendImageData as Data)
        friendName.text = friendNameText
        friendEmail.text = friendEmailText
        friendCellphone.text = friendCellphoneText
        friendNation.text = friendNationText
        
        friend.setData(imageData: friendImageData, name: friendNameText, email: friendEmailText, cellphone: friendCellphoneText, nation: friendNationText)
        if localData.data(forKey: "bestFriends") != nil {
            let data = localData.data(forKey: "bestFriends")
            bestFriends = (NSKeyedUnarchiver.unarchiveObject(with: data!) as? [Friend])!
        }
        
        let i = bestFriends.index(where: { $0.email == friendEmailText })
        
        if i == nil {
            addBestFriendButton.title = "Add"
        } else {
            addBestFriendButton.title = "Remove"
            isBestFriend = true
            bestFriendIndex = i!
        }
        

            
    }


}
