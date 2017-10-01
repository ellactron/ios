//
//  MainViewController.swift
//  ellactron
//
//  Created by Ji Wang on 2017-08-31.
//  Copyright © 2017 NewBeem. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController, UIWebViewDelegate {
    fileprivate var myWebView:UIWebView?

    // MARK: Initial methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addWebView()
        
        let url = URL(string: UIService.getMainPage())
        let request = URLRequest(url: url!)
        myWebView!.loadRequest(request)
    }
    
    private func addWebView() {
        myWebView = UIWebView(
            frame: CGRect(x: barNavigation.frame.origin.x,
                          y: barNavigation.frame.origin.y + barNavigation.bounds.height,
                          width: barNavigation.frame.origin.x + barNavigation.bounds.width,
                          height: UIScreen.main.bounds.height - (barNavigation.frame.origin.y + barNavigation.bounds.height)))
        
        myWebView!.delegate = self
        self.view.addSubview(myWebView!)
    }
    
}
