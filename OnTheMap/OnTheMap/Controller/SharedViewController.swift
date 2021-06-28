//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Eduardo Ramos on 19/06/21.
//

import UIKit

class SharedViewController : UIViewController {
    
    var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLoadingIndicator()
    }
    
    func addLoadingIndicator(){
        loadingIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        self.view.addSubview(loadingIndicator)
        loadingIndicator.bringSubviewToFront(self.view)
        loadingIndicator.center = self.view.center
    }
    
    func toggleLoadingIndicator(_ loading: Bool){
        DispatchQueue.main.async {
            self.loadingIndicator.isHidden = loading
            loading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
        }
    }
    
    func openURL(_ url: String){
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url) else {
            showAlertModal("Invalid link", "Cannot open this link")
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    func showAlertModal(_ title: String, _ message: String, completion: @escaping (UIAlertAction) -> Void = { _ in }){
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completion(action)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func logout(){
        UdacityAPI.shared().logout() { success,error in
            if error != nil {
                self.showAlertModal("Logout", "Not able to loguout, please, try again!")
                return
            }
            
            DispatchQueue.main.async {
                let loginController = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
                self.view.window?.rootViewController = loginController
                self.view.window?.makeKeyAndVisible()
                
            }
        }
    }
}
