//
//  listVC.swift
//  mapApplication
//
//  Created by sundus on 17/09/1440 AH.
//  Copyright © 1440 sundus. All rights reserved.
//

import Foundation
import UIKit



class listVC: UITableViewController {
    
    let CellId = "listVC"
    
    var studentLocations : [StudentLoc]! {
        return Global.shared.studentLocations
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (studentLocations == nil){
            reloadStudentLoc(self)
        } else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellId)
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
        
        Client.pares.getLocation() { (_, _ , error)  in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations?.count ?? 0

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId, for: indexPath)
        cell.imageView?.image = UIImage(named: "pin")
        cell.textLabel?.text = studentLocations[indexPath.row].firstName
        cell.detailTextLabel?.text = studentLocations[indexPath.row].mediaURL
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = studentLocations[indexPath.row]
        guard let open = studentLocation.mediaURL, let url = URL(string: open) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
     
    }
    
  
    
}
