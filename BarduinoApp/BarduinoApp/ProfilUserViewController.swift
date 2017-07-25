//
//  ProfilUserViewController.swift
//  BarduinoApp
//
//  Created by Francois Devove on 10.07.17.
//  Copyright © 2017 Selom Viadenou. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfilUserViewController: UIViewController {
    var str = String()
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var coinsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        getUserInformations()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserInformations() {
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(String(describing: defaults.object(forKey: "token")!))",
            "Accept": "application/json"
        ]
        
        Alamofire.request(config().apiUrl + "users/1", method: .get, headers: headers).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                // print("Data: \(utf8Text)")
                let json = JSON(data: data)
                print(json["coin"])
                self.usernameLabel.text = json["user"]["username"].stringValue
                self.coinsLabel.text = json["coin"].stringValue
                self.mailLabel.text = json["user"]["email"].stringValue
            } else {
                let alert = UIAlertController(title: "Erreur", message: "Oops, merci de vérifiez votre réseau", preferredStyle: UIAlertControllerStyle.alert)
                // add action Non
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    
    }

    @IBAction func logoutBtn(_ sender: Any) {
        defaults.removeObject(forKey: "token")
        // let storyboard = UIStoryboard(name: "Main", bundle: nil) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginControllerSegue") as! ViewController
        present(vc, animated: true, completion: nil)
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
