//
//  Extensions.swift
//  SquareEmployeeDirectory
//
//  Created by Angelina Wu on 30/01/2021.
//

import Foundation
import UIKit

extension Notification.Name {
    static let employeeListHasChanged = Notification.Name(rawValue: "Employee List Has Changed")
}

extension UIImage {
    static func generate(with word: String) -> UIImage? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        label.text = word.uppercased()
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 100)
        label.adjustsFontSizeToFitWidth = true
        
        // The following part adapted from:
        // http://www.matthewhsingleton.com/coding-with-a-rubber-ducky/\
        // 2017/7/30/swift-3-generate-uiimage-of-letters-from-string
        UIGraphicsBeginImageContext(CGSize(width: 250, height: 250))
        var image: UIImage?
        if let currentContext = UIGraphicsGetCurrentContext() {
            label.layer.render(in: currentContext)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
}
