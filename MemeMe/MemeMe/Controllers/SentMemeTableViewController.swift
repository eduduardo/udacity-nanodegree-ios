//
//  SentMemeTableViewController.swift
//  MemeMe
//
//  Created by Eduardo Ramos on 13/06/21.
//

import Foundation
import UIKit

class SentMemeTableViewController : MemesDisplayViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView!.reloadData()
    }
    
    // MARK: table view methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell") as! MemeViewCell
        let currentMeme = memes[indexPath.row] as Meme
        cell.memeImageView.image = currentMeme.memedImage
        cell.memeLabelView.text = "\(currentMeme.topText)...\(currentMeme.bottomText)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToSingleMemeView(memes[indexPath.row])
    }
}
