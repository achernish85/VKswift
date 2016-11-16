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

class AZMainVC: CoreDataTableViewController {
    
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
    
    
    
    var managedContext: NSManagedObjectContext! { didSet { updateUI() } }
  //  let context = ad.persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func updateUI() {
        
        if let context = managedContext {
        let request: NSFetchRequest<VKPost> = VKPost.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let resultsController: NSFetchedResultsController<VKPost> = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
            fetchedResultsController =
                resultsController as? NSFetchedResultsController<NSFetchRequestResult>
            
        } else {
            fetchedResultsController = nil
        }
    }

    func updateDataBase(newPosts:[AZPost]) {
        managedContext.perform {
            for post in newPosts {
                _ = VKPost.postWithUserInfo(postInfo: post, inManagedObjectContext:self.managedContext)
            }
            self.managedContext.saveThrows()
        }
    }
    
    func printDataBase() {
        managedContext.perform {
            let reqest: NSFetchRequest<VKPost> = VKPost.fetchRequest()
            let result = try? self.managedContext.fetch(reqest)
            print("posts cound = \(result?.count)")
        }
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
                weakSelf?.printDataBase()
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
    
    //TODO: transition to fetchcontroller
    
    private struct Storyboard {
        static let cellIdentifierProfile = "profile"
        static let cellIdentifierPost = "posts"
        static let cellIdentifierNewPost = "newPost"
        static let cellDefault = "cell"
    }

    
        //MARK:CellForRow
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var text: String?
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellDefault, for: indexPath)
        if let post = fetchedResultsController?.object(at: indexPath) as? VKPost {
            post.managedObjectContext?.performAndWait {
                text = post.text
            }
            cell.textLabel?.text = text
        }
        
            return cell
        }
    
    //MARK TableViewDelegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if self.fetchedResultsController == nil {
            print("error when trying to delete object from managed object")
            
        } else if (editingStyle == .delete) {
            
            switch editingStyle {
                
            case .delete:
                managedContext?.delete(fetchedResultsController?.object(at: indexPath) as! VKPost)
                managedContext?.saveThrows()
                
            case .insert:
                break
            case .none:
                break
            }
    }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
}
