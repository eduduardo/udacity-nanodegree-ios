//
//  UIViewController+Extension.swift
//  Virtual Tourist
//
//  Created by Eduardo Ramos on 27/06/21.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertModal(_ title: String, _ message: String, completion: @escaping (UIAlertAction) -> Void = { _ in }){
        DispatchQueue.main.async {
            let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                completion(action)
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
