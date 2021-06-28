//
//  StudentLocationCellView.swift
//  OnTheMap
//
//  Created by Eduardo Ramos on 19/06/21.
//

import UIKit

class StudentLocationCellView: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    func setupStudentLocation(_ studentLocation: StudentInformation){
        nameLabel.text = studentLocation.firstName
        locationLabel.text = studentLocation.mediaURL
    }
}
