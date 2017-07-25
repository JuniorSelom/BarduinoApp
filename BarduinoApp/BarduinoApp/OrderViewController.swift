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

    @IBOutlet weak var imageCocktail: UIImageView!
    @IBOutlet weak var nameCocktailLabel: UILabel!
    @IBOutlet weak var priceCocktailLabel: UILabel!
    
    @IBOutlet weak var firstIngredientCocktailLabel: UILabel!
    @IBOutlet weak var secondIngredientCocktailLabel: UILabel!
    
    @IBOutlet weak var orderButton: UIButton!
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var orderBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("OrderViewController")
        print(item!)
        let tt = config().apiUrl
        print(tt)
        
        orderBtn.layer.cornerRadius = 10
        orderBtn.layer.borderWidth = 1.0
        orderBtn.layer.borderColor = UIColor.white.cgColor
        
        self.nameCocktailLabel.text = self.item?["name"].stringValue
        self.priceCocktailLabel.text = (self.item?["prix"].stringValue)! + " crédits"
        
        self.firstIngredientCocktailLabel.text = "- " + (self.item?["drinks"][0]["name"].stringValue)!
        self.secondIngredientCocktailLabel.text = "- " + (self.item?["drinks"][1]["name"].stringValue)!
        
        var nameImage = (self.item?["name"].string)! + ".png"
        nameImage = nameImage.replacingOccurrences(of: " ", with: "_")
        imageCocktail.image = UIImage(named: nameImage)
        
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
            "Authorization": "Basic \(String(describing: defaults.object(forKey: "token")!))",
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
                if(response.response?.statusCode == 200){
                    let alert = UIAlertController(title: "Commande", message: "Commande Validée !", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok",style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alert,animated: true,completion: nil)
                } else {
                    let alert = UIAlertController(title: "Erreur", message: "Oops, merci de vérifiez votre réseau", preferredStyle: UIAlertControllerStyle.alert)
                    // add action Non
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Erreur", message: "Vous n'avez plus assez de crédit", preferredStyle: UIAlertControllerStyle.alert)
                // add action Non
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
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
