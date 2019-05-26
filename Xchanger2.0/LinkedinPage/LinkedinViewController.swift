//
//  LinkedinViewController.swift
//  Xchanger2.0
//
//  Created by Altan Tutar on 5/26/19.
//  Copyright © 2019 Altan Tutar. All rights reserved.
//

import UIKit
import WebKit

// Constant for Linkedin API

let clientID = "78xbpu2g4mnja9"
let clientSecret = "aZzWyS3XEOppi7ye"
let accessTokenEndPoint = "https://www.linkedin.com/oauth/v2/accessToken"
let authorizationTokenEndPoint = "https://www.linkedin.com/uas/oauth2/authorization"

// Set the web view


class LinkedinViewController: UIViewController {
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
   
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startAuthorization()
    }
    
    func startAuthorization(){
        
        // More constants to make an API call to LinkedIn
        let responseType = "code"
        
        // Set the redirect URL
        let redirectURL = "https://com.appcoda.linkedin.oauth/oauth".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics)
        
        // Set state for security
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        
        // Set preferred scope
        let scope = "r_basicprofile"
        
        // Create the authorization URL string for LinkedIn
        
        var authorizationURL = "\(authorizationTokenEndPoint)?"
        authorizationURL += "response_type=\(responseType)&"
        authorizationURL += "client_id=\(clientID)&"
        authorizationURL += "redirect_uri=\(redirectURL!)&"
        authorizationURL += "state=\(state)&"
        authorizationURL += "scope=\(scope)"
        
        print(authorizationURL)
        // Create a URL request and load it in the web view
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        self.view = webView
        let linkedinURL = URL(string: authorizationURL)
        let request = URLRequest(url: linkedinURL!)
        webView.load(request)

    }
    
   
}
