//
//  InstagramWebController.swift
//  Xchanger2.0
//
//  Created by Altan Tutar on 6/4/19.
//  Copyright © 2019 Altan Tutar. All rights reserved.
//

import UIKit
import WebKit

let accessTokenEndPointIG = "https://api.instagram.com/oauth/authorize/"

let accessToken = "https://api.instagram.com/oauth/access_token/"
let IGClientID = "e5b3b7ba36274b4f833aa17da7e4fefa"
let IGClientSecret = "f2c6dd1834d5457eb90a161f774b414b"

class InstagramWebController: UIViewController, WKNavigationDelegate {
    
    
    var webView: WKWebView!

    override func viewDidLoad() {

        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.navigationDelegate = self
        startAuthorization()
        
    }
    
    func startAuthorization(){
        let scope = "public_content"
        let directURI = "https://com.appcoda.instagram.oauth/oauth"
        let responseType = "code"
        
        var authorizationURL = "\(accessTokenEndPointIG)?"
        authorizationURL += "client_id=\(IGClientID)&"
        authorizationURL += "redirect_uri=\(directURI)&"
        authorizationURL += "response_type=\(responseType)&"
        authorizationURL += "scope=\(scope)&"
        authorizationURL += "DEBUG=True"
        
        // See what this URL is
        print(authorizationURL)
        self.view = webView
        let instagramURL = URL(string: authorizationURL)
        let request = URLRequest(url: instagramURL!)
        
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url!
        
        if url.host == "com.appcoda.instagram.oauth"{
            print(url.absoluteString)
            let urlParts = url.absoluteString.components(separatedBy: "?")
            let code = urlParts[1].components(separatedBy: "=")[1].replacingOccurrences(of: "&state" , with: "")
            
            getAccessToken(token: code)
        }
        
        decisionHandler(.allow)
    }
    
    func getAccessToken(token: String){
        
        let grantType = "authorization_code"
        
        let redirectURL = "https://com.appcoda.instagram.oauth/oauth".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics)
        
        
        // Set the POST parameters.
        var postParams = "grant_type=\(grantType)&"
        postParams += "code=\(token)&"
        postParams += "redirect_uri=\(redirectURL!)&"
        postParams += "client_id=\(IGClientID)&"
        postParams += "client_secret=\(IGClientSecret)"
        
        let requestdata = postParams.data(using: .utf8)
        var request = URLRequest(url: URL(string: accessToken)!)
        
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
                        
                        print(dataDictionary!)
                        
                        let dictionary = dataDictionary?["user"] as! NSDictionary
                        
                        
                        UserDefaults.standard.set(dictionary["username"], forKey: "IGUserProfile")
                    UserDefault.standard.set("https://www.instagram.com/\(dictionary["username"])/", forKey: "IGUserURL")
                        
                        UserDefaults.standard.synchronize()
//
//                        // Quit this view controller
//                        DispatchQueue.main.async {
////                            self.parent?.performSegue(withIdentifier: "success", sender: self.parent)
//                        }
//
                        
                    } catch {
                        print("Could not convert JSON data into a dictionary.")
                        
                    }
                }
            }
            
        }
        
        task.resume()
        
    }
}
