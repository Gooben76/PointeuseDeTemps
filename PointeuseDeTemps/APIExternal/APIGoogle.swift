//
//  APIGoogle.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 10/11/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import Foundation

class APIGoogle {
    
    static let getFunc = APIGoogle()
    
    func getPlaceFromLatitudeAndLongitude(latitude: Double!, longitude: Double!, completion: @escaping (String?) -> ()) {
        let fullURL = urlAPIGeocoding + "json?latlng=\(latitude.roundToDecimal(6)),\(longitude!.roundToDecimal(6))&key=" + googleAPIKey
        print(fullURL)
        let urlToGet = URL(string: fullURL)
        if urlToGet != nil {
            var request = URLRequest(url: urlToGet!)
            request.httpMethod = "GET"
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                guard let dataResponse = data, error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    completion(nil)
                    return
                }
                let httpStatus = response as? HTTPURLResponse
                let httpStatusCode:Int = (httpStatus?.statusCode)!
                if httpStatusCode < 400 {
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with:
                            dataResponse, options: [])
                        
                        if let jsonArray = jsonResponse as? [String: AnyObject] {
                            print(jsonArray["status"]!)
                            if let status = jsonArray["status"] as? String, status == "OK" {
                                if let results = jsonArray["results"] as? [AnyObject] {
                                    for item in results {
                                        if let elm = item as? [String: AnyObject] {
                                            if let address = elm["formatted_address"] as? String {
                                                if let dataType = elm["geometry"] as? [String: AnyObject] {
                                                    if let locationType = dataType["location_type"] as? String {
                                                        //print(locationType + " : " + address)
                                                        if locationType == "APPROXIMATE" {
                                                            completion(address)
                                                            return
                                                        }
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        } else {
                            completion(nil)
                            return
                        }
                    } catch let parsingError {
                        print("Error", parsingError)
                        completion(nil)
                    }
                } else {
                    completion(nil)
                    return
                }
            }.resume()
        }
    }
}
