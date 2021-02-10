//
//  EmployeeDetailViewController.swift
//  SquareEmployeeDirectory
//
//  Created by Angelina Wu on 31/01/2021.
//

import Foundation
import UIKit

class EmployeeDetailViewController: UIViewController {
    @IBOutlet weak var employeePhoto: UIImageView!
    @IBOutlet weak var employeeName: UILabel!
    @IBOutlet weak var employeeTeam: UILabel!
    
    var employee: Employee!
    
    override func viewDidLoad() {
        title = employee.fullName
        employeeName.text = employee.fullName
        employeeTeam.text = employee.team
        // Load the big picture here
        let activityIndicator = UIActivityIndicatorView(style: .large)
        if let url = employee.photoUrlLarge {
            ImageCache.shared.fetch(from: url, completionIfExist: { image in
                self.employeePhoto.image = image
            }, whileFetching: {
                self.employeePhoto.addSubview(activityIndicator)
                activityIndicator.frame = self.employeePhoto.frame
                activityIndicator.startAnimating()
            }, completionAfterFetch: {image in
                self.employeePhoto.image = image
                activityIndicator.stopAnimating()
                self.view.setNeedsLayout()
            }, completionIfFailed: {error in
                debugPrint("Error loading image from URL \(url). Error message: \(error.debugDescription)")
                if let failImage = UIImage.generate(with: "N/A") {
                    self.employeePhoto.image = failImage
                }
            })
        } else {
            if let noLargeUrlImage = UIImage.generate(with: "N/A") {
                self.employeePhoto.image = noLargeUrlImage
            }
        }
    }
    
}
