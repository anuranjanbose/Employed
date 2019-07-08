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

    
    @IBAction func logoutButtonAction() {
        UserDefaults.standard.set(false, forKey: "loggedin")
        UserDefaults.standard.set("nil", forKey: "fn")
        UserDefaults.standard.set("nil", forKey: "ln")
        UserDefaults.standard.set("nil", forKey: "uid")
        UserDefaults.standard.set("nil", forKey: "sub")
       // self.dismiss(animated: true, completion: nil)
        // logoutActivityIndicator.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
           // self.myTableView.reloadData()
           self.navigationController?.popViewController(animated: true)
        })
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        self.navigationItem.hidesBackButton = true
    }
    
}
