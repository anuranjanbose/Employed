//
//  StringExtension.swift
//  Employed
//
//  Created by Anuranjan Bose on 06/07/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import Foundation

extension String {
    //Validate email
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.count)) != nil
        } catch {
            return false
        }
    }
    
    //Validate Password
    var isPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@$!_]).{8,15})", options: [])
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.count)) != nil
        } catch {
            return false
        }
    }
}
