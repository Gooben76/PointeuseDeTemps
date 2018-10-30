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
    
    let url = "http://timescore.benoitg.net/api/"
    
    func getToken(login: String, password: String) {
        let fullURL = url + "users/exists/" + login
        let urlToGet = URL(string: fullURL)
        if urlToGet != nil {
            let session = URLSession.shared
            session.dataTask(with: urlToGet!) { (data, response, error) in
                guard data != nil else {return}
                do {
                    let data2 = try String(data![0])
                    DispatchQueue.main.async {
                        self.printData(data: data2)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }.resume()
        }
    }
    
    func printData(data: String) {
        print(data)
    }
}
