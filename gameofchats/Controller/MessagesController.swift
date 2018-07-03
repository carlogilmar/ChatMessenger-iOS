//
//  ViewController.swift
//  gameofchats
//
//  Created by Carlo Gilmar on 29/06/18.
//  Copyright © 2018 Carlo Gilmar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MessagesController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let ref = Database.database().reference(fromURL: "https://gameofchats-db1b4.firebaseio.com/")
        //ref.updateChildValues(["someValue":123])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",	 style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Touch me!", style: .plain, target: self, action: #selector(touchme))
        
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
           let currentUser = Auth.auth().currentUser?.uid
           print("Hay usuario")
           print(currentUser!)
        }
    }

    //TODO: Check this, is an error by objective-C declaration
    @objc func handleLogout(){
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        
    }
    
    @objc func touchme() {
        print("Heeey! I'm the button!")
    }

}

