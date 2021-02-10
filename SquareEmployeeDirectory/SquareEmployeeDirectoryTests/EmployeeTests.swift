//
//  EmployeeTests.swift
//  SquareEmployeeDirectoryTests
//
//  Created by Angelina Wu on 30/01/2021.
//

import XCTest
@testable import SquareEmployeeDirectory

class EmployeeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidSingleEmployee() {
        let jsonData = """
        {
              "uuid" : "some-uuid",
              "full_name" : "Eric Rogers",
              "phone_number" : "5556669870",
              "email_address" : "erogers.demo@squareup.com",
              "biography" : "A short biography describing the employee.",
              "photo_url_small" : "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/small.jpg",
              "photo_url_large" : "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/large.jpg",
              "team" : "Seller",
              "employee_type" : "FULL_TIME",
        }
        """.data(using: .utf8)!
        
        guard let employee = Employee.generate(from: jsonData) else {
            XCTFail("Failed to parse valid JSON")
            return
        }
        XCTAssertEqual(employee.fullName, "Eric Rogers")
        XCTAssertEqual(employee.biography, "A short biography describing the employee.")
        XCTAssertNotNil(employee.photoUrlLarge, "Photo URL is supplied but not parsed")
        XCTAssertEqual(employee.employeeType, .FULL_TIME, "Employee type is wrong")
    }
    
    func testValidSingleEmployeeInList() {
        let jsonData = """
        {"employees": [{
              "uuid" : "some-uuid",
              "full_name" : "Eric Rogers",
              "phone_number" : "5556669870",
              "email_address" : "erogers.demo@squareup.com",
              "biography" : "A short biography describing the employee.",
              "photo_url_small" : "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/small.jpg",
              "photo_url_large" : "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/large.jpg",
              "team" : "Seller",
              "employee_type" : "FULL_TIME",
            }]
        }
        """.data(using: .utf8)!
        
        guard let employeeList = EmployeeList.generate(from: jsonData) else {
            XCTFail("Error parsing from JSON")
            return
        }
        
        XCTAssertEqual(employeeList.employees.count, 1)
        
    }
    
    func testParseAnArrayOfEmployees() {
        let jsonData = """
        {
            "employees" : [
                {
              "uuid" : "0d8fcc12-4d0c-425c-8355-390b312b909c",

              "full_name" : "Justine Mason",
              "phone_number" : "5553280123",
              "email_address" : "jmason.demo@squareup.com",
              "biography" : "Engineer on the Point of Sale team.",

              "photo_url_small" : "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/small.jpg",
              "photo_url_large" : "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/large.jpg",

              "team" : "Point of Sale",
              "employee_type" : "FULL_TIME"
            },

            {
              "uuid" : "a98f8a2e-c975-4ba3-8b35-01f719e7de2d",

              "full_name" : "Camille Rogers",
              "phone_number" : "5558531970",
              "email_address" : "crogers.demo@squareup.com",
              "biography" : "Designer on the web marketing team.",

              "photo_url_small" : "https://s3.amazonaws.com/sq-mobile-interview/photos/5095a907-abc9-4734-8d1e-0eeb2506bfa8/small.jpg",
              "photo_url_large" : "https://s3.amazonaws.com/sq-mobile-interview/photos/5095a907-abc9-4734-8d1e-0eeb2506bfa8/large.jpg",

              "team" : "Public Web & Marketing",
              "employee_type" : "PART_TIME"
            },

            {
              "uuid" : "b8cf3382-ecf2-4240-b8ab-007688426e8c",

              "full_name" : "Richard Stein",
              "phone_number" : "5557223332",
              "email_address" : "rstein.demo@squareup.com",
              "biography" : "Product manager for the Point of sale app!",

              "photo_url_small" : "https://s3.amazonaws.com/sq-mobile-interview/photos/43ed39b3-fbc0-4eb8-8ed3-6a8de479a52a/small.jpg",
              "photo_url_large" : "https://s3.amazonaws.com/sq-mobile-interview/photos/43ed39b3-fbc0-4eb8-8ed3-6a8de479a52a/large.jpg",

              "team" : "Point of Sale",
              "employee_type" : "PART_TIME"
            }]
        }
        """.data(using: .utf8)!
        
        guard let employeeList = EmployeeList.generate(from: jsonData) else {
            XCTFail("Error parsing from JSON")
            return
        }
        
        XCTAssertEqual(employeeList.employees.count, 3)
    }

}
