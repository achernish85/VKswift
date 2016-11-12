//
//  AZMainVC.swift
//  vkswift
//
//  Created by Admin on 11.11.16.
//  Copyright © 2016 mcat345. All rights reserved.
//

import UIKit

class AZMainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let loginVC = AZLoginVC()
        
        let navVC = UINavigationController(rootViewController: loginVC)
        let mainVC =  UIApplication.shared.windows.first?.rootViewController
        mainVC?.present(navVC, animated: true, completion: nil)
    }
    


}

