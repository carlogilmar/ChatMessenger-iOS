//
//  ViewController.swift
//  gameofchats
//
//  Created by Carlo Gilmar on 29/06/18.
//  Copyright © 2018 Carlo Gilmar. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",	 style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Touch me!", style: .plain, target: self, action: #selector(touchme))
    }

    //TODO: Check this, is an error by objective-C declaration
    @objc func handleLogout(){
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        
    }
    
    @objc func touchme() {
        print("Heeey! I'm the button!")
    }

}

