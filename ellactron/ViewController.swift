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
        
        // Add Facebook Login button
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        view.addSubview(loginButton)
        
        if((FBSDKAccessToken.current()) != nil){
            // User is logged in, use 'accessToken' here.
            OpenMainWindow()
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
                self.OpenMainWindow()
            }
        }
    }
    
    //function is fetching the user data
    func OpenMainWindow(){
        if let accessToken = FBSDKAccessToken.current() {
            print(String(describing: accessToken.tokenString))
            let restClient = RestClient()
            /*FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                }
            })*/
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

