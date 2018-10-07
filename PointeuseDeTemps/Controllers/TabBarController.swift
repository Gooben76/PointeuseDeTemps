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
        
        let parameters = UINavigationController(rootViewController: ParametersController())
        parameters.title = RSC_USER
        parameters.tabBarItem.image = #imageLiteral(resourceName: "user-30")
        
        let activities = UINavigationController(rootViewController: ActivitiesController())
        activities.title = RSC_ACTIVITIES
        activities.tabBarItem.image = #imageLiteral(resourceName: "activities-30")
        
        let days = UINavigationController(rootViewController: DaysController())
        days.title = RSC_DAYS
        days.tabBarItem.image = #imageLiteral(resourceName: "days-30")
        
        let timeScores = UINavigationController(rootViewController: TimeScoresController())
        timeScores.title = RSC_TIMESCORE
        timeScores.tabBarItem.image = #imageLiteral(resourceName: "times-30")
        
        let history = UINavigationController(rootViewController:HistoryController())
        history.title = RSC_HISTORY
        history.tabBarItem.image = #imageLiteral(resourceName: "history-30")
        
        viewControllers = [activities, days, timeScores, history, parameters]
        
        selectedViewController = timeScores
    }

    
}
