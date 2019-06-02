//
//  ViewController.swift
//  mapApplication
//
//  Created by sundus on 16/08/1440 AH.
//  Copyright © 1440 sundus. All rights reserved.
//

import UIKit

class logInVC: UIViewController {
    
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
 
    
    @IBAction func logInButton(_ sender: Any) {
        
        let username = emailText.text
        let password = passwordText.text
        
        if username!.isEmpty || password!.isEmpty{
            let alertController = UIAlertController(title: "Warning", message: "Please fill Emali and password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Client.login(username, password){ (loginSuccess, key, error) in
                DispatchQueue.main.async {
                    if error != nil {
                        let alertController = UIAlertController(title: "Warning", message: "Error in your request", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                        return
                    }
                    
                    if !loginSuccess {
                        let alertController = UIAlertController(title: "Warning", message: "InCorrect Emali and password", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        
                        self.performSegue(withIdentifier: "mapView", sender: self)
                    }
                }
            }
            
        }
 
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
        if let url = URL(string:"https://auth.udacity.com/sign-up"){
            UIApplication.shared.openURL(url)
        }
        
    }


}


