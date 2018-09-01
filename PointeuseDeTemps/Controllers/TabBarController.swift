//
//  TabBarController.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 13/08/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parameters = ParametersController()
        parameters.title = "Profil"
        parameters.tabBarItem.image = #imageLiteral(resourceName: "user-30")
        
        let activities = ActivitiesController()
        activities.title = "Activités"
        activities.tabBarItem.image = #imageLiteral(resourceName: "activities-30")
        
        let days = DaysController()
        days.title = "Jours"
        days.tabBarItem.image = #imageLiteral(resourceName: "days-30")
        
        let timeScores = TimeScoresController()
        timeScores.title = "Pointage"
        timeScores.tabBarItem.image = #imageLiteral(resourceName: "times-30")
        
        let history = HistoryController()
        history.title = "Historique"
        history.tabBarItem.image = #imageLiteral(resourceName: "history-30")
        
        viewControllers = [activities, days, timeScores, history, parameters]
    }

    
}
