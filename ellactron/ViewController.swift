//
//  ViewController.swift
//  ellactron
//
//  Created by admin on 2017-07-25.
//  Copyright © 2017 NewBeem. All rights reserved.
//

import UIKit

import FacebookLogin
import FBSDKLoginKit

class ViewController: UIViewController , LoginButtonDelegate{
    @IBOutlet weak var loginFormStackView: UIStackView!

    var dict : [String : AnyObject]!
    
    let userService = UserService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Add Facebook Login button
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
        
        OpenMainWindow()
    }

    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .failed(let error):
            print(error)
        case .cancelled:
            print("User cancelled login.")
        case .success(let grantedPermissions, let declinedPermissions, let accessToken):
            self.OpenMainWindow()
        }
    }

    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Properties
    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textPassword: UITextField!

    // mark: Actions
    @IBAction func btnSignIn(_ sender: UIButton) {
        if let username = textUsername.text, let password = textPassword.text {
            userService.getSiteToken(username: username,
                                     password: password,
                                     response: { (responseString: Any?) -> Void in
                                        if let json = responseString as? [String: String] {
                                            ApplicationConfiguration.token = String(describing: json["token"])
                                            self.OpenMainWindow()
                                        } },
                                     error: { (error: String) -> Void in
                                        print("error = \(error)") } )
            OpenMainWindow()
        }
    }
    
    @IBAction func btnSignUp(_ sender: UIButton) {
    }
    
    
    //function is fetching the user data
    func OpenMainWindow(){
        if(ApplicationConfiguration.token != nil){
            // User is logged in, use 'accessToken' here.
            
        }
        else if let accessToken = FBSDKAccessToken.current() {
            if let socialToken = accessToken.tokenString {
                print(String(describing: socialToken))
                
                userService.getSiteTokenByFacebookToken(facebookAccessToken: socialToken,
                                                        response: { (responseString: Any?) -> Void in
                                                            if let json = responseString as? [String: String] {
                                                                ApplicationConfiguration.token = String(describing: json["token"])
                                                                self.OpenMainWindow()
                                                            } },
                                                        error: { (error: String) -> Void in
                                                            print("error = \(error)") }
                )
                
                // TODO: Open new windows
            }
            
            // Get user graph
            // Shouldn't put in here, move to main window.
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                }
            })
        }
    }
}

