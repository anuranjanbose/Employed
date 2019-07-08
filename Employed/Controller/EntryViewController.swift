//
//  ViewController.swift
//  Employed
//
//  Created by Anuranjan Bose on 06/06/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {

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
    
    let font = UIFont.systemFont(ofSize: 16)
    
    @IBOutlet weak var entryChoiceSegment: UISegmentedControl!
    @IBOutlet weak var loginDetailsView: UIView!
    @IBOutlet weak var signUpDetailsView: UIView!
    @IBOutlet weak var loginEmailIdTextField: UITextField!
    @IBOutlet weak var emailValidActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signUpFirstNameTextField: UITextField!
    @IBOutlet weak var signUpLastNameTextField: UITextField!
    @IBOutlet weak var signUpEmailIdTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var toastLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Login"
        self.hideKeyboardWhenTappedAround()
        loginEmailIdTextField.text = "anuranjan.bose@tothenew.com" //Delete after testing
        setUpNavigationBar()
        setUpView()
        setUpTextFields()
        setUpIndicators()
        setPaddingInside(textField: loginEmailIdTextField)
        entryChoiceSegment.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        loginButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loginEmailIdTextField.text = "anuranjan.bose@tothenew.com"
        loginPasswordTextField.text = ""
        loginPasswordTextField.isEnabled = false
        loginEmailIdTextField.layer.borderWidth = 2.0
        loginEmailIdTextField.layer.borderColor = UIColor.black.cgColor
        loginEmailIdTextField.becomeFirstResponder()
        loginActivityIndicator.isHidden = true
        loginPasswordTextField.layer.borderWidth = 0
    }
    
    @IBAction func entrySegmentAction(_ sender: Any) {
        
        switch entryChoiceSegment.selectedSegmentIndex {
        case 0:
            signUpDetailsView.isHidden = true
            loginDetailsView.isHidden = false
            self.navigationItem.title = "Login"
            loginEmailIdTextField.becomeFirstResponder()
            
        case 1:
            signUpDetailsView.isHidden = false
            loginDetailsView.isHidden = true
            self.navigationItem.title = "Sign Up"
            signUpFirstNameTextField.becomeFirstResponder()
            
        default: break
        }
    }
    
    
    func setPaddingInside(textField: UITextField) {
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.rightView = paddingView
        textField.rightViewMode = UITextField.ViewMode.always
    }
    
    func setUpTextFields() {
        loginEmailIdTextField.delegate = self
        loginPasswordTextField.delegate = self
        signUpFirstNameTextField.delegate = self
        signUpLastNameTextField.delegate = self
        signUpEmailIdTextField.delegate = self
        signUpPasswordTextField.delegate = self
        loginEmailIdTextField.layer.borderWidth = 2.0
        loginEmailIdTextField.layer.borderColor = UIColor.black.cgColor
        loginPasswordTextField.isEnabled = false
    }
    
    
    func setUpView() {
        //Login Details View
        loginDetailsView.layer.masksToBounds = true
        loginDetailsView.layer.cornerRadius = 10
        loginDetailsView.layer.borderWidth = 2
        loginDetailsView.layer.borderColor = UIColor.lightGray.cgColor
        loginDetailsView.layer.shadowColor = UIColor.black.cgColor
        loginDetailsView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        loginDetailsView.layer.shadowRadius = 1.0
        loginDetailsView.layer.shadowOpacity = 1.0
        loginDetailsView.layer.masksToBounds = false
        loginDetailsView.isHidden = false

        //Signup Details View
        signUpDetailsView.layer.masksToBounds = true
        signUpDetailsView.layer.cornerRadius = 10
        signUpDetailsView.layer.borderWidth = 2
        signUpDetailsView.layer.borderColor = UIColor.lightGray.cgColor
        signUpDetailsView.layer.shadowColor = UIColor.black.cgColor
        signUpDetailsView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        signUpDetailsView.layer.shadowRadius = 1.0
        signUpDetailsView.layer.shadowOpacity = 1.0
        signUpDetailsView.layer.masksToBounds = false
        signUpDetailsView.isHidden = true
    }
    
    func setUpIndicators() {
        emailValidActivityIndicator.isHidden = true
        loginActivityIndicator.isHidden = true
    }
    
    @IBAction func login() {
        
        loginButton.isEnabled = false
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
        
        func getPostDataAttributes(params:[String:String]) -> Data {
            var data = Data()
            for(key, value) in params {
                let string = "--CuriousWorld\r\n".data(using: .utf8)
                data.append(string!)
                data.append(String.init(format: "Content-Disposition: form-data; name=%@\r\n\r\n", key).data(using: .utf8)!)
                data.append(String.init(format: "%@\r\n", value).data(using: .utf8)!)
                data.append(String.init(format: "--CuriousWorld--\r\n").data(using: .utf8)!)
            }
            return data
        }
        
        let parametersData = getPostDataAttributes(params: parameters)
        
        guard let url = URL(string: "https://qa.curiousworld.com/api/v3/Login?_format=json") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=CuriousWorld", forHTTPHeaderField: "Content-Type")

        
        
        request.httpBody = parametersData
        let session = URLSession.shared
        
        session.dataTask(with: request) {
            (data , response , error) in
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                        if let userData = json["data"] as? [String : Any] {
                            guard let firstName = userData["firstName"] as? String else { return }
                            guard let lastName = userData["lastName"] as? String else { return }
                            //self.loginparams.lastName = lastName
                            
                            guard let uID = userData["uid"] as? String else { return }
                            //self.loginparams.iID = uID
                            
                            guard let subscriptionStatus = userData["subscriptionStatus"] as? String else { return }
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
                            self.loginHandler()
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
       
    }
    
    
    
    func loginHandler() {
        if loginValidationCode == 1 {
            DispatchQueue.main.async {
                self.navigateToProfileViewController()
                print(self.loginValidationMessage)
            }
        } else {
            DispatchQueue.main.async {
                self.loginActivityIndicator.isHidden = true
                self.toastLabel.toast(message: "Incorrect Password")
                self.loginButton.isEnabled = true
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
                                self.signUpHandler()
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
    
    
    
    func signUpHandler() {
        if(signupCode == 1) {
            toastLabel.toast(message: "Registered Successfully")
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.resetSignupViewTextFields), userInfo: nil, repeats: false)
            
        } else {
            toastLabel.toast(message: "\(signupMessage!)")
        }
    }
    
    @objc func resetSignupViewTextFields() {
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
    
    
    func setUpNavigationBar() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: nil)
    }

    
    
    @IBAction func emailIdTextFieldEditingChanged() {
        loginPasswordTextField.layer.borderWidth = 0
        loginPasswordTextField.isEnabled = false
        loginEmailIdTextField.layer.borderColor = UIColor.black.cgColor
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
            
            if loginEmailIdTextField.text == "" {
                self.emailValidActivityIndicator.isHidden = true
                self.toastLabel.isHidden = true
                self.loginEmailIdTextField.layer.borderColor = UIColor.black.cgColor
            } else {
                
                self.emailValidActivityIndicator.isHidden = false
                let mail = loginEmailIdTextField.text
                let parameters = ["mail" : mail]
                guard let url = URL(string: "https://qa.curiousworld.com/api/v3/Validate/Email?_format=json") else { return true }
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else { return true }
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
                                    print("=======\(self.emailValidationCode)")
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
        return true
    }
    
    func validateEmail() {
        if emailValidationCode == 1 {
            DispatchQueue.main.async {
                
                self.loginEmailIdTextField.resignFirstResponder()
                self.toastLabel.isHidden = true
                self.loginPasswordTextField.isEnabled = true
                self.loginPasswordTextField.becomeFirstResponder()
                self.emailValidActivityIndicator.isHidden = true
                self.loginEmailIdTextField.layer.borderWidth = 2.0
                self.loginEmailIdTextField.layer.borderColor = UIColor.iVarGreen.cgColor
                self.loginPasswordTextField.isEnabled = true
                
                self.loginPasswordTextField.layer.borderWidth = 2.0
                self.loginPasswordTextField.layer.borderColor = UIColor.black.cgColor
                self.flag = self.flag + 1
            }
        } else {
            
            DispatchQueue.main.async {
                if self.loginEmailIdTextField.text != "" {
                    self.loginPasswordTextField.isEnabled = false
                    self.emailValidActivityIndicator.isHidden = true
                    self.loginEmailIdTextField.layer.borderWidth = 2.0
                    self.loginEmailIdTextField.layer.borderColor = UIColor.iVarRed.cgColor
                    self.loginPasswordTextField.layer.borderWidth = 0
                    
                    if let message = self.emailMessage {
                          self.toastLabel.toast(message: "\(message)")
                    }
                }

            }
        }
    }
    
    
    
    func navigateToProfileViewController() {
        loginActivityIndicator.isHidden = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
//        controller.employeeName = "\(UserDefaults.standard.string(forKey: "fn")!)  \(UserDefaults.standard.string(forKey: "ln")!)"
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
