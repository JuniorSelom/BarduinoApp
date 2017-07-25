//
//  HomeViewController.swift
//  BarduinoApp
//
//  Created by Francois Devove on 07.07.17.
//  Copyright © 2017 Selom Viadenou. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: UITableViewController {
    
    
    @IBOutlet weak var theTableView: UITableView!
    var tata  = ["tototo", "toto", "ovrobr"]
    var toto = String()
    let defaults = UserDefaults.standard
    var items: [JSON] = []
    var cocktail: [String: String] = [:];
    var indexSelected: Int = 0
    
    var load: Bool = true;
    var loading: [UIImage] = [UIImage(named: "loader0000.png")!, UIImage(named: "loader0001.png")!, UIImage(named: "loader0002.png")!, UIImage(named: "loader0003.png")!, UIImage(named: "loader0004.png")!, UIImage(named: "loader0005.png")!, UIImage(named: "loader0006.png")!, UIImage(named: "loader0007.png")!, UIImage(named: "loader0008.png")!, UIImage(named: "loader0009.png")!, UIImage(named: "loader0010.png")!, UIImage(named: "loader0011.png")!, UIImage(named: "loader0012.png")!, UIImage(named: "loader0013.png")!, UIImage(named: "loader0014.png")!, UIImage(named: "loader0015.png")!, UIImage(named: "loader0016.png")!, UIImage(named: "loader0017.png")!, UIImage(named: "loader0018.png")!, UIImage(named: "loader0019.png")!]
    var imageLoading:UIImage!
    var imageView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HomeViewController")
        theTableView.dataSource = self
        theTableView.delegate = self
        
        // print(toto)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        imageLoading = UIImage.animatedImage(with: loading, duration: 1)!
        imageView = UIImageView(image: imageLoading)
        
        if (load) {
            let x = (UIScreen.main.bounds.width / 2) - 45.0
            let y = (UIScreen.main.bounds.height / 2) - 45.0
            self.imageView.frame = CGRect(x: x, y: y, width: 90, height: 90)
            view.addSubview(self.imageView)
        }
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        items.removeAll()
        getCocktails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(items.count)
        return items.count
    }
    
    func getCocktails() {
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(String(describing: defaults.object(forKey: "token")))",
            "Accept": "application/json"
        ]

        Alamofire.request(config().apiUrl + "cocktails", method: .get, headers: headers).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            print("RESPONSE ???: \(String(describing: response.response?.statusCode.description))")
            if (response.response?.statusCode.description == "200") {
                self.load = false
                if let data = response.data/*, let utf8Text = String(data: data, encoding: .utf8)*/ {
                    // print("Data: \(utf8Text)")
                    let json = JSON(data: data)
                    print(json.count)
                    for cocktail in json.arrayValue {
                        // print(cocktail)
                        self.items.append(cocktail)
                        print(cocktail["name"])
                    }
                    self.imageView.removeFromSuperview()
                    self.theTableView.reloadData()
                }
            } else {
                self.imageView.removeFromSuperview()
                let alert = UIAlertController(title: "Erreur", message: "Merci de vérifiez votre réseau", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { action -> Void in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginControllerSegue") as! ViewController
                    self.present(vc, animated: true, completion: nil)
                })
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HomeTableViewCell = theTableView.dequeueReusableCell(withIdentifier: "cellHome", for: indexPath) as! HomeTableViewCell
        let element = self.items[indexPath.row]
        // let data = JSON(data: tt)
        print("NAME ?")
        print(element["name"].string!)
        // cell.textLabel?.text = "cell number \(indexPath.row)."
        cell.titleCocktail.text = element["name"].string
        cell.prixCocktail.text = element["prix"].stringValue + " crédits"

        var nameImage = element["name"].string! + ".png"
        print(nameImage)
        nameImage = nameImage.replacingOccurrences(of: " ", with: "_")
        cell.imageCocktail.image = UIImage(named: nameImage)
        // Configure the cell...

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        indexSelected = indexPath.row
        /*
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderSegue") as! OrderViewController
        vc.test = "ttttt"
        self.present(vc, animated: true, completion: nil)
        */
        // self.performSegue(withIdentifier: "OrderSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "OrderSegue") {
            let nextVC = segue.destination as! OrderViewController;
            // pass name of Clothes in next controller
            nextVC.test = "tototo"
            nextVC.item = self.items[self.indexSelected]
        } else if (segue.identifier == "ProfilSegue") {
            let nextVCProfil = segue.destination as! ProfilUserViewController;
            nextVCProfil.str = "id_user"
        }
    }
 
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
