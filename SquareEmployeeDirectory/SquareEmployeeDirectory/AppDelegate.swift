//
//  AppDelegate.swift
//  SquareEmployeeDirectory
//
//  Created by Angelina Wu on 30/01/2021.
//

import UIKit

// I decided to make this a global variable, and load this up when the
// app launches. Since we might have a situation where the tableView is
// already loaded before the employee list comes back, I added an
// observer here to post a notification so that the tableView can reload
// when this fully comes back.
var employeeList = [Employee]() {
    didSet {
        NotificationCenter.default.post(name: .employeeListHasChanged, object: nil)
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    final let VALID_EMPLOYEES_JSON = "https://s3.amazonaws.com/sq-mobile-interview/employees.json"
    final let MALFORMED_EMPLOYEES_JSON = "https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json"
    final let EMPTY_EMPLOYEES_JSON = "https://s3.amazonaws.com/sq-mobile-interview/employees_empty.json"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Download the employee list, since we can download this once when the app launch.
        if let url = URL(string: MALFORMED_EMPLOYEES_JSON) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    // Parse this into EmployeeList
                    if let list = EmployeeList.generate(from: data) {
                        employeeList = list.employees
                    }
                }
            }.resume()
        }
        // Also need to resurrect the cache
        ImageCache.shared.resurrectCache()
        return true
    }
}

