//
//  SignUp.swift
//  ellactron
//
//  Created by Ji Wang on 2017-08-27.
//  Copyright © 2017 NewBeem. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    let userService = UserService()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var labelErrorMessage: UILabel!

    @IBAction func btnSignUp(_ sender: Any) {
        if let username = textUsername.text, let password = textPassword.text {
            userService.register(username: username,
                                 password: password,
                                 response: { (responseString: Any?) -> Void in
                                    if let json = responseString {
                                        let viewController: ViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignIn.storyboard") as! ViewController
                                        OperationQueue.main.addOperation {
                                            viewController.username = username
                                            viewController.password = password
                                            self.present(viewController, animated:true, completion:nil)
                                            viewController.SignIn()
                                        }
                                    } },
                                 error: { (error: String) -> Void in
                                    self.labelErrorMessage.text = error } )
        }
    }

}
