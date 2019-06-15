//
//  WelcomeNewUserViewController.swift
//  Employed
//
//  Created by Anuranjan Bose on 11/06/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import UIKit
import MapKit

class WelcomeNewUserViewController: UIViewController {
    
    var employeeName: String!

    @IBOutlet weak var logoutActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var employeeProfileImageView: UIImageView!
    
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var updateImageButton: UIButton!
    
    @IBAction func logoutButtonAction() {
        UserDefaults.standard.set(false, forKey: "loggedin")
        UserDefaults.standard.set("nil", forKey: "fn")
        UserDefaults.standard.set("nil", forKey: "ln")
        UserDefaults.standard.set("nil", forKey: "uid")
        UserDefaults.standard.set("nil", forKey: "sub")
       // self.dismiss(animated: true, completion: nil)
         logoutActivityIndicator.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
           // self.myTableView.reloadData()
           self.navigationController?.popViewController(animated: true)
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutActivityIndicator.isHidden = true
    self.navigationController?.isNavigationBarHidden = true
        employeeNameLabel.text = employeeName

    }
    
}
