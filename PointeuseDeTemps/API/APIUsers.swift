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
        let fullURL = url + "users/\(id)"
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
                                model.append(UserAPI(dic))
                                model[0].password = EncodeHelpers.getFunc.decrypte(key: model[0].password)
                            }
                            completion(model[0])
                            return
                        } else {
                            if let jsonArray2 = jsonResponse as? [String: Any] {
                                model.append(UserAPI(jsonArray2))
                                model[0].password = EncodeHelpers.getFunc.decrypte(key: model[0].password)
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
    
    func getUserFromLoginAndMail(login: String, mail: String, token: String, completion: @escaping (UserAPI?) -> ()) {
        let fullURL = url + "users/loginandmail/\(login)/\(mail)"
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
                                model.append(UserAPI(dic))
                                model[0].password = EncodeHelpers.getFunc.decrypte(key: model[0].password)
                            }
                            completion(model[0])
                            return
                        } else {
                            if let jsonArray2 = jsonResponse as? [String: Any] {
                                model.append(UserAPI(jsonArray2))
                                model[0].password = EncodeHelpers.getFunc.decrypte(key: model[0].password)
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
    
    func getUserFromLoginOrMailExists(login: String, mail: String, token: String, completion: @escaping (UserAPI?) -> ()) {
        let fullURL = url + "users/loginormailexists/\(login)/\(mail)"
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
                                model.append(UserAPI(dic))
                                model[0].password = EncodeHelpers.getFunc.decrypte(key: model[0].password)
                            }
                            completion(model[0])
                            return
                        } else {
                            if let jsonArray2 = jsonResponse as? [String: Any] {
                                model.append(UserAPI(jsonArray2))
                                model[0].password = EncodeHelpers.getFunc.decrypte(key: model[0].password)
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
    
    func updateUserToAPI(userId: Users, token: String, completion: @escaping (Int) -> ()) {
        let fullURL = url + "users/\(userId.id)"
        let urlToGet = URL(string: fullURL)
        var modelToSend = UserAPI(userId: userId)
        modelToSend.password = EncodeHelpers.getFunc.crypte(key: modelToSend.password)
        var jsonData: Data
        
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.dateEncodingStrategy = .iso8601
            jsonData = try jsonEncoder.encode(modelToSend)
        } catch let encodingError {
            print("Erreur d'encodage")
            print(encodingError.localizedDescription)
            return
        }
        
        if urlToGet != nil {
            var request = URLRequest(url: urlToGet!) //requestURL( (string: fullURL)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if token.count > 0 {
                //request.setValue("token=\"\(token)\"", forHTTPHeaderField: "Authorization")
                request.setValue(token, forHTTPHeaderField: "Authorization: Bearer")
            }
            
            request.httpBody = jsonData
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    completion(-110)
                    return
                }
                
                let httpStatus = response as? HTTPURLResponse
                let httpStatusCode:Int = (httpStatus?.statusCode)!
                
                completion(httpStatusCode)
                return
            }.resume()
        }
    }
    
    func createUserToAPI(userId: Users, token: String, completion: @escaping (UserAPI?) -> ()) {
        let fullURL = url + "users"
        let urlToGet = URL(string: fullURL)
        var model = [UserAPI]()
        var modelToSend = UserAPI(userId: userId)
        modelToSend.password = EncodeHelpers.getFunc.crypte(key: modelToSend.password)
        var jsonData: Data
        
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.dateEncodingStrategy = .iso8601
            jsonData = try jsonEncoder.encode(modelToSend)
        } catch let encodingError {
            print("Erreur d'encodage")
            print(encodingError.localizedDescription)
            return
        }
        
        if urlToGet != nil {
            var request = URLRequest(url: urlToGet!) //requestURL( (string: fullURL)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if token.count > 0 {
                //request.setValue("token=\"\(token)\"", forHTTPHeaderField: "Authorization")
                request.setValue(token, forHTTPHeaderField: "Authorization: Bearer")
            }
            
            request.httpBody = jsonData
            
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
                                model.append(UserAPI(dic))
                                model[0].password = EncodeHelpers.getFunc.decrypte(key: model[0].password)
                            }
                            completion(model[0])
                            return
                        } else {
                            if let jsonArray2 = jsonResponse as? [String: Any] {
                                model.append(UserAPI(jsonArray2))
                                model[0].password = EncodeHelpers.getFunc.decrypte(key: model[0].password)
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
    
    func deleteUserToAPI(userId: Int32, token: String, completion: @escaping (Int) -> ()) {
        let fullURL = url + "users/\(userId)"
        let urlToGet = URL(string: fullURL)
        
        if urlToGet != nil {
            var request = URLRequest(url: urlToGet!) //requestURL( (string: fullURL)
            request.httpMethod = "DELETE"
            if token.count > 0 {
                //request.setValue("token=\"\(token)\"", forHTTPHeaderField: "Authorization")
                request.setValue(token, forHTTPHeaderField: "Authorization: Bearer")
            }
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    completion(-110)
                    return
                }
                
                let httpStatus = response as? HTTPURLResponse
                let httpStatusCode:Int = (httpStatus?.statusCode)!
                
                completion(httpStatusCode)
                return
            }.resume()
        }
    }
}
