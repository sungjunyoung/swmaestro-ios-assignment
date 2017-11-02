//
//  FriendsViewController.swift
//  swmaestro_ios_assignment
//
//  Created by 성준영 on 2017. 10. 31..
//  Copyright © 2017년 성준영. All rights reserved.
//

import UIKit
import JGProgressHUD

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {

    @IBOutlet weak var friendsTableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private var data: [String] = []
    private var friendsArray: [[String:AnyObject]] = []
    private var friendsImageDataArray: [NSData] = []
    private let defaults = UserDefaults.standard
    @IBOutlet weak var tabBar: UITabBar!
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == (self.tabBar.items)![1]{
            let bestFriendsVC = storyboard?.instantiateViewController(withIdentifier: "BestFriendsViewController") as! BestFriendsViewController
            present(bestFriendsVC, animated: false, completion: nil)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = friendsArray[indexPath.row]
        let friendImage = friendsImageDataArray[indexPath.row]
        print(friendImage)
        let firstName = friend["name"]!["first"] as! String
        let lastName = friend["name"]!["last"] as! String
        let friendName = "\(firstName) \(lastName)"
        let friendEmail = friend["email"]
        let friendCellphone = friend["cell"]
        let friendNation = friend["nat"]
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.friendImageData = friendImage
        detailVC.friendNameText = friendName
        detailVC.friendEmailText = friendEmail as! String
        detailVC.friendCellphoneText = friendCellphone as! String
        detailVC.friendNationText = friendNation as! String
        
        present(detailVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell") as! FriendsTableViewCell
        let firstName = friendsArray[indexPath.row]["name"]!["first"] as! String
        let lastName = friendsArray[indexPath.row]["name"]!["last"] as! String
        let email = friendsArray[indexPath.row]["email"] as! String
        
        cell.friendName.text = "\(firstName) \(lastName)"
        cell.friendEmail.text = email
        cell.friendImage.image = UIImage(data: friendsImageDataArray[indexPath.row] as Data)
    
        return cell
    }
    
    
    func getJSON(callback: @escaping ([String : AnyObject]) -> Void){
        DispatchQueue.main.async {
            let url = URL(string: "https://randomuser.me/api/?results=20&inc=name,picture,nat,cell,email,id")
            let request = URLRequest(url: url!)
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                
                guard let data = data else {
                    print("request failed \(String(describing: error))")
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with:data) as? [String : AnyObject] {
                        callback(json)
                    }
                } catch let parseError{
                    print("parsing error: \(parseError)")
                    let responseString = String(data: data, encoding: .utf8)
                    print("raw response: \(String(describing: responseString))")
                }
            }
            task.resume()
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        refresh()
    }
    
    private func refresh() {
        getJSON() { response in
            DispatchQueue.main.async {
                self.friendsArray = response["results"] as! [[String : AnyObject]]
                self.friendsImageDataArray = []
                for friend in self.friendsArray{
                    let urlString = friend["picture"]!["medium"]
                    let url = NSURL(string: urlString as! String)
                    let data = NSData(contentsOf: url! as URL)
                    self.friendsImageDataArray.append(data!)
                }
                
                self.friendsTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            friendsTableView.refreshControl = refreshControl
        } else {
            friendsTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        getJSON() { response in
            DispatchQueue.main.async {
                self.friendsArray = response["results"] as! [[String : AnyObject]]
                for friend in self.friendsArray{
                    let urlString = friend["picture"]!["medium"]
                    let url = NSURL(string: urlString as! String)
                    let data = NSData(contentsOf: url! as URL)
                    
                    self.friendsImageDataArray.append(data!)
                }
                self.friendsTableView.reloadData()
                hud.dismiss()
            }
        }
        
        tabBar.delegate = self
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
    }
    

}
