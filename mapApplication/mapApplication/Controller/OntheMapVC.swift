//
//  OntheMapVC.swift
//  mapApplication
//
//  Created by sundus on 21/08/1440 AH.
//  Copyright © 1440 sundus. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class OntheMapVC: UIViewController {
    
    var studentLocations: [StudentLoc]! {
        return Global.shared.studentLocations
    }
    
    @IBOutlet weak var Map: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (studentLocations == nil) {
            reloadStudentLoc(self)
        } else {
            
            DispatchQueue.main.async {
                self.updateAnnotation()
            }
        }
   
    }

    @IBAction func logOut(_ sender: Any) {
        
        Client.logOut { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func insetPin(_ sender: Any) {
        
        if UserDefaults.standard.value(forKey: "studentLocation") != nil {
            
            let Alert = UIAlertController(title: "Warning", message: "You have already posted, would you to Overwrite current location", preferredStyle: .alert)
            let OverwiteAction = UIAlertAction(title: "Overwite", style: .destructive, handler: { (action) in
                
                // will go to insert interface
                 self.performSegue(withIdentifier: "mapController", sender: self)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            Alert.addAction(OverwiteAction)
            Alert.addAction(cancelAction)
            
            self.present(Alert, animated: true, completion: nil)
            return
        } else {
            
            // Alreay in map interface
            self.performSegue(withIdentifier: "mapController", sender: self)
  
        }
    }
    
    
    @IBAction func reloadStudentLoc(_ sender: Any) {
        
        Client.pares.getLocation { (_,_, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
    
                DispatchQueue.main.async {
                    self.updateAnnotation()
                }
            }
        
    }
    
    func updateAnnotation() {
        
        var annatations = [MKPointAnnotation]()
        
        for studentLocation in studentLocations {
            
            let lat = CLLocationDegrees(studentLocation.latitude ?? 0 )
            let long = CLLocationDegrees(studentLocation.longitude ?? 0 )
            let coord = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let firstname = studentLocation.firstName ?? ""
            let lastname = studentLocation.lastName ?? ""
            let url = studentLocation.mediaURL ?? ""
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coord
            annotation.title = "\(firstname) \(lastname)"
            annotation.subtitle = url
            
            if !Map.annotations.contains(where: {$0.title == annotation.title}) {
            annatations.append(annotation)
            
            }
    }
        
        Map.addAnnotations(annatations)
        
    }
}
 
extension OntheMapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let result = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: result) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: result)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
        
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped countrol: UIControl) {
        
        if countrol == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            guard let open = view.annotation?.subtitle!, let url = URL(string: open) else {return }
            app.open(url, options: [:], completionHandler: nil)
        }
    }
    }
