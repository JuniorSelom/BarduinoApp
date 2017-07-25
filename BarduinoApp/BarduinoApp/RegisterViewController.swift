//
//  RegisterViewController.swift
//  BarduinoApp
//
//  Created by Francois Devove on 11.07.17.
//  Copyright © 2017 Selom Viadenou. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repasswordTextField: UITextField!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!

    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var repasswordLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    var valid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonSender(_ sender: Any) {
        registerUser()
    }

    @IBAction func cancelButtonSender(_ sender: Any) {
    }
    
    func checkInformations() -> Bool {
        var isOk = true
        print()
        if ((usernameTextField.text?.isEmpty)!) {
            usernameLabel.textColor = UIColor(red: 0.86, green: 0.22, blue: 0.22, alpha: 1.0)
            isOk = false
        }
        if ((mailTextField.text?.isEmpty)!) {
            mailLabel.textColor = UIColor(red: 0.86, green: 0.22, blue: 0.22, alpha: 1.0)
            isOk = false
        }
        if ((passwordTextField.text != repasswordTextField.text) || (passwordTextField.text?.isEmpty)! || (repasswordTextField.text?.isEmpty)!) {
            passwordLabel.textColor = UIColor(red: 0.86, green: 0.22, blue: 0.22, alpha: 1.0)
            repasswordLabel.textColor = UIColor(red: 0.86, green: 0.22, blue: 0.22, alpha: 1.0)
            isOk = false
        }
        return isOk
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "validRegisterSegue") {
            let nextVC = segue.destination as! ViewController;
        } else if (segue.identifier == "cancelRegisterSegue") {
            let nextVCProfil = segue.destination as! ViewController;
        }
    }
 
    
    func registerUser() -> Bool {
        let checkPwd = checkInformations()
        print("----")
        print(checkPwd)
        print("----")
        if (checkPwd) {
            let parameters: Parameters = [
                "username": usernameTextField.text!,
                "email": mailTextField.text!,
                "password": passwordTextField.text!,
                "coin": 11
            ]
            print()
            Alamofire.request(
                config().apiUrl + "createuser",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default
                ).responseJSON { response in
                    print("response Alamofire")
                    print(response)
                    if (response.result.isSuccess) {
                        print("isSuccess ??")
                        self.valid = true
                        self.performSegue(withIdentifier: "validRegisterSegue", sender: self)
                    } else {
                        let alert = UIAlertController(title: "Erreur", message: "Oops, une erreure est survenue pendant la création de votre compte", preferredStyle: UIAlertControllerStyle.alert)
                        // add action Non
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.valid = false
                    }
            }
            return true
        }
        return false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
