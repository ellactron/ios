//
//  BascViewController.swift
//  ellactron
//
//  Created by Ji Wang on 2017-09-03.
//  Copyright © 2017 NewBeem. All rights reserved.
//


import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet weak var barNavigation: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addNavigateBarItems()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addNavigateBarItems() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "banner.png")
        imageView.image = image
        navigationItem.titleView = imageView
    }
}
