//
//  AZMainVC.swift
//  vkswift
//
//  Created by Admin on 11.11.16.
//  Copyright © 2016 mcat345. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON


class AZMainVC: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var user: AZUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let date = Date()
    //checking if token expires date is valid
        if (KeychainWrapper.standard.object(forKey: KEY_EXPIRES) as! NSDate).compare(date) == .orderedDescending {
         let token = KeychainWrapper.standard.string(forKey: "token")
         let userID = KeychainWrapper.standard.string(forKey: "userID")
         loadingInfo(withToken:userID!)
        } else {
            authentication()
        }
    }
    
    func loadingInfo(withToken token: String) {
        AZServerClient.manager.getUser(userID: token) { (user) in
            print("autorized: \(user.firstName) \(user.lastName)")
            self.user = user
            self.label.text = user.firstName
            
//            AZServerClient.manager.getGroupWall(string!, offset: 0, count: 10, onSuccess: { (posts) in
//                self.postsArray = posts
//            })
        }
    }
    
    func authentication() {
        KeychainWrapper.standard.removeObject(forKey: KEY_TOKEN)
        KeychainWrapper.standard.removeObject(forKey: KEY_USERID)
        KeychainWrapper.standard.removeObject(forKey: KEY_EXPIRES)
        let loginVC = AZLoginVC()
        let navVC = UINavigationController(rootViewController: loginVC)
        let mainVC =  UIApplication.shared.windows.first?.rootViewController
        mainVC?.present(navVC, animated: true, completion: nil)
    }
}

