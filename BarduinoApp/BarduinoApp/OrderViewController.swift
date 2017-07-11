//
//  OrderViewController.swift
//  BarduinoApp
//
//  Created by Francois Devove on 10.07.17.
//  Copyright © 2017 Selom Viadenou. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class OrderViewController: UIViewController {
    var test = String()
    var item: JSON?

    @IBOutlet weak var nameCocktailLabel: UILabel!
    @IBOutlet weak var priceCocktailLabel: UILabel!
    let defaults = UserDefaults.standard
    
    
    @IBOutlet weak var orderBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("OrderViewController")
        print(item!)
        let tt = config().apiUrl
        print(tt)
        // Do any additional setup after loading the view.
        self.nameCocktailLabel.text = self.item?["name"].stringValue
        self.priceCocktailLabel.text = self.item?["prix"].stringValue
        orderBtn.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        orderBtn.isEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func validateOrderBtn(_ sender: Any) {
        print("validateOrderBtn")
        
        let alert = UIAlertController(title: "Commande", message: "Voulez-vous commander cette boisson ?", preferredStyle: UIAlertControllerStyle.alert)
        // add action Non
        alert.addAction(UIAlertAction(title: "Non \u{1f44e}", style: UIAlertActionStyle.cancel, handler: nil))
        // add action Oui
        alert.addAction(UIAlertAction(title: "Oui \u{1f44d}", style: UIAlertActionStyle.default) { action -> Void in
            // remove the element & save
            self.orderDrink()
            // reload the data
            self.viewWillAppear(true)
        })
        self.present(alert, animated: true, completion: nil)
    
    }
    
    func orderDrink() {
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(String(describing: defaults.object(forKey: "token")))",
            "Accept": "application/json"
        ]
        
        Alamofire.request(config().apiUrl + "commander/" + (self.item?["id"].stringValue)!, method: .get, headers: headers).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                // print("Data: \(utf8Text)")
                let json = JSON(data: data)
                print(json)
            }
        }
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
