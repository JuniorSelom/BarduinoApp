//
//  QrCodeViewController.swift
//  BarduinoApp
//
//  Created by Francois Devove on 10.07.17.
//  Copyright © 2017 Selom Viadenou. All rights reserved.
//

import UIKit
import SwiftyJSON

class QrCodeViewController: UIViewController {
    
    var qrcodeImage: CIImage!
    var item: JSON?
    
    @IBOutlet weak var imgQrCode: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.item != nil) {
            GenerateQrCode(generateString: (self.item?["uuid"].stringValue)!)
            UIScreen.main.brightness = 1.0
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("TOTOTOTOTOOTOT")
        print("TOTOTOTOTOOTOT")
        print("TOTOTOTOTOOTOT")
        print("TOTOTOTOTOOTOT")
        print(AppDelegate().brightnessUser)
        UIScreen.main.brightness = AppDelegate().brightnessUser
    }
    override func viewDidDisappear(_ animated: Bool) {
        print(AppDelegate().brightnessUser)
        UIScreen.main.brightness = AppDelegate().brightnessUser
    }
    
    private func GenerateQrCode(generateString:String){
        if(qrcodeImage == nil){
            
            //let data = textField.text?.data(using: String.Encoding.isoLatin1, allowLossyConversion: false);
            let data = generateString.data(using: String.Encoding.isoLatin1,allowLossyConversion: false);
            let filter = CIFilter(name: "CIQRCodeGenerator");
            
            filter?.setValue(data, forKey: "inputMessage");
            filter?.setValue("Q", forKey: "inputCorrectionLevel");
            
            qrcodeImage = filter?.outputImage;
            
            // btnGenerate.setTitle("Commander", for: .normal);
            
            displayQRCodeImage();
            
            
        } else {
            imgQrCode.image = nil;
            qrcodeImage = nil;
            // btnGenerate.setTitle("Générer", for: .normal);
            let data = generateString.data(using: String.Encoding.isoLatin1,allowLossyConversion: false);
            let filter = CIFilter(name: "CIQRCodeGenerator");
            
            filter?.setValue(data, forKey: "inputMessage");
            filter?.setValue("Q", forKey: "inputCorrectionLevel");
            
            qrcodeImage = filter?.outputImage;
            
            // btnGenerate.setTitle("Commander", for: .normal);
            
            displayQRCodeImage();
            
            
        }
    }
    
    private func displayQRCodeImage(){
        
        let scaleX = imgQrCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imgQrCode.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY));
        imgQrCode.image = UIImage(ciImage: transformedImage)
        
    }

}
