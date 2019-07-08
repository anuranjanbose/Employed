//
//  Employee.swift
//  Employed
//
//  Created by Anuranjan Bose on 11/06/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]
struct Employee: Decodable {
    var id:String
    var employee_name:String
    var employee_salary:String
    var employee_age:String
    var profile_image:String
}

extension Employee{
    init(json:JSON) {
        self.id = json["id"] as! String
        self.employee_name = json["employee_name"] as! String
        self.employee_age = json["employee_age"] as! String
        self.employee_salary = json["employee_salary"] as! String
        self.profile_image = json["profile_image"] as! String
    }
}
