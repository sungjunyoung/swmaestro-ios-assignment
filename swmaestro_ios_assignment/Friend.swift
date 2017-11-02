//
//  Friend.swift
//  swmaestro_ios_assignment
//
//  Created by 성준영 on 2017. 11. 1..
//  Copyright © 2017년 성준영. All rights reserved.
//

import Foundation

class Friend :NSObject, NSCoding {
    override init(){
        self.imageData = NSData()
        self.name = ""
        self.email = ""
        self.cellphone = ""
        self.nation = ""
    }
    
    func setData(imageData: NSData, name: String, email: String, cellphone: String, nation: String){
        self.imageData = imageData
        self.name = name
        self.email = email
        self.cellphone = cellphone
        self.nation = nation
    }
    
    required init?(coder aDecoder: NSCoder) {
        imageData = aDecoder.decodeObject(forKey: "imageData") as! NSData
        name = aDecoder.decodeObject(forKey: "name") as! String
        email = aDecoder.decodeObject(forKey: "email") as! String
        cellphone = aDecoder.decodeObject(forKey: "cellphone") as! String
        nation = aDecoder.decodeObject(forKey: "nation") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(imageData, forKey: "imageData")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(cellphone, forKey: "cellphone")
        aCoder.encode(nation, forKey: "nation")
    }
    
    var imageData:NSData = NSData()
    var name = ""
    var email = ""
    var cellphone = ""
    var nation = ""
}
