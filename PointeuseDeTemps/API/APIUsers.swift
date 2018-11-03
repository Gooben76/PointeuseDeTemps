//
//  APIUsers.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 03/11/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import Foundation

class APIUsers {
    
    static let getFunc = APIUsers()
    
    func getUserFromId(id: Int, token: String, completion: @escaping (UserAPI?) -> ()) {
        let fullURL = url + "users"
        let urlToGet = URL(string: fullURL)
        var model = [UserAPI]()
        if urlToGet != nil {
            var request = URLRequest(url: urlToGet!) //requestURL( (string: fullURL)
            request.httpMethod = "GET"
            if token.count > 0 {
                //request.setValue("token=\"\(token)\"", forHTTPHeaderField: "Authorization")
                request.setValue(token, forHTTPHeaderField: "Authorization: Bearer")
            }
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                guard let dataResponse = data, error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    completion(nil)
                    return
                }
                
                let httpStatus = response as? HTTPURLResponse
                let httpStatusCode:Int = (httpStatus?.statusCode)!
                print("Statut : \(httpStatusCode)")
                
                if httpStatusCode < 400 {
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with:
                            dataResponse, options: [])
                        
                        if let jsonArray = jsonResponse as? [[String: Any]] {
                            for dic in jsonArray{
                                model.append(UserAPI(dic)) // adding now value in Model array
                                completion(model[0])
                                return
                            }
                        } else {
                            if let jsonArray2 = jsonResponse as? [String: Any] {
                                model.append(UserAPI(jsonArray2))
                                completion(model[0])
                                return
                            } else {
                                completion(nil)
                                return
                            }
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
