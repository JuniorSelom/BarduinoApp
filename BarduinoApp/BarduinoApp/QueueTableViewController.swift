//
//  QueueTableViewController.swift
//  BarduinoApp
//
//  Created by Francois Devove on 10.07.17.
//  Copyright © 2017 Selom Viadenou. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class QueueTableViewController: UITableViewController {

    @IBOutlet var theTableView: UITableView!

    var items: [JSON] = []
    var indexSelected: Int = 0
    let defaults = UserDefaults.standard
    var indexSel: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theTableView.dataSource = self
        theTableView.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // let date = Date()
        // let isoDate = "2017-07-04T09:09:17.891957Z"

        // let string = "2017-07-04T09:09:17.891957Z"
        /*
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        let date = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        */
        /*
        let str = string.ISO8601toString()
        print("------")
        print(str)
        print("------")
        */
        /*
        let tt = dateString.replacingOccurrences(of: " ", with: " à ")
        let tt2 = "Le " + tt
 
        print("____-____--_---_-")
        print("EXACT_DATE : \(dateString)")
        print(tt2)
        print("____-____--_---_-")
 */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        items.removeAll()
        getQueue()
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
        return items.count
    }
    
    func getQueue() {
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(String(describing: defaults.object(forKey: "token")!))",
            "Accept": "application/json"
        ]
        print(headers)
        print(defaults.object(forKey: "token")!)
        Alamofire.request(config().apiUrl + "getqueu", method: .get, headers: headers).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                // print("Data: \(utf8Text)")
                let json = JSON(data: data)
                print(json.count)
                for cocktail in json.arrayValue {
                    // print(cocktail)
                    self.items.append(cocktail)
                }
                self.theTableView.reloadData()
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:QueueTableViewCell = theTableView.dequeueReusableCell(withIdentifier: "cellQueue", for: indexPath) as! QueueTableViewCell
        let element = self.items[indexPath.row]
        print(element)
        print("-------")
        if (element["state"] == "0") {
            // disable element
            cell.contentView.alpha = 0.5
            cell.isUserInteractionEnabled = false
        }
        cell.drinkLabel.text = element["cocktail"]["name"].stringValue
        
        let dateOrder = element["date"]
            .stringValue
            .ISO8601toString()
            .replacingOccurrences(of: " ", with: " à ")
        cell.dateLabel.text = "Le " + dateOrder
        
        
        var nameImage = element["cocktail"]["name"].string! + ".png"
        nameImage = nameImage.replacingOccurrences(of: " ", with: "_")
        cell.cocktailImage.image = UIImage(named: nameImage)
        
        return cell
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "QrCodeSegue") {
            let nextVC = segue.destination as! QrCodeViewController;
            nextVC.item = self.items[self.indexSel]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexSel = indexPath.row
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
