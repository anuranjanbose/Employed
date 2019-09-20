//
//  UserModel.swift
//  Employed
//
//  Created by Anuranjan Bose on 02/09/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import Foundation

struct UserModel {
    var firstName: String?
    var lastName: String?
    var uid: String?
    var subscriptionStatus: String?
    
    init(json: [String : Any]) {
        self.firstName = json["firstName"] as? String
        self.lastName = json["lastName"] as? String
        self.uid = json["uid"] as? String
        self.subscriptionStatus = json["subscriptionStatus"] as? String
    }
}
