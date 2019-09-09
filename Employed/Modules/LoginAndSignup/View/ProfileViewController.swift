//
//  WelcomeNewUserViewController.swift
//  Employed
//
//  Created by Anuranjan Bose on 11/06/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import UIKit
import MapKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var welcomeEmployeeLabel: UILabel!
    
    var employeeName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeEmployeeLabel.text = "Welcome \(employeeName)"
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.navigationItem.title = "Profile"
        self.navigationItem.hidesBackButton = true
        //Logout Button
        let logoutImage = UIImage(named: "logout.png")
        let logoutBarButton = UIBarButtonItem(image:logoutImage , style: .plain, target: self, action: #selector(logoutAction))
        self.navigationItem.rightBarButtonItem = logoutBarButton
    }
    
    @objc func logoutAction() {
        UserDefaults.standard.set(false, forKey: "loggedin")
        UserDefaults.standard.set("nil", forKey: "fn")
        UserDefaults.standard.set("nil", forKey: "ln")
        UserDefaults.standard.set("nil", forKey: "uid")
        UserDefaults.standard.set("nil", forKey: "sub")
        self.navigationController?.popViewController(animated: true)
    }
}
