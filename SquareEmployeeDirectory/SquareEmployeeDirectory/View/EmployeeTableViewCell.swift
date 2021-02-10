//
//  EmployeeTableViewCell.swift
//  SquareEmployeeDirectory
//
//  Created by Angelina Wu on 31/01/2021.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {
    @IBOutlet weak var employeePhoto: UIImageView!
    @IBOutlet weak var employeeName: UILabel!
    @IBOutlet weak var employeeTeam: UILabel!
}

// MARK: - Loading Small Picture
extension EmployeeTableViewCell {
    func loadSmallPicture(from url: URL) {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        ImageCache.shared.fetch(from: url, completionIfExist: {image in
            self.employeePhoto.image = image
        }, whileFetching: {
            self.employeePhoto.addSubview(activityIndicator)
            activityIndicator.frame = self.employeePhoto.frame
            activityIndicator.startAnimating()
        }, completionAfterFetch: {image in
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            self.employeePhoto.image = image
            self.setNeedsLayout()
        }, completionIfFailed: {error in
            debugPrint("Error loading image from URL \(url). Error message: \(error.debugDescription)")
            if let failImage = UIImage.generate(with: "N/A") {
                self.employeePhoto.image = failImage
                self.setNeedsLayout()
            }
        })
    }
}

