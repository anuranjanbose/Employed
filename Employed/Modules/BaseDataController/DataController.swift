//
//  DataController.swift
//  Employed
//
//  Created by Anuranjan Bose on 02/09/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import Foundation

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

protocol DataControllerProtocol {
    var headerParameters: [String: String] { get }
    var baseURL: String { get }
    var internetProtocol: String { get }
    var accessToken: String { get }
    var apiVersion: String { get }
    var employedURL: String { get }
    var loginURL: String { get }
    var fileBaseURL: String { get }
}

//extension DataControllerProtocol {
//    var headerParameters: [String: String] {
//        get {
//            let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
//            return ["Authorization": getTokenType() + " " + getAccessToken(), "app-type": "M", "appVersion": appVersion ?? ""
//            ]
//        }
//    }
//}
