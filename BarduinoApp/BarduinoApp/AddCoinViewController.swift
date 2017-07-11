//
//  AddCoinViewController.swift
//  BarduinoApp
//
//  Created by Francois Devove on 11.07.17.
//  Copyright © 2017 Selom Viadenou. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddCoinViewController: UIViewController {
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func add10Coins(_ sender: Any) {
        callAlert(message: "Ajouter 10 coins", nbCoins: 10)
    }

    @IBAction func add50Coins(_ sender: Any) {
        callAlert(message: "Ajouter 50 coins", nbCoins: 50)
    }
    
    @IBAction func add100Coins(_ sender: Any) {
        callAlert(message: "Ajouter 100 coins", nbCoins: 100)
    }
    
    @IBAction func add200Coins(_ sender: Any) {
        callAlert(message: "Ajouter 200 coins", nbCoins: 200)
    }
    
    func addCoins(nbCoins: Int) {
        print(nbCoins)
        
        let body: [String: Any] = [
            "coin": nbCoins
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        
        if let url = URL(string: config().apiUrl + "addcoin") {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.post.rawValue
            urlRequest.addValue("Basic \(String(describing:self.defaults.object(forKey: "token")!))", forHTTPHeaderField: "Authorization")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            print(urlRequest.value(forHTTPHeaderField: "Authorization")!)

            
            urlRequest.httpBody = jsonData
        
            Alamofire.request(urlRequest).responseString { response in
                print(response)
                if (response.result.isSuccess) {
                    self.validAlert(validMessage: "Merci pour votre commande")
                } else {
                    self.validAlert(validMessage: "Echec lors de votre commande")
                }
            }
        }

    }
    
    func callAlert(message: String, nbCoins: Int) {
        let alert = UIAlertController(title: "Commande", message: message, preferredStyle: UIAlertControllerStyle.alert)
        // add action Non
        alert.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.cancel, handler: nil))
        // add action Oui
        alert.addAction(UIAlertAction(title: "Valider", style: UIAlertActionStyle.default) { action -> Void in
            // remove the element & save
            self.addCoins(nbCoins: nbCoins)
            // reload the data
            self.viewWillAppear(true)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func validAlert(validMessage: String) {
        let alert = UIAlertController(title: "Commande", message: validMessage, preferredStyle: UIAlertControllerStyle.alert)
        // add action Non
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
