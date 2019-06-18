//
//  PermissionViewController.swift
//  Employed
//
//  Created by Anuranjan Bose on 18/06/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import UIKit

class PermissionViewController: UIViewController {

    @IBAction func denyButton(_ sender: UIButton) {
        exit(0)
    }
    
    
    @IBAction func acceptButton(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
       // self.navigationController?.pushViewController(controller, animated: true)
        self.present(controller, animated: true, completion: nil)
        UserDefaults.standard.set(true, forKey: "accepted")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
