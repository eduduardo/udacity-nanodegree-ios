//
//  MemesDisplayViewController.swift
//  MemeMe
//
//  Created by Eduardo Ramos on 13/06/21.
//

import Foundation
import UIKit

// abstraction for using on both table and collection controllers
class MemesDisplayViewController : UIViewController {
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    func navigateToSingleMemeView(_ meme: Meme){
        let singleMemeController = storyboard!.instantiateViewController(withIdentifier: "SingleMemeViewController") as! SingleMemeViewController
        singleMemeController.meme = meme
        
        navigationController!.pushViewController(singleMemeController, animated: true)
    }
}
