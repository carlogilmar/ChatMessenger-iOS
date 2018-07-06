//
//  NewMessageController.swift
//  gameofchats
//
//  Created by Carlo Gilmar on 03/07/18.
//  Copyright © 2018 Carlo Gilmar. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    var users:[User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissNewMessageController))
        navigationItem.title = "Users!"
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUsers()
    }
    
    func fetchUsers(){
        let ref = Database.database().reference(fromURL: "https://gameofchats-db1b4.firebaseio.com/")
        ref.child("users").observe(.childAdded, with:  {(snapshot) in
            if let userStored = snapshot.value as? [String: String] {
                let user = User()
                user.email = userStored["email"]
                user.name = userStored["name"]
                print(user.name!, user.email!)
                self.users.append(user)
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }, withCancel: nil)
    }

    @objc func dismissNewMessageController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        cell.imageView?.image = UIImage(named: "md")

        return cell
    }
}

class UserCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented!")
    }
}
