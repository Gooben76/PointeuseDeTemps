//
//  DaysController.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 14/08/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class DaysController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var daysTableView: UITableView!
    
    var typicalDays = [TypicalDays]()
    var userConnected: Users?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.items![0].title = RSC_DAYS
        
        let usr = UserDefaults.standard.object(forKey: "connectedUser")
        if usr != nil, let login = usr as? String {
            if let user = UsersDataHelpers.getFunc.searchUserByLogin(login: login), user != nil {
                print("User OK  for day")
                userConnected = user
            }
        }
        
        if userConnected != nil {
            print("Ok for user \(userConnected!.login!)")
            
            if TypicalDaysDataHelpers.getFunc.setNewTypicalDay(typicalDayName: "Journée 2", userConnected: userConnected!) {
                print("Journée créée")
                
                if let allData = TypicalDaysDataHelpers.getFunc.getAllTypicalDays(userConnected: userConnected!) {
                    typicalDays = allData
                    print("nombre : \(typicalDays.count)")
                }
                
                if let elm = TypicalDaysDataHelpers.getFunc.searchTypicalDayByName(typicalDayName: "Journée 2", userConnected: userConnected!) {
                    print("Nom de journée 2 : \(elm.typicalDayName!)")
                }
            }
        }
        
    }

    @IBAction func addNavigationBarButton_Click(_ sender: Any) {
        
    }
    
}
