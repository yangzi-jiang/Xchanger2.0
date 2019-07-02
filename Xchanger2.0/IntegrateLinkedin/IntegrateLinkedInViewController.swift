//
//  IntegrateLinkedInViewController.swift
//  Xchanger2.0
//
//  Created by Altan Tutar on 6/6/19.
//  Copyright © 2019 Altan Tutar. All rights reserved.
//

import UIKit
import WebKit

class IntegrateLinkedInViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.navigationDelegate = self
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
        self.view = webView
        let linkedinURL = URL(string: authorizationURL)
        let request = URLRequest(url: linkedinURL!)
        //
        webView.load(request)
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url!
        
        if url.host == "com.appcoda.linkedin.oauth"{
            let urlParts = url.absoluteString.components(separatedBy: "?")
            let code = urlParts[1].components(separatedBy: "=")[1].replacingOccurrences(of: "&state" , with: "")
            print(code)
            
            getAccessToken(token: code)
        }
        
        decisionHandler(.allow)
    }
    
    func getAccessToken(token: String){
        
        let grantType = "authorization_code"
        
        let redirectURL = "https://com.appcoda.linkedin.oauth/oauth".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics)
        
        
        // Set the POST parameters.
        var postParams = "grant_type=\(grantType)&"
        postParams += "code=\(token)&"
        postParams += "redirect_uri=\(redirectURL!)&"
        postParams += "client_id=\(clientID)&"
        postParams += "client_secret=\(clientSecret)"
        
        let requestdata = postParams.data(using: .utf8)
        var request = URLRequest(url: URL(string: accessTokenEndPoint)!)
        
        request.httpMethod = "POST"
        request.httpBody = requestdata
        
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        
        let task: URLSessionDataTask = session.dataTask(with: request){ (data, response, error) -> Void in
            
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                if (String(httpResponse.statusCode) == "200"){
                    do {
                        
                        
                        
                        let dataDictionary  = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                        
                        
                        let accessToken = dataDictionary?["access_token"] as! String
                        
                        //Save the access token
                        
                        print(accessToken)
                        
                        UserDefaults.standard.set(accessToken, forKey: "LIAccessToken")
                        UserDefaults.standard.synchronize()
                        
                    
                        DispatchQueue.main.async {
                            
                    self.navigationController?.setNavigationBarHidden(true, animated: false)

                        self.navigationController?.popViewController(animated: true)
                        }
                        
                        
                    } catch {
                        print("Could not convert JSON data into a dictionary.")
                        
                    }
                }
            }
            
        }
        
        task.resume()
    }

}
