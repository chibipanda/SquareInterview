//
//  Employee.swift
//  SquareEmployeeDirectory
//
//  Created by Angelina Wu on 30/01/2021.
//

import Foundation

private struct CatchAllCodable: Codable {}

// MARK: Employment Type Enum
enum EmploymentType: String, Codable {
    case FULL_TIME
    case PART_TIME
    case CONTRACTOR
}

// MARK: - Employee List Struct
struct EmployeeList: Codable {
    var employees: [Employee]
    
    init(from decoder: Decoder) throws {
        // I know that this is not required, to retain the valid employees (we are
        // allowed to toss the whole list), but I figured, might as well see if this
        // is doable.
        
        // Adapted from https://github.com/phynet/Lossy-array-decode-swift4
        let container = try decoder.container(keyedBy: CodingKeys.self)
        employees = [Employee]()
        var innerContainer = try container.nestedUnkeyedContainer(forKey: .employees)
        while !innerContainer.isAtEnd {
            if let anEmployee = try? innerContainer.decode(Employee.self) {
                employees.append(anEmployee)
            } else {
                debugPrint("There is a problem parsing an Employee")
                // Basically, the next line is just to make sure that the current
                // "item" got decoded as something, and we can move on to the next
                // "item". Otherwise, it'd just get stuck on the first item that failed.
                _ = try? innerContainer.decode(CatchAllCodable.self)
            }
        }
    }
}

// MARK: - Employee Struct
struct Employee: Codable {
    enum CodingKeys: String, CodingKey {
        // Decided to go this route instead of using the .convertFromSnakeCase
        // for the key decoding strategy. This will give me a bit more control
        // just in case the JSON changes.
        case uuid
        case fullName = "full_name"
        case phoneNumber = "phone_number"
        case emailAddress = "email_address"
        case biography
        case photoUrlSmall = "photo_url_small"
        case photoUrlLarge = "photo_url_large"
        case team
        case employeeType = "employee_type"
    }
    
    var uuid: String
    var fullName: String
    var phoneNumber: String?
    var emailAddress: String
    var biography: String?
    var photoUrlSmall: URL?
    var photoUrlLarge: URL?
    var team: String
    var employeeType: EmploymentType
    
    init(from decoder: Decoder) throws {
        // Decided to make a custom init because of the optionals.
        let employeeData = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try employeeData.decode(String.self, forKey: .uuid)
        fullName = try employeeData.decode(String.self, forKey: .fullName)
        phoneNumber = try employeeData.decodeIfPresent(String.self, forKey: .phoneNumber)
        emailAddress = try employeeData.decode(String.self, forKey: .emailAddress)
        biography = try employeeData.decodeIfPresent(String.self, forKey: .biography)
        if let photoUrlSmallString = try employeeData.decodeIfPresent(String.self, forKey: .photoUrlSmall) {
            photoUrlSmall = URL(string: photoUrlSmallString)
        }
        if let photoUrlLargeString = try employeeData.decodeIfPresent(String.self, forKey: .photoUrlLarge) {
            photoUrlLarge = URL(string: photoUrlLargeString)
        }
        team = try employeeData.decode(String.self, forKey: .team)
        employeeType = try employeeData.decode(EmploymentType.self, forKey: .employeeType)
    }
}


// MARK: - Decode from JSON
extension Employee {
    // abstraction for ease of testing
    static func generate(from data: Data) -> Employee? {
        do {
            return try JSONDecoder().decode(Employee.self, from: data)
        } catch {
            debugPrint("There is an error decoding the employee JSON")
            return nil
        }
    }
}

extension EmployeeList {
    // abstraction for ease of testing
    static func generate(from data: Data) -> EmployeeList? {
        do {
            return try JSONDecoder().decode(EmployeeList.self, from: data)
        } catch {
            debugPrint("There is an error decoding the employee JSON")
            return nil
        }
    }
}
