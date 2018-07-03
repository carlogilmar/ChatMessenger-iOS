//
//  NewMessageController.swift
//  gameofchats
//
//  Created by Carlo Gilmar on 03/07/18.
//  Copyright © 2018 Carlo Gilmar. All rights reserved.
//

import UIKit

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissNewMessageController))
    }

    @objc func dismissNewMessageController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        cell.textLabel?.text = "Dummy Text!"
        return cell
    }
}
