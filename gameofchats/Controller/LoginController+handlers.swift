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
            
            let imageUuid = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("\(imageUuid).png")
            let uploadData = UIImagePNGRepresentation(self.profileImageView.image!)
            // Upload the file to the path "images/rivers.jpg"
            _ = storageRef.putData(uploadData!, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                storageRef.downloadURL(completion: { (url, error) in
                    if let profileUrl = url?.absoluteString {
                        let values = ["email": self.emailTextField.text!,
                                                  "password": self.passwordTextField.text!,
                                                  "name": self.nameTextField.text!,
                                                  "profileImageUrl": profileUrl]
                        self.registerUserIntoDatabase(uid: uuid!, values: values as [String : AnyObject])
                    }
                })
                /*
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    
                }*/
            }
        }
    }
    
    private func registerUserIntoDatabase(uid:String, values:[String:AnyObject]) {
        let ref = Database.database().reference(fromURL: "https://gameofchats-db1b4.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            print("Thats ok!!!>>>>>>>>>>>>>>> \(uid)")
            
            self.dismiss(animated: true, completion: nil)
        })
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
