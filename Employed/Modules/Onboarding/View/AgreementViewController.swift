//
//  PermissionViewController.swift
//  Employed
//
//  Created by Anuranjan Bose on 18/06/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import UIKit

class AgreementViewController: UIViewController {

    @IBAction func denyButton(_ sender: UIButton) {
        exit(0)
    }
    
    
    @IBAction func acceptButton(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
        self.present(controller, animated: true, completion: nil)
        UserDefaults.standard.set(true, forKey: "accepted")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}
