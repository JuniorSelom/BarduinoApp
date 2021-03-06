//
//  ViewController.swift
//  BarduinoApp
//
//  Created by Selom Viadenou on 06/07/2017.
//  Copyright © 2017 Selom Viadenou. All rights reserved.
//

import UIKit
import SystemConfiguration

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    let defaults = UserDefaults.standard
    var logOk = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        defaults.removeObject(forKey: "token")
        hideKeyboardWhenTappedAround();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginOk" {
            if logOk == true {
                if let destinationVC = segue.destination as? HomeViewController {
                    destinationVC.toto = "bbbbb"
                }
            }
        }
    }*/
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "loginOk"{
            return logOk;
        }
        
        return true;
    }
    
 

    @IBAction func loginBtn(_ sender: Any) {
        print("loginButton")
        let urlLogin = URL(string: config().apiUrl + "login")
        let loginString = String(format: "%@:%@", usernameTextField.text!, passwordTextField.text!)
        print(loginString)
        let loginData = loginString.data(using: .utf8)!
        let base64LoginString = loginData.base64EncodedString()
        print(loginData)
        print(base64LoginString)
        if let url = urlLogin {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let basicStr = String(format: "Basic %@", base64LoginString)
            request.addValue(basicStr, forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            print(basicStr)
            let task = URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in
                if (error != nil) {
                    print("errrror")
                    return;
                }
                if (data != nil) {
                    print("DATA: ")
                    print(data ?? "data")
                    print("RESPONSE: ")
                    print(response ?? "response")
                    print("ERROR: ")
                    print(error ?? "error")
                    if((error) != nil) {
                        print("rr")
                        return;
                    }
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                            print(json)
                            if let token = json["token"] {
                                print(token)
                                self.logOk = true;
                                self.defaults.set(token, forKey: "token")
                                
                                self.performSegue(withIdentifier: "loginOk", sender: nil)
 
                            }
                        }
                    } catch{
                        self.logOk = false;
                        
                        let alert = UIAlertController(title: "Erreur", message: "Merci de vérifiez votre mot de passe ou nom d'utilisateur !", preferredStyle: UIAlertControllerStyle.alert)
                        // add action Non
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                        return;
                    }
                } else {
                    print("BAD LOGIN")
                }
            })
            task.resume()
        }
    }
    
    

    @IBAction func registerBtn(_ sender: Any) {
        print("register")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "registerSegue") as! RegisterViewController
        self.present(vc, animated: true, completion: nil)
    }
    
}

