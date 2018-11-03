//
//  APIConnection.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 28/10/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import Foundation

class APIConnection {
    
    static let getFunc = APIConnection()
    
    func getToken(login: String, mail: String, password: String, completion: @escaping (Token) -> ()) {
        let fullURL = url + "token/" + login + "/" + mail + "/" + EncodeHelpers.getFunc.crypte(key: password)
        let urlToGet = URL(string: fullURL)
        var model = [ResponseToken]()
        if urlToGet != nil {
            let session = URLSession.shared
            session.dataTask(with: urlToGet!) { (data, response, error) in
                guard let dataResponse = data, error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    completion(Token(token: "", id: -110))
                    return
                }
                
                let httpStatus = response as? HTTPURLResponse
                let httpStatusCode:Int = (httpStatus?.statusCode)!
                
                if httpStatusCode < 400 {
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with:
                            dataResponse, options: [])
                        
                        if let jsonArray = jsonResponse as? [[String: Any]] {
                            for dic in jsonArray{
                                model.append(ResponseToken(dic)) // adding now value in Model array
                                completion(Token(token: model[0].token, id: model[0].id))
                                return
                            }
                        } else {
                            if let jsonArray2 = jsonResponse as? [String: Any] {
                                model.append(ResponseToken(jsonArray2))
                                completion(Token(token: model[0].token, id: model[0].id))
                                return
                            } else {
                                completion(Token(token: "", id: -130))
                                return
                            }
                        }
                    } catch let parsingError {
                        print("Error", parsingError)
                        completion(Token(token: "", id: -120))
                    }
                } else {
                    completion(Token(token: "", id: -100))
                    return
                }
            }.resume()
        }
    }
    
    func createUserAndGetToken(login: String, mail: String, password: String, completion: @escaping (Token) -> ()) {
        let fullURL = url + "token/newuser/" + login + "/" + mail + "/" + EncodeHelpers.getFunc.crypte(key: password) + "/admin/" + EncodeHelpers.getFunc.crypte(key: "@123_benGoo")
        let urlToGet = URL(string: fullURL)
        var model = [ResponseToken]()
        if urlToGet != nil {
            let session = URLSession.shared
            session.dataTask(with: urlToGet!) { (data, response, error) in
                guard let dataResponse = data,
                    error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        completion(Token(token: "", id: -110))
                        return
                }
                
                let httpStatus = response as? HTTPURLResponse
                let httpStatusCode:Int = (httpStatus?.statusCode)!
                
                if httpStatusCode < 400 {
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with:
                            dataResponse, options: [])
                        
                        if let jsonArray = jsonResponse as? [[String: Any]] {
                            for dic in jsonArray{
                                model.append(ResponseToken(dic))
                                completion(Token(token: model[0].token, id: model[0].id))
                                return
                            }
                        } else {
                            if let jsonArray2 = jsonResponse as? [String: Any] {
                                model.append(ResponseToken(jsonArray2))
                                completion(Token(token: model[0].token, id: model[0].id))
                                return
                            } else {
                                completion(Token(token: "", id: -130))
                                return
                            }
                        }
                    } catch let parsingError {
                        print("Error", parsingError)
                        completion(Token(token: "", id: -120))
                    }
                } else {
                    completion(Token(token: "", id: -100))
                    return
                }
            }.resume()
        }
    }
}
