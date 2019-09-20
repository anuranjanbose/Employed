//
//  UserRegistrationModel.swift
//  Employed
//
//  Created by Anuranjan Bose on 20/09/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import Foundation

struct UserRegistrationModel: BaseModelProtocol {
    
    let firstName: String?
    let lastName: String?
    let email: String?
    let password: String?
    
    init?(dictValues: [String : Any]) {
        firstName = dictValues["firstName"] as? String
        lastName = dictValues["lastName"] as? String
        email = dictValues["email"] as? String
        password = dictValues["password"] as? String
    }
}
