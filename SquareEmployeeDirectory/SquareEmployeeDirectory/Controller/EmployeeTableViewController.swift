//
//  EmployeeTableViewController.swift
//  SquareEmployeeDirectory
//
//  Created by Angelina Wu on 30/01/2021.
//

import UIKit

class EmployeeTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .employeeListHasChanged, object: nil)
        title = "Employee List"
    }
    
    @objc func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let employeeFullName = employeeList[indexPath.row].fullName
        let employeeTeam = employeeList[indexPath.row].team
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath) as! EmployeeTableViewCell
        cell.employeeName.text = employeeFullName
        cell.employeeTeam.text = employeeTeam
        if let employeeSmallPhotoUrl = employeeList[indexPath.row].photoUrlSmall {
            cell.loadSmallPicture(from: employeeSmallPhotoUrl)
        } else {
            if let noPhotoImage = UIImage.generate(with: "N/A") {
                cell.employeePhoto.image = noPhotoImage
            }
            
        }
        return cell
    }
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let nextViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "Employee Detail View") as? EmployeeDetailViewController {
            nextViewController.employee = employeeList[indexPath.row]
            present(nextViewController, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95.0
    }
}
