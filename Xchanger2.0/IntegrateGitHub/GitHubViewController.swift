//
//  GitHubViewController.swift
//  Xchanger2.0
//
//  Created by Altan Tutar on 6/5/19.
//  Copyright © 2019 Altan Tutar. All rights reserved.
//

import UIKit
import WebKit

let authorizeEndPoint = "https://github.com/login/oauth/authorize/"
let GHaccessTokenEndPoint = "https://github.com/login/oauth/access_token"

let GHClientID = "0ef3f2dbe71a0324e7fd"
let GHClientSecret = "82d43091b9c89f36738a7606d17904b4abbc92cc"


class GitHubViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.navigationDelegate = self
        startAuthorization()
    }
    
    func startAuthorization(){
        let scope = "user"
        let redirectURI = "https://com.appcoda.github.oauth/oauth"
        let allowSignUp = "true"
        
        var authorizationURL = "\(authorizeEndPoint)?"
        authorizationURL += "client_id=\(GHClientID)&"
        authorizationURL += "redirect_uri=\(redirectURI)&"
        authorizationURL += "scope=\(scope)&"
        authorizationURL += "allow_signup=\(allowSignUp)"
        
        print(authorizationURL)
        self.view = webView
        let instagramURL = URL(string: authorizationURL)
        let request = URLRequest(url: instagramURL!)
        
        webView.load(request)
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url!
        
        if url.host == "com.appcoda.github.oauth"{
            print(url.absoluteString)
            let urlParts = url.absoluteString.components(separatedBy: "?")
            let code = urlParts[1].components(separatedBy: "=")[1].replacingOccurrences(of: "&state" , with: "")
            getAccessToken(token: code)
        }
        
        decisionHandler(.allow)
    }
    
    func getAccessToken(token: String){
        let redirectURL = "https://com.appcoda.github.oauth/oauth".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics)
        
        var postParam = "client_id=\(GHClientID)&"
        postParam += "client_secret=\(GHClientSecret)&"
        postParam += "code=\(token)&"
        postParam += "redirect_uri=\(redirectURL!)&"
        
        let requestdata = postParam.data(using: .utf8)
        var request = URLRequest(url: URL(string: GHaccessTokenEndPoint)!)
        
        request.httpMethod = "POST"
        request.httpBody = requestdata
        
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        
        let task: URLSessionDataTask = session.dataTask(with: request){ (data, response, error) -> Void in
            
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                if (String(httpResponse.statusCode) == "200"){
                    do {
                        
                        let jsonText = String(data: data!,
                                              encoding: .ascii)
                        
                        let dataArray = jsonText!.components(separatedBy: "&")
                        
                        let accessToken = dataArray[0].components(separatedBy: "=")[1]
                        
                        
                        
                        UserDefaults.standard.set(accessToken, forKey: "GHAccessToken")
                        UserDefaults.standard.synchronize()
                        
                        DispatchQueue.main.async {
                            self.navigationController?.setNavigationBarHidden(true, animated: false)
                            self.navigationController?.popViewController(animated: true)
                            
                            githubConnected = true
                        }
                        
                        
                    } catch {
                        print("Could not convert JSON data into a dictionary.")
                        
                    }
                }
            }
            
        }
        
        task.resume()
        
    }
    
    // Lock Portrait Orientation
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
        
    }
}
