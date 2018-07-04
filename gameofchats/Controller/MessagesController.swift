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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Users", style: .plain, target: self, action: #selector(touchme))
       checkIfUserIsLoggedIn()
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            
            let currentUser = Auth.auth().currentUser
            print("Hay usuario")
            print(currentUser!.uid)
            let userID = currentUser!.uid
            let ref = Database.database().reference(fromURL: "https://gameofchats-db1b4.firebaseio.com/")
            ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                // Way 1
                /*
                let value = snapshot.value as? NSDictionary
                let username = value?["name"] as? String ?? ""
                let email = value?["email"] as? String ?? ""
                print(username)
                print(email)
                */
                //Way 2
                if let user = snapshot.value as? [String: AnyObject] {
                 self.navigationItem.title = user["name"] as? String
                 print(user["name"]!)
                 print(user["email"]!)
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
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
        //print("Heeey! I'm the button!")
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated:true, completion: nil)
    }

}

