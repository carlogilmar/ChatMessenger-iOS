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
                user.profileImageUrl = userStored["profileImageUrl"]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UserCell
        
        let user = users[indexPath.row]
        cell!.textLabel?.text = user.name
        cell!.detailTextLabel?.text = user.email
        
        print("Downloading URL")
        print(user.profileImageUrl)
        if let profileImageUrl = user.profileImageUrl {
            let url = URL(string: profileImageUrl)
            print("The profile image is:")
            print(profileImageUrl)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error as Any)
                    return
                }
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        print("I'm here downloading the image!")
                        print("profileImageUrl")
                        cell?.profileImageView.image = UIImage(data: data!)
                        //cell.imageView?.image = UIImage(data: data!)
                    }
                }
            }).resume()
        }

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}

class UserCell: UITableViewCell {
    
    //Episode 6
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "md")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        
        //constrains
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented!")
    }
}
