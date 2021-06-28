//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Eduardo Ramos on 16/06/21.
//

import Foundation
import UIKit

class LoginViewController : SharedViewController {
    

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginAction(_ sender: Any) {
        toggleLoadingIndicator(true)
        
        UdacityAPI.shared().login(username: emailField.text ?? "", password: passwordField.text ?? "", completion: handleLoginCompletion(logged:error:))
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        openURL(UdacityAPI.Endpoint.signup.stringValue)
    }
    
    func resetInputs() {
        self.emailField.text = nil
        self.passwordField.text = nil
    }
    
    func handleLoginCompletion(logged: Bool, error: Error?){
        toggleLoadingIndicator(false)

        DispatchQueue.main.async {
            if logged {
                self.resetInputs()
                
                let tabsController = self.storyboard?.instantiateViewController(withIdentifier: "tabs") as! UITabBarController
                self.view.window?.rootViewController = tabsController
                self.view.window?.makeKeyAndVisible()
                
            } else {
                self.showAlertModal("Login Failed", error?.localizedDescription ?? "Login Error")
            }
        }
    }
}
