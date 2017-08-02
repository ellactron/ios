//
//  ViewController.swift
//  ellactron
//
//  Created by admin on 2017-07-25.
//  Copyright © 2017 NewBeem. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

