//
//  shareVC.swift
//  mapApplication
//
//  Created by sundus on 18/09/1440 AH.
//  Copyright © 1440 sundus. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class shareVC: UIViewController, UITextFieldDelegate {
    
    var locationCoordinate: CLLocationCoordinate2D!
    var locationName: String!
   

    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var website: UITextField!
    @IBOutlet weak var indi: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate!
        map.addAnnotation(annotation)
        
        let viewRegion = MKCoordinateRegion(center: locationCoordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        map.setRegion(viewRegion, animated: false)
    }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func submit(_ sender: Any) {
        
    
        indi.startAnimating()
        let link = website.text ?? ""
        
        
        Client.pares.getUser { (firstName, lastName, error) in
            guard error == nil else {
                let alertController = UIAlertController(title: "Warning", message: error?.localizedDescription,
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                self.indi.stopAnimating()
                return
            }
            
                
                Client.pares.postLocation(firstName: firstName!, lastName: lastName!, link: link, locationCoordinate: self.locationCoordinate!, locationName: self.locationName) {
                    (errMessage, error ) in
                    
                    guard (error == nil) && (errMessage == nil) else {
                        
                        let alertController = UIAlertController(title: "Warning", message: error?.localizedDescription ?? errMessage,
                                                                preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                        self.indi.stopAnimating()
                        return
                        
                  
                   
                    }
                    
                    UserDefaults.standard.set(self.locationName, forKey: "studentLocation")
                    DispatchQueue.main.async {
                        self.parent!.dismiss(animated: true, completion: nil)
                    }
            
            
            
       
        }
 
    }
    



}
}
