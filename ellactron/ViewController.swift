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

class ViewController: UIViewController {
    @IBOutlet weak var loginFormStackView: UIStackView!

    var dict : [String : AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if let accessToken = FBSDKAccessToken.current() {
            // User is logged in, use 'accessToken' here.
            print(accessToken)
            getFBUserData()
        }
        else {
            // Add Facebook Login button
            let loginButton = LoginButton(readPermissions: [ .publicProfile ])
            loginButton.center = view.center
            view.addSubview(loginButton)
        }
    }
    
    
    //when login button clicked
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }
        }
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                }
            })
        }
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
    }
    
    @IBAction func btnSignUp(_ sender: UIButton) {
    }
}

