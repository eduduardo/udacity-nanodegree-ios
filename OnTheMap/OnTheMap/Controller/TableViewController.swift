//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Eduardo Ramos on 19/06/21.
//

import Foundation
import UIKit

class TableViewController : SharedViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var studentLocations = [StudentInformation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getStudents()
    }
    
    func getStudents() {
        toggleLoadingIndicator(true)
        
        UdacityAPI.shared().getLocations() { studentLocations, error in
            if error != nil {
                self.showAlertModal("Map problem", error?.localizedDescription ?? "Not able to display student locations")
                return
            }
            self.studentLocations = studentLocations ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.toggleLoadingIndicator(false)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as! StudentLocationCellView
        cell.setupStudentLocation(studentLocations[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = studentLocations[indexPath.row]
        openURL(student.mediaURL ?? "")
    }
    
    @IBAction func refreshAction(_ sender: Any){
        getStudents()
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        logout()
    }
    
}
