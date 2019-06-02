//
//  createMap.swift
//  mapApplication
//
//  Created by sundus on 18/09/1440 AH.
//  Copyright © 1440 sundus. All rights reserved.
//

import UIKit
import CoreLocation


class createMap: UIViewController, UITextFieldDelegate {
    
    var locationCoordinate: CLLocationCoordinate2D!
    var locationName: String!

   


    
    
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var findLocation: UIButton!
    @IBOutlet weak var inde: UIActivityIndicatorView!
    
    
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Urlinterface" {
            let vc = segue.destination as! shareVC
            vc.locationCoordinate = locationCoordinate
            vc.locationName = locationName

        }
    }

    
    @IBAction func cancel(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    
   
    

    
    @IBAction func findLoc(_ sender: UIButton) {
        inde.startAnimating()
        guard let locationName = locationText.text?.trimmingCharacters(in: .whitespaces), !locationName.isEmpty
            else {
                let alertController = UIAlertController(title: "Warning", message: "Must Write Location", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                alertController.addAction(okAction)
                self.present(alertController, animated: false, completion: nil)
                inde.stopAnimating()

                return
        }
        
        getCoordination(location: locationName) { (locationCoordinate, error) in
            if let error = error {
                let alertController = UIAlertController(title: "Warning", message: "Try diffrient Name", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                alertController.addAction(okAction)
                self.present(alertController, animated: false, completion: nil)
                self.inde.stopAnimating()
                return
            }
          
            self.locationCoordinate = locationCoordinate
            self.locationName = locationName
            self.inde.stopAnimating()
            self.performSegue(withIdentifier: "Urlinterface", sender: self)
            
    }
  
            }
    
    
     func getCoordination(location: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        
        CLGeocoder().geocodeAddressString(location) { placemarks, error in
            completion(placemarks?.first?.location?.coordinate, error)
        }
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
}
