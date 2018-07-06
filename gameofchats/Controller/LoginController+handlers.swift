//
//  LoginController+handlers.swift
//  gameofchats
//
//  Created by Carlo Gilmar on 03/07/18.
//  Copyright © 2018 Carlo Gilmar. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleRegister() {
        guard emailTextField.text != "" , passwordTextField.text != "", nameTextField.text != ""
            else {
                let invalidFormAlert = UIAlertController(title: " Register FAIL!!!", message: "Llena los campos solicitados 😎", preferredStyle: UIAlertControllerStyle.alert)
                invalidFormAlert.addAction(UIAlertAction(title: "Va de nuez!", style: UIAlertActionStyle.default, handler: nil))
                self.present(invalidFormAlert, animated: true, completion: nil)
                print("Form not valid!")
                return
        }
        


        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            let uuid = Auth.auth().currentUser?.uid
            
            let ref = Database.database().reference(fromURL: "https://gameofchats-db1b4.firebaseio.com/")
            let usersReference = ref.child("users").child(uuid!)
            let values: Dictionary = ["email": self.emailTextField.text!,
                                      "password": self.passwordTextField.text!,
                                      "name": self.nameTextField.text!]
            
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
                print("Thats ok!!!>>>>>>>>>>>>>>> \(uuid!)")
                let storageRef = Storage.storage().reference().child("myImage.png")
                let uploadData = UIImagePNGRepresentation(self.profileImageView.image!)
                // Upload the file to the path "images/rivers.jpg"
                let uploadTask = storageRef.putData(uploadData!, metadata: nil) { (metadata, error) in
                    if error != nil {
                        print(error)
                        print("Image saved no saved!!!")
                        return
                    }
                    print("Image saved!!!")
                    print(metadata)
                }
                self.dismiss(animated: true, completion: nil)
            })
            
            
        }
    }
    
    @objc func handleSelectProfileImageView(){
        print("Hello there!")
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Canceled picker!")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}
