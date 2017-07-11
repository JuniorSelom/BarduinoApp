//
//  ViewController.swift
//  BarduinoApp
//
//  Created by Selom Viadenou on 06/07/2017.
//  Copyright © 2017 Selom Viadenou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginOk" {
            if let destinationVC = segue.destination as? HomeViewController {
                destinationVC.toto = "bbbbb"
            }
        }
    }*/
 
 

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
            let tt = String(format: "Basic %@", base64LoginString)
            request.addValue(tt, forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            print(tt)
            let task = URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in
                if (data != nil) {
                    print(data ?? "data")
                    print(response ?? "response")
                    print(error ?? "error")
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                            print(json)
                            if let token = json["token"] {
                                print(token)
                                self.defaults.set(token, forKey: "token")
                                /*
                                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let newViewController = storyBoard.instantiateViewController(withIdentifier: "loginOk") as! HomeViewController
                                self.present(newViewController, animated: true, completion: nil)
                                */
                                /*
                                let newViewController2 = segue.destination as! HomeViewController
                                self.prepare(for: newViewController2, sender: nil)
                                */
                                // self.prepare(for: HomeViewController, sender: nil)
                                // self.performSegue(withIdentifier: "loginOk", sender: nil)
                                
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginOk") as! HomeViewController
                                vc.toto = "tototot" // you can pass parameters like that
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                        
                    } catch let err as NSError {
                        print(err.code)
                    }
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

