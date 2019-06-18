//
//  ViewController.swift
//  Employed
//
//  Created by Anuranjan Bose on 06/06/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import UIKit

class LoginSignUpViewController: UIViewController, UITextFieldDelegate {

    var signupCode: Int!
    var signupMessage: String!
    var flag = 0
    
    var forgotMessage: String!
    var forgotCode: Int!
    var mainCode: Int!
    var emailValidationCode: Int!
    var emailMessage: String!
    var firstName: String!
    var lastName: String!
    
    var loginValidationCode: Int!
    var loginValidationMessage: String!
    
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var loginSignUpSegment: UISegmentedControl!
    @IBOutlet weak var loginDetailsView: UIView!
    @IBOutlet weak var signUpDetailsView: UIView!
    @IBOutlet weak var loginEmailIdTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpFirstNameTextField: UITextField!
    @IBOutlet weak var signUpLastNameTextField: UITextField!
    @IBOutlet weak var signUpEmailIdTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    
    @IBOutlet weak var toastLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func loginSignUpSegmentAction(_ sender: Any) {
        if loginSignUpSegment.selectedSegmentIndex == 0 {
            signUpDetailsView.isHidden = true
            loginDetailsView.isHidden = false
            self.navigationItem.title = "Login"
            
        }
        else if loginSignUpSegment.selectedSegmentIndex == 1 {
            signUpDetailsView.isHidden = false
            loginDetailsView.isHidden = true
            self.navigationItem.title = "Sign Up"
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Login"
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = "Login"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Login"

        self.loginEmailIdTextField.delegate = self
     //   self.loginEmailIdTextField.delegate = self
        
        //Initial state
        activityIndicator.isHidden = true
        tickImageView.isHidden = true
        loginDetailsView.isHidden = false
        signUpDetailsView.isHidden = true
        
        loginPasswordTextField.isEnabled = false
        
        loginEmailIdTextField.becomeFirstResponder()
        loginButton.isEnabled = false
        loginActivityIndicator.isHidden = true
    }
    
    @IBAction func login() {
        
        
      //  self.activityIndicatorLoginView.isHidden = false
        loginActivityIndicator.isHidden = false
        let mail = loginEmailIdTextField.text!
        let password = loginPasswordTextField.text!
        
        let parameters = [
            "mail" : mail ,
            "password" : password,
            "client_secret" : "abcde12345",
            "client_id" : "ec7c3bde-9f51-4113-9ecf-6ca6fd03b66b",
            "scope" : "ios",
            "deviceId" : "123456",
            "grant_type" : "password"]
        
        func getPostDataAttributes(params:[String:String]) -> Data
        {
            var data = Data()
            for(key, value) in params
            {
                let string = "--CuriousWorld\r\n".data(using: .utf8)
                data.append(string!)
                data.append(String.init(format: "Content-Disposition: form-data; name=%@\r\n\r\n", key).data(using: .utf8)!)
                data.append(String.init(format: "%@\r\n", value).data(using: .utf8)!)
                data.append(String.init(format: "--CuriousWorld--\r\n").data(using: .utf8)!)
            }
            return data
        }
        
        let parametersData = getPostDataAttributes(params: parameters)
        
        guard let url = URL(string: "https://qa.curiousworld.com/api/v3/Login?_format=json")
            else {
                return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=CuriousWorld", forHTTPHeaderField: "Content-Type")
        
        
        
        //        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else
        //        {
        //            return
        //        }
        
        
        
        request.httpBody = parametersData
        let session = URLSession.shared
        
        session.dataTask(with: request) {
            (data , response , error) in
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                        if let userData = json["data"] as? [String : Any] {
                            guard let firstName = userData["firstName"] as? String else { return }
                            //self.loginparams.firstName = firstName
                            //print(firstName)
                            guard let lastName = userData["lastName"] as? String else { return }
                            //self.loginparams.lastName = lastName
                            
                            guard let uID = userData["uid"] as? String else { return }
                            //self.loginparams.iID = uID
                            
                            guard let subscriptionStatus = userData["subscriptionStatus"] as? String else { return }
                            //self.loginparams.Subscribtion = subscriptionStatus
                            UserDefaults.standard.set(true, forKey: "loggedin")
                            UserDefaults.standard.set(firstName, forKey: "fn")
                            UserDefaults.standard.set(lastName, forKey: "ln")
                            UserDefaults.standard.set(uID, forKey: "uid")
                            UserDefaults.standard.set(subscriptionStatus, forKey: "sub")
                        }
                        if let statusmsg = json["status"] as? [String : Any]
                        {
                            guard let codeResponse = statusmsg["code"] as? Int else { return }
                            self.loginValidationCode = codeResponse
                            
                            guard let messageResponse = statusmsg["message"] as? String else { return }
                            self.loginValidationMessage = messageResponse
                            print(self.loginValidationCode)
                            self.loginApiHandler()
                        }
                    }
                }
                catch
                {
                    print(error)
                }
            }
            }.resume()
       
    }
    
    
    
    func loginApiHandler()
    {
        if loginValidationCode == 1 {
            DispatchQueue.main.async {
                
//                self.showProfileView()
                self.navigateToWelcomeNewUserViewController()
                print(self.loginValidationMessage)
//                self.toastMessageLabel.toastMessageLabel(message: self.loginValidationMessage)
            }
        } else {
            DispatchQueue.main.async {
                self.loginActivityIndicator.isHidden = true
                self.toastLabel.toast(message: "Incorrect Password")
//                self.activityIndicatorLoginView.isHidden = true
               // self.toastMessageLabel.toastMessageLabel(message: self.loginValidationMessage)
               // self.toastLabel
            }
        }
    }

    @IBAction func signUp() {
        let firstName = signUpFirstNameTextField.text!
        let lastName = signUpLastNameTextField.text!
        let password = signUpPasswordTextField.text!
        let email = signUpEmailIdTextField.text!
        let parameters = ["firstName" : firstName,
                          "lastName" : lastName,
                          "mail" : email,
                          "deviceId" : "12345",
                          "password" : password ]
        
        guard let url = URL(string: "https://qa.curiousworld.com/api/v3/SignUp") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
            return }
        request.httpBody = httpBody
        let session = URLSession.shared
        print("============%@", parameters)
        print("============%@", request.allHTTPHeaderFields)
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                        print("json \(json)")
                        if let statusMessage = json["status"] as? [String:Any]{
                            print(statusMessage)
                            guard let codeResponse = statusMessage["code"] as? Int else {return}
                            print("=========================== \(codeResponse)")
                            self.signupCode = codeResponse
                            //                            DispatchQueue.main.async {
                            //                                self.navigate()
                            //                            }
                        }
                        if let statusMessage = json["status"] as? [String:Any] {
                            print(statusMessage)
                            guard let codeMessageResponse = statusMessage["message"] as? String else {return}
                            print("=========================== \(codeMessageResponse)")
                            self.signupMessage = codeMessageResponse ?? "Email Already Registered"
                            DispatchQueue.main.async {
                                self.navigate()
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
            
            }.resume()
        print(signupCode)
    }
    
    
    
    func navigate() {
        if(signupCode == 1) {
            toastLabel.toast(message: "Registered Successfully")
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.callbackPOP), userInfo: nil, repeats: false)
            
        } else {
            toastLabel.toast(message: "\(signupMessage!)")
        }
    }
    
    @objc func callbackPOP() {
        self.navigationController?.popViewController(animated: true)
        signUpFirstNameTextField.text = ""
        signUpLastNameTextField.text = ""
        signUpEmailIdTextField.text = ""
        signUpPasswordTextField.text = ""
    }
    
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        let mail = loginEmailIdTextField.text
        let parameters = ["mail" : mail ]
        guard let url = URL(string: "https://qa.curiousworld.com/api/v3/ForgetPassword?_format=json") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
            return }
        request.httpBody = httpBody
        let session = URLSession.shared
        print("============%@", parameters)
        print("============%@", request.allHTTPHeaderFields)
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                        print("json \(json)")
                        if let statusCode = json["status"] as? [String:Any]{
                            print(statusCode)
                            guard let codeResponseOfEmail = statusCode["code"] as? Int else {return}
                            print("=========================== \(codeResponseOfEmail)")
                            self.forgotCode = codeResponseOfEmail
                        }
                        if let statusMessage = json["status"] as? [String:Any]{
                            print(statusMessage)
                            guard let codeResponseMessageOfEmail = statusMessage["message"] as? String else {return}
                            print("=========================== \(codeResponseMessageOfEmail)")
                            self.forgotMessage = codeResponseMessageOfEmail
                            DispatchQueue.main.async {
                                self.toastLabel.toast(message: "\(self.forgotMessage!)")
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
            
            }.resume()
        print(emailValidationCode)
        print(emailMessage)
    }
    
    
    

    
    
    @IBAction func emailIdTextFieldEditingChanged() {
        
        if loginEmailIdTextField.text == "" {
            self.tickImageView.isHidden = true
            self.activityIndicator.isHidden = true
            self.toastLabel.isHidden = true
        } else {
        
        self.tickImageView.isHidden = true
        self.activityIndicator.isHidden = false
        let mail = loginEmailIdTextField.text
        let parameters = ["mail" : mail]
        guard let url = URL(string: "https://qa.curiousworld.com/api/v3/Validate/Email?_format=json") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
                return }
        request.httpBody = httpBody
        let session = URLSession.shared
        print("============%@", parameters)
        print("============%@", request.allHTTPHeaderFields)
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                        print("json \(json)")
                        if let statusCode = json["status"] as? [String:Any]{
                            print(statusCode)
                            guard let codeResponse = statusCode["code"] as? Int else {return}
                            print("=========================== \(codeResponse)")
                            self.emailValidationCode = codeResponse
                            self.validateEmail()
                        }
                        if let statusMessage = json["status"] as? [String:Any]{
                            print(statusMessage)
                            guard let codeResponseMessage = statusMessage["message"] as? String else {return}
                            print("=========================== \(codeResponseMessage)")
                            self.emailMessage = codeResponseMessage
                        }
                    }
                } catch {
                    print(error)
                }
            }
            
            }.resume()
        print(emailValidationCode as Any)
        print(emailMessage as Any)
        }
        
    }

    
    @IBAction func passwordFieldEditingChanged() {
        if loginPasswordTextField.text == "" {
           loginButton.isEnabled = false
        } else {
           loginButton.isEnabled = true
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginEmailIdTextField {
            loginPasswordTextField.becomeFirstResponder()
        }
        return true
    }
    func validateEmail() {
        if emailValidationCode == 1 {
            DispatchQueue.main.async {
                self.toastLabel.isHidden = true
                self.loginPasswordTextField.isEnabled = true
                self.activityIndicator.isHidden = true
                self.tickImageView.isHidden = false
                self.tickImageView.image = UIImage(named: "tick.png")
                self.loginPasswordTextField.isEnabled = true
                self.flag = self.flag + 1
            }
        }
        else {
            
            DispatchQueue.main.async {
                if self.loginEmailIdTextField.text != "" {
                    self.loginPasswordTextField.isEnabled = false
                    self.activityIndicator.isHidden = true
                    self.tickImageView.isHidden = false
                    self.tickImageView.image = UIImage(named: "cross.png")
                    
                    if let message = self.emailMessage {
                          self.toastLabel.toast(message: "\(message)")
                    }
                }

            }
        }
    }
    
    
    
    func navigateToWelcomeNewUserViewController() {
        loginActivityIndicator.isHidden = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "WelcomeNewUserViewController") as! WelcomeNewUserViewController
        controller.employeeName = "\(UserDefaults.standard.string(forKey: "fn")!)  \(UserDefaults.standard.string(forKey: "ln")!)"
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
