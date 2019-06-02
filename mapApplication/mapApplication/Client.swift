        //
        //  Client.swift
        //  mapApplication
        //
        //  Created by sundus on 23/08/1440 AH.
        //  Copyright © 1440 sundus. All rights reserved.
        //

        import UIKit
        import MapKit



        class Client: UIViewController {
            
          
            
            static var key = "456798776666"
             static func login(_ username: String!, _ password: String!, completion: @escaping(Bool, String, Error?)->()){
                
                var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = "{\"udacity\": {\"username\": \"\(username!)\", \"password\": \"\(password!)\"}}".data(using: .utf8)
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if error != nil {
                        completion(false, "", error)
                        return
                    }
                    guard let ststus = (response as? HTTPURLResponse)?.statusCode else {
                        let ststusError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                        completion(false, "", ststusError)
                        return
                    }
                    if ststus >= 200 && ststus < 300 {
                        
                        let newdata = data?[5..<data!.count]
                        
                        // OR
                        //let range = (5..<data!.count)
                        //let newdata = data?.subdata(in: range)

                        let loginObject = try! JSONSerialization.jsonObject(with: newdata!, options: [])
                        let loginDec = loginObject as? [String: Any]
                        let accountDec = loginDec?["account"] as? [String: Any]
                        let uniq = accountDec? ["key"] as? String ?? "456798776666"
                        Client.key = uniq
                        completion(true, uniq, nil)
                        
                    } else {
                        var errorMsg = " "
                        switch errorMsg {
                        case "400":
                            errorMsg = "BadRequest"
                        case "401":
                            errorMsg = "Invalid Credentials"
                        case "403":
                            errorMsg = "Unauthorized"
                        case "405":
                            errorMsg = "HttpMethod Not Allowed"
                        case "410":
                            errorMsg = " URL Changed"
                        case "500":
                            errorMsg = " Server Error"
                        default:
                            errorMsg = "Try Again"
                        }
                          completion(false, errorMsg , nil)
                  
                    }
                }
                
                task.resume()
         
            }
            
            static func logOut(completion: @escaping (Error?)->()){

                var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
                
                request.httpMethod = "DELETE"
                var xsrfCookie:HTTPCookie? = nil
                let sharedcookie = HTTPCookieStorage.shared
                
                for cookie in sharedcookie.cookies! {
                    if cookie.name == "XSRF-TOKEN" {(xsrfCookie = cookie)}
                }
                
                if let xsrfCookie = xsrfCookie{
                    request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
                }
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    
                    if error != nil {
                        completion(error)
                        return
                }
                    let newdata = data?[5..<data!.count]
                    completion(nil)
                    
                }
                
                task.resume()
            }
            
         
            
            
            
            class pares: UIViewController {
                
                
                
                static func getUser( completion: @escaping(String?, String?,Error?) -> ()) {
                    
                    let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(Client.key)")!)
                    
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        if error != nil {
                            completion(nil, nil, error)
                            return
                        }
                        
                        let range = 5..<data!.count
                        let newdata = data?.subdata(in: range)
                        
                        print(String(data: data!, encoding: .utf8)!)
                        
                        let dictionary = try! JSONSerialization.jsonObject(with: newdata!, options: []) as![String:Any]
                        
                        /**
                         I noticed to types of data
                         */
                        var firstName: String?
                        var lastName: String?
                        
                        if let user = dictionary ["user"] as? [String:Any] {
                            firstName = user["first_name"] as? String ?? ""
                            lastName = user["last_name"] as? String ?? ""
                            
                        } else {
                            firstName = dictionary["first_name"] as? String ?? ""
                            lastName = dictionary["last_name"] as? String ?? ""
                        }
                        
                        completion(firstName, lastName, nil)
                    }
                    task.resume()
                    
                }
                
                static func postLocation(firstName: String, lastName: String, link: String, locationCoordinate: CLLocationCoordinate2D, locationName: String, completion: @escaping(String?, Error?) -> ()) {
                    
                    var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
                    request.httpMethod = "POST"
                    request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
                    request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
                    request.addValue("application/json", forHTTPHeaderField: "Content-type")
                    request.httpBody = "{\"uniqueKey\": \"\(Client.key)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(locationName)\", \"mediaURL\": \"\(link)\",\"latitude\": \(locationCoordinate.latitude), \"longitude\": \(locationCoordinate.longitude)}".data(using: .utf8)
                    
                    
                    let sesstion = URLSession.shared
                    let task = sesstion.dataTask(with: request) { data, response, error in
                        if error != nil{
                            completion(nil, error)
                            return
                        }
                        
                        guard let ststus = (response as? HTTPURLResponse)?.statusCode else {
                            let ststusError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                            completion(nil, ststusError)
                            return
                        }
                        
                        if ststus >= 200 && ststus < 300 {
                            completion(nil, nil)
                            
                        } else {
                            
                            var errorMsg = " "
                            switch errorMsg {
                            case "400":
                                errorMsg = "BadRequest"
                            case "401":
                                errorMsg = "Invalid Credentials"
                            case "403":
                                errorMsg = "Unauthorized"
                            case "405":
                                errorMsg = "HttpMethod Not Allowed"
                            case "410":
                                errorMsg = " URL Changed"
                            case "500":
                                errorMsg = " Server Error"
                            default:
                                errorMsg = "Try Again"
                            }
                            
                            completion(errorMsg, nil)
                        }
                    }
                    task.resume()
                }
                
                //StudentLoc (Swift page)
                static func getLocation( completion: @escaping([StudentLoc]?, String, Error?)->()) {
                    var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt")!)
                    request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
                    request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
                    let task = URLSession.shared.dataTask(with: request) {data, response, error in
                        if error != nil {
                            completion (nil, " ", error)
                            return
                        }

                        guard let ststus = (response as? HTTPURLResponse)?.statusCode else {
                            
                            let ststusError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                            completion(nil, " ", ststusError)
                            return
                        }
                        
                        if ststus >= 200 && ststus < 300 {
                            let jsonObj = try! JSONSerialization.jsonObject(with: data!, options: [])
                            
                            guard let jsonDic = jsonObj as? [String: Any] else {
                                return
                            }
                            let result = jsonDic["results"] as? [[String: Any]]
                            guard let array = result else {
                                return
                            }
                            let dataObject = try! JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
                            let studentLoc = try! JSONDecoder().decode([StudentLoc].self, from: dataObject)
                            Global.shared.studentLocations = studentLoc
                            
                            completion(studentLoc, "", nil)
                            
                        } else {
                            
                            var errorMsg = " "
                            switch errorMsg {
                            case "400":
                                errorMsg = "BadRequest"
                            case "401":
                                errorMsg = "Invalid Credentials"
                            case "403":
                                errorMsg = "Unauthorized"
                            case "405":
                                errorMsg = "HttpMethod Not Allowed"
                            case "410":
                                errorMsg = " URL Changed"
                            case "500":
                                errorMsg = " Server Error"
                            default:
                                errorMsg = "Try Again"
                                }
                            
                            completion(nil, errorMsg , nil)
                                
                            }
                    }
                    
                    task.resume()
                }
            }
        }
            
  
        
        
        
        
        
        
        
        
        

