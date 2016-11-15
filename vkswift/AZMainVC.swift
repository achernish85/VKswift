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
import CoreData


class AZMainVC: UITableViewController {
    
    
    var user: AZUser? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var postsArray = [AZPost]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var managedContext: NSManagedObjectContext!
  //  let context = ad.persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func updateDataBase(newPosts:[AZPost]) {
        container?.performBackgroundTask({ (contex) in
            
            contex.saveThrows()
        })
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
    
   private func loadingInfo(withToken token: String) {
        AZServerClient.manager.getUser(userID: token) { (user) in
            print("autorized: \(user.firstName) \(user.lastName)")
            self.user = user
            
            
            AZServerClient.manager.getGroupWall(groupID: token, offset: 0, count: 10, onSuccess: {[weak weakSelf = self] (posts) in
                weakSelf?.postsArray = posts
                weakSelf?.updateDataBase(newPosts: self.postsArray)
            })
        }
    }
    
   private func authentication() {
        KeychainWrapper.standard.removeObject(forKey: KEY_TOKEN)
        KeychainWrapper.standard.removeObject(forKey: KEY_USERID)
        KeychainWrapper.standard.removeObject(forKey: KEY_EXPIRES)
        let loginVC = AZLoginVC()
        let navVC = UINavigationController(rootViewController: loginVC)
        let mainVC =  UIApplication.shared.windows.first?.rootViewController
        mainVC?.present(navVC, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else if section == 1{
            return 1
        } else {
            return  self.postsArray.count
        }
    }
    
    private struct Storyboard {
        static let cellIdentifierProfile = "profile"
        static let cellIdentifierPost = "posts"
        static let cellIdentifierNewPost = "newPost"
        static let cellDefault = "cell"
    }
    //MARK:CellForRow
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellDefault, for: indexPath)
            cell.textLabel?.text = user?.firstName
            
            return cell
            
        } else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellDefault, for: indexPath)
            let post = self.postsArray[indexPath.row]
            cell.textLabel?.text = post.text
            
            return cell
        } else {
            
            //TODO: add post wall
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellDefault, for: indexPath) as UITableViewCell
            return cell
        }
    }
    
    //MARK TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
}














