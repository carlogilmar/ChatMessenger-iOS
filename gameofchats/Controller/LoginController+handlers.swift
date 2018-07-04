//
//  LoginController+handlers.swift
//  gameofchats
//
//  Created by Carlo Gilmar on 03/07/18.
//  Copyright © 2018 Carlo Gilmar. All rights reserved.
//

import UIKit

extension LoginController {
    
    @objc func handleSelectProfileImageView(){
        print("Hello there!")
        let picker = UIImagePickerController()
        present(picker, animated: true, completion: nil)
    }
}
