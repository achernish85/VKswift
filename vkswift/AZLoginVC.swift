//
//  AZLoginVC.swift
//  vkswift
//
//  Created by Admin on 11.11.16.
//  Copyright © 2016 mcat345. All rights reserved.
//

import UIKit

class AZLoginVC: UIViewController {
   
        var webView : UIWebView = UIWebView()
        var token = ""
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
        }
    
        
        override func viewWillLayoutSubviews() {
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            webView.frame = view.bounds
            
            webView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            webView.scalesPageToFit = true
            view.addSubview(webView)
            
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(sender:)))
            
            self.navigationItem.rightBarButtonItem = cancelButton
            
            let urlString = "https://oauth.vk.com/authorize?"
                + "client_id=5634472&"
                + "display=mobile&"
                + "redirect_uri=https://oauth.vk.com/blank.html&"
                + "scope=139286&"
                + "response_type=token&"
                + "v=5.53"
            
            
            webView.delegate = self
            let url = NSURL(string: urlString)
            let request = NSURLRequest(url: url as! URL)
            webView.loadRequest(request as URLRequest)
            
        }
    
        func cancel(sender: AnyObject?) {
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    extension AZLoginVC: UIWebViewDelegate {
        
        //MARK: UIWebViewDelegate
        func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
            
            if let currentURL = request.url?.description {
            
            if (currentURL.hasPrefix("https://oauth.vk.com")) {
                if currentURL.contains("access_token=") && currentURL.contains("expires_in=") {
                let strings1 = request.url?.description.components(separatedBy: "&expires_in")
                let strings2 = strings1?.first?.components(separatedBy: "access_token=")
                token = (strings2?.last)!
                print("token: ",token)
                
                
                dismiss(animated: true, completion: nil)
                
                
                return false
            }
            }
            }
            print("aaa \(request.url)")
            
            return true
        }
        
    }

