//  APIUsers.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 03/11/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import Foundation

class APITimeScoreActivities {
    
    static let getFunc = APITimeScoreActivities()
    
    func getOneFromAPI(id: Int, token: String, completion: @escaping (TimeScoreActivityAPI?) -> ()) {
        let fullURL = url + "timescoreactivities/\(id)"
        let urlToGet = URL(string: fullURL)
        var model = [TimeScoreActivityAPI]()
        if urlToGet != nil {
            var request = URLRequest(url: urlToGet!)
            request.httpMethod = "GET"
            if token.count > 0 {
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
                
                if httpStatusCode < 400 {
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with:
                            dataResponse, options: [])
                        
                        if let jsonArray = jsonResponse as? [[String: Any]] {
                            for dic in jsonArray{
                                model.append(TimeScoreActivityAPI(dic))
                            }
                            completion(model[0])
                            return
                        } else {
                            if let jsonArray2 = jsonResponse as? [String: Any] {
                                model.append(TimeScoreActivityAPI(jsonArray2))
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
    
    func getAllFromAPI(userId: Int, token: String, completion: @escaping ([TimeScoreActivityAPI]?) -> ()) {
        let fullURL = url + "timescoreactivities/fromuserid/\(userId)"
        let urlToGet = URL(string: fullURL)
        var model = [TimeScoreActivityAPI]()
        if urlToGet != nil {
            var request = URLRequest(url: urlToGet!)
            request.httpMethod = "GET"
            if token.count > 0 {
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
                
                if httpStatusCode < 400 {
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with:
                            dataResponse, options: [])
                        
                        if let jsonArray = jsonResponse as? [[String: Any]] {
                            for dic in jsonArray{
                                model.append(TimeScoreActivityAPI(dic))
                            }
                            completion(model)
                            return
                        } else {
                            if let jsonArray2 = jsonResponse as? [String: Any] {
                                model.append(TimeScoreActivityAPI(jsonArray2))
                                completion(model)
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
    
    func updateToAPI(timeScoreActivityId: TimeScoreActivities, token: String, completion: @escaping (Int) -> ()) {
        let fullURL = url + "timescoreactivities/\(timeScoreActivityId.id)"
        let urlToGet = URL(string: fullURL)
        let modelToSend = TimeScoreActivityAPI(timeScoreActivityId: timeScoreActivityId)
        var jsonData: Data
        
        do {
            let jsonEncoder = JSONEncoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            jsonEncoder.dateEncodingStrategy = .formatted(dateFormatter)
            //jsonEncoder.dateEncodingStrategy = .iso8601
            jsonData = try jsonEncoder.encode(modelToSend)
        } catch let encodingError {
            print(encodingError.localizedDescription)
            return
        }
        
        if urlToGet != nil {
            var request = URLRequest(url: urlToGet!)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if token.count > 0 {
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
    
    func createToAPI(timeScoreActivityId: TimeScoreActivities, token: String, completion: @escaping (TimeScoreActivityAPI?) -> ()) {
        let fullURL = url + "timescoreactivities"
        let urlToGet = URL(string: fullURL)
        var model = [TimeScoreActivityAPI]()
        let modelToSend = TimeScoreActivityAPI(timeScoreActivityId: timeScoreActivityId)
        var jsonData: Data
        
        do {
            let jsonEncoder = JSONEncoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            jsonEncoder.dateEncodingStrategy = .formatted(dateFormatter)
            //jsonEncoder.dateEncodingStrategy = .iso8601
            jsonData = try jsonEncoder.encode(modelToSend)
        } catch let encodingError {
            print(encodingError.localizedDescription)
            return
        }
        
        if urlToGet != nil {
            var request = URLRequest(url: urlToGet!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if token.count > 0 {
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
                
                if httpStatusCode < 400 {
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with:
                            dataResponse, options: [])
                        
                        if let jsonArray = jsonResponse as? [[String: Any]] {
                            for dic in jsonArray{
                                model.append(TimeScoreActivityAPI(dic))
                            }
                            completion(model[0])
                            return
                        } else {
                            if let jsonArray2 = jsonResponse as? [String: Any] {
                                model.append(TimeScoreActivityAPI(jsonArray2))
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
    
    func deleteToAPI(id: Int32, token: String, completion: @escaping (Int) -> ()) {
        let fullURL = url + "timescoreactivities/\(id)"
        let urlToGet = URL(string: fullURL)
        
        if urlToGet != nil {
            var request = URLRequest(url: urlToGet!)
            request.httpMethod = "DELETE"
            if token.count > 0 {
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
