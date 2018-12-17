//
//  Synchronization.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 17/11/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import Foundation

class Synchronization {
    
    static let getFunc = Synchronization()
    
    func startTimers(userConnected: Users) {
        if userConnected.synchronization && userConnected.allowMessages {
            timerMessages = Timer(timeInterval: timerMessagesInterval, target: self, selector: #selector(updateMessages), userInfo: ["userConnected": userConnected], repeats: true)
            timerUsersUpdate = Timer(timeInterval: timerUsersUpdateInterval, target: self, selector: #selector(updateUsers), userInfo: ["userConnected": userConnected], repeats: true)
            
            let mainLoop = RunLoop.main
            mainLoop.add(timerMessages!, forMode: .defaultRunLoopMode)
            mainLoop.add(timerUsersUpdate!, forMode: .defaultRunLoopMode)
        }
    }
    
    @objc func updateMessages() {
        if let userInfo = timerMessages!.userInfo as? Dictionary<String, AnyObject> {
            if let userConnected = userInfo["userConnected"] as? Users {
                messagesSynchronization(userConnected: userConnected)
            }
        }
    }
    
    @objc func updateUsers() {
        if let userInfo = timerMessages!.userInfo as? Dictionary<String, AnyObject> {
            if let userConnected = userInfo["userConnected"] as? Users {
                updateUsersSynchronization(userConnected: userConnected)
            }
        }
    }
    
    func getUsersForMessages(userConnected: Users) {
        usersForMessages.removeAll()
        APIUsers.getFunc.getAllFriendsFromAPI(userId: Int(userConnected.id), token: "", completion: { (allData) in
            if allData != nil {
                usersForMessages = allData!
            }
        })
    }
    
    func userSynchronization(userConnected: Users!, completion: @escaping (String) -> ()) {
        if userConnected.synchronization {
            if userConnected.id == 0 {
                //si utilisateur n'existe pas sur le serveur, on le crée
                APIUsers.getFunc.createUserToAPI(userId: userConnected, token: "") { (data) in
                    if data != nil {
                        userConnected.id = Int32(data!.id)
                        if !UsersDataHelpers.getFunc.setUser(user: userConnected, withoutSynchronization: true) {
                            //
                        }
                    }
                }
            } else {
                APIUsers.getFunc.getUserFromId(id: Int(userConnected.id), token: "") { (data) in
                    if data != nil {
                        // si l'utilisateur existe sur le serveur, on vérifie que le login et le mail sont bien uniques
                        if data!.login == userConnected.login && data!.mail == userConnected.mail {
                            // on synchronise les données de l'utilisateur
                            if data!.modifiedDate < userConnected.modifiedDate! {
                                APIUsers.getFunc.updateUserToAPI(userId: userConnected, token: "", completion: { (httpCode) in
                                    //
                                })
                            } else if data!.modifiedDate > userConnected.modifiedDate! {
                                userConnected.password = data!.password
                                userConnected.allowMessages = data!.allowMessages
                                userConnected.firstName = data!.firstName
                                userConnected.lastName = data!.lastName
                                if !UsersDataHelpers.getFunc.setUser(user: userConnected, withoutSynchronization: true) {
                                    //
                                }
                            }
                        } else {
                            // si il n'y a pas de cohérence entre l'id et la login et mail de l'utilisateur, on vérifie si le login et le mail existe déjà et si oui on change d'id mobile
                            APIUsers.getFunc.getUserFromLoginAndMail(login: userConnected.login!, mail: userConnected.password!, token: "", completion: { (data) in
                                if data != nil {
                                    userConnected.id = Int32(data!.id)
                                    if !UsersDataHelpers.getFunc.setUser(user: userConnected, withoutSynchronization: true) {
                                        //
                                    }
                                } else {
                                    // si le login et le mail n'existe pas, on crée un nouvel utilisateur
                                    APIUsers.getFunc.createUserToAPI(userId: userConnected, token: "") { (data) in
                                        if data != nil {
                                            userConnected.id = Int32(data!.id)
                                            if !UsersDataHelpers.getFunc.setUser(user: userConnected, withoutSynchronization: true) {
                                                //
                                            }
                                        }
                                    }
                                }
                            })
                        }
                        completion(userConnected.password!)
                        return
                    } else {
                        completion("")
                        return
                    }
                }
            }
        } else {
            completion(userConnected.password!)
            return
        }
    }
    
    func generalSynchronization(userConnected: Users!) {
        if userConnected.synchronization {
            messagesSynchronization(userConnected: userConnected)
            
            activitiesSynchronization(userConnected: userConnected)
            typicalDaysSynchronization(userConnected: userConnected)
            typicalDayActivitiesSynchronization(userConnected: userConnected)
            timeScoresSynchronization(userConnected: userConnected)
            timeScoreActivitiesSynchronization(userConnected: userConnected)
            timeScoreActivityDetailsSynchronization(userConnected: userConnected)
            
            startTimers(userConnected: userConnected)
        }
    }
    
    func activitiesSynchronization(userConnected: Users!) {
        APIActivities.getFunc.getAllFromAPI(userId: Int(userConnected.id), token: "") { (dataAPIs) in
            if dataAPIs != nil {
                //Création dans données dans la base portable à partir du serveur
                for dataAPI in dataAPIs!{
                    var search: Activities? = ActivitiesDataHelpers.getFunc.searchActivityById(id: dataAPI.id, userConnected: userConnected)
                    if search == nil {
                        search = ActivitiesDataHelpers.getFunc.searchActivityByName(activityName: dataAPI.activityName, userConnected: userConnected)
                        if search == nil  {
                            if !ActivitiesDataHelpers.getFunc.setNewActivityFromActivityAPI(activityAPI: dataAPI, userConnected: userConnected) {
                                //
                            }
                        } else {
                            search!.id = Int32(dataAPI.id)
                            if search!.modifiedDate! < dataAPI.modifiedDate {
                                search!.order = Int32(dataAPI.order)
                                search!.gpsPosition = dataAPI.gpsPosition
                                search!.modifiedDate = dataAPI.modifiedDate
                                if !ActivitiesDataHelpers.getFunc.setActivity(activity: search, userConnected: userConnected, withoutSynchronization: true) {
                                    //
                                }
                            } else if search!.modifiedDate! > dataAPI.modifiedDate {
                                if !ActivitiesDataHelpers.getFunc.setActivity(activity: search, userConnected: userConnected, withoutSynchronization: true) {
                                    //
                                }
                                APIActivities.getFunc.updateToAPI(activityId: search!, token: "", completion: { (httpCode) in
                                    //
                                })
                            }
                        }
                    } else {
                        if search!.modifiedDate! < dataAPI.modifiedDate {
                            search!.order = Int32(dataAPI.order)
                            search!.gpsPosition = dataAPI.gpsPosition
                            search!.modifiedDate = dataAPI.modifiedDate
                            if !ActivitiesDataHelpers.getFunc.setActivity(activity: search, userConnected: userConnected, withoutSynchronization: true) {
                                //
                            }
                        } else if search!.modifiedDate! > dataAPI.modifiedDate {
                            if !ActivitiesDataHelpers.getFunc.setActivity(activity: search, userConnected: userConnected, withoutSynchronization: true) {
                                //
                            }
                            APIActivities.getFunc.updateToAPI(activityId: search!, token: "", completion: { (httpCode) in
                                //
                            })
                        }
                    }
                }
                
                //Création des données sur le serveur à partir de la base portable
                let datas = ActivitiesDataHelpers.getFunc.getAllActivities(userConnected: userConnected)
                if datas != nil {
                    for data in datas! {
                        if data.id == 0 {
                            APIActivities.getFunc.createToAPI(activityId: data, token: "", completion: { (newData) in
                                if newData != nil {
                                    data.id = Int32(newData!.id)
                                    if !ActivitiesDataHelpers.getFunc.setActivity(activity: data, userConnected: userConnected, withoutSynchronization: true) {
                                        //
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    func typicalDaysSynchronization(userConnected: Users!) {
        APITypicalDays.getFunc.getAllFromAPI(userId: Int(userConnected.id), token: "") { (dataAPIs) in
            if dataAPIs != nil {
                //Création dans données dans la base portable à partir du serveur
                for dataAPI in dataAPIs!{
                    var search: TypicalDays? = TypicalDaysDataHelpers.getFunc.searchTypicalDayById(id: dataAPI.id, userConnected: userConnected)
                    if search == nil {
                        search = TypicalDaysDataHelpers.getFunc.searchTypicalDayByName(typicalDayName: dataAPI.typicalDayName, userConnected: userConnected)
                        if search == nil  {
                            if !TypicalDaysDataHelpers.getFunc.setNewTypicalDayFromTypicalDayAPI(typicalDayAPI: dataAPI, userConnected: userConnected) {
                                //
                            }
                        } else {
                            search!.id = Int32(dataAPI.id)
                            if search!.modifiedDate! < dataAPI.modifiedDate {
                                search!.modifiedDate = dataAPI.modifiedDate
                                if !TypicalDaysDataHelpers.getFunc.setTypicalDay(typicalDay: search, userConnected: userConnected, withoutSynchronization: true) {
                                    //
                                }
                            } else if search!.modifiedDate! > dataAPI.modifiedDate {
                                if !TypicalDaysDataHelpers.getFunc.setTypicalDay(typicalDay: search, userConnected: userConnected, withoutSynchronization: true) {
                                    //
                                }
                                APITypicalDays.getFunc.updateToAPI(typicalDayId: search!, token: "", completion: { (httpCode) in
                                    //
                                })
                            }
                        }
                    } else {
                        if search!.modifiedDate! < dataAPI.modifiedDate {
                            search!.modifiedDate = dataAPI.modifiedDate
                            if !TypicalDaysDataHelpers.getFunc.setTypicalDay(typicalDay: search, userConnected: userConnected, withoutSynchronization: true) {
                                //
                            }
                        } else if search!.modifiedDate! > dataAPI.modifiedDate {
                            if !TypicalDaysDataHelpers.getFunc.setTypicalDay(typicalDay: search, userConnected: userConnected, withoutSynchronization: true) {
                                //
                            }
                            APITypicalDays.getFunc.updateToAPI(typicalDayId: search!, token: "", completion: { (httpCode) in
                                //
                            })
                        }
                    }
                }
                
                //Création des données sur le serveur à partir de la base portable
                let datas = TypicalDaysDataHelpers.getFunc.getAllTypicalDays(userConnected: userConnected)
                if datas != nil {
                    for data in datas! {
                        if data.id == 0 {
                            APITypicalDays.getFunc.createToAPI(typicalDayId: data, token: "", completion: { (newData) in
                                if newData != nil {
                                    data.id = Int32(newData!.id)
                                    if !TypicalDaysDataHelpers.getFunc.setTypicalDay(typicalDay: data, userConnected: userConnected, withoutSynchronization: true) {
                                        //
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    func typicalDayActivitiesSynchronization(userConnected: Users!) {
        APITypicalDayActivities.getFunc.getAllFromAPI(userId: Int(userConnected.id), token: "") { (dataAPIs) in
            if dataAPIs != nil {
                //Création dans données dans la base portable à partir du serveur
                for dataAPI in dataAPIs!{
                    var search: TypicalDayActivities? = TypicalDayActivitiesDataHelpers.getFunc.searchTypicalDayActivityById(id: dataAPI.id, userConnected: userConnected)
                    if search == nil {
                        let typicalDay = TypicalDaysDataHelpers.getFunc.searchTypicalDayById(id: dataAPI.typicalDayId, userConnected: userConnected)
                        let activity = ActivitiesDataHelpers.getFunc.searchActivityById(id: dataAPI.activityId, userConnected: userConnected)
                        if typicalDay != nil && activity != nil {
                            search = TypicalDayActivitiesDataHelpers.getFunc.searchTypicalDayActivityByTypicalDayAndActivity(typicalDay: typicalDay!, activity: activity!, userConnected: userConnected)
                        } else {
                            search = nil
                        }
                        if search == nil  {
                            if !TypicalDayActivitiesDataHelpers.getFunc.setNewTypicalDayActivityFromTypicalDayActivityAPI(typicalDayActivityAPI: dataAPI, userConnected: userConnected) {
                                //
                            }
                        } else {
                            search!.id = Int32(dataAPI.id)
                            if search!.modifiedDate! < dataAPI.modifiedDate {
                                search!.modifiedDate = dataAPI.modifiedDate
                                if !TypicalDayActivitiesDataHelpers.getFunc.setTypicalDayActivity(typicalDay: search!.typicalDayId, activity: search!.activityId, userConnected: userConnected, withoutSynchronization: true) {
                                    //
                                }
                            } else if search!.modifiedDate! > dataAPI.modifiedDate {
                                if !TypicalDayActivitiesDataHelpers.getFunc.setTypicalDayActivity(typicalDay: search!.typicalDayId, activity: search!.activityId, userConnected: userConnected, withoutSynchronization: true) {
                                    //
                                }
                                APITypicalDayActivities.getFunc.updateToAPI(typicalDayAvtivityId: search!, token: "", completion: { (httpCode) in
                                    //
                                })
                            }
                        }
                    } else {
                        if search!.modifiedDate! < dataAPI.modifiedDate {
                            search!.modifiedDate = dataAPI.modifiedDate
                           if !TypicalDayActivitiesDataHelpers.getFunc.setTypicalDayActivity(typicalDay: search!.typicalDayId, activity: search!.activityId, userConnected: userConnected, withoutSynchronization: true) {
                                //
                            }
                        } else if search!.modifiedDate! > dataAPI.modifiedDate {
                            if !TypicalDayActivitiesDataHelpers.getFunc.setTypicalDayActivity(typicalDay: search!.typicalDayId, activity: search!.activityId, userConnected: userConnected, withoutSynchronization: true) {
                                //
                            }
                            APITypicalDayActivities.getFunc.updateToAPI(typicalDayAvtivityId: search!, token: "", completion: { (httpCode) in
                                //
                            })
                        }
                    }
                }
                
                //Création des données sur le serveur à partir de la base portable
                let datas = TypicalDayActivitiesDataHelpers.getFunc.getAllTypicalDayActivities(userConnected: userConnected)
                if datas != nil {
                    for data in datas! {
                        if data.id == 0 {
                            APITypicalDayActivities.getFunc.createToAPI(typicalDayAvtivityId: data, token: "", completion: { (newData) in
                                if newData != nil {
                                    data.id = Int32(newData!.id)
                                    if !TypicalDayActivitiesDataHelpers.getFunc.setTypicalDayActivity(typicalDay: data.typicalDayId, activity: data.activityId, userConnected: userConnected, withoutSynchronization: true) {
                                        //
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    func timeScoresSynchronization(userConnected: Users!) {
        APITimeScores.getFunc.getAllFromAPI(userId: Int(userConnected.id), token: "") { (dataAPIs) in
            if dataAPIs != nil {
                //Création dans données dans la base portable à partir du serveur
                for dataAPI in dataAPIs!{
                    var search: TimeScores? = TimeScoresDataHelpers.getFunc.searchTimeScoreById(id: dataAPI.id, userConnected: userConnected)
                    if search == nil {
                        search = TimeScoresDataHelpers.getFunc.searchTimeScoreByDate(date: dataAPI.date
                            , userConnected: userConnected)
                        if search == nil  {
                            if !TimeScoresDataHelpers.getFunc.setNewTimeScoreFromTimeScoreAPI(timeScoreAPI: dataAPI, userConnected: userConnected) {
                                //
                            }
                        } else {
                            search!.id = Int32(dataAPI.id)
                            if search!.modifiedDate! < dataAPI.modifiedDate {
                                search!.typicalDayId = TypicalDaysDataHelpers.getFunc.searchTypicalDayById(id: dataAPI.typicalDayId!, userConnected: userConnected)
                                search!.modifiedDate = dataAPI.modifiedDate
                                if !TimeScoresDataHelpers.getFunc.setTimeScore(timeScore: search, userConnected: userConnected, withoutSynchronization: true) {
                                    //
                                }
                            } else if search!.modifiedDate! > dataAPI.modifiedDate {
                                if !TimeScoresDataHelpers.getFunc.setTimeScore(timeScore: search, userConnected: userConnected, withoutSynchronization: true) {
                                    //
                                }
                                APITimeScores.getFunc.updateToAPI(timeScoreId: search!, token: "", completion: { (httpCode) in
                                    //
                                })
                            }
                        }
                    } else {
                        if search!.modifiedDate! < dataAPI.modifiedDate {
                            search!.typicalDayId = TypicalDaysDataHelpers.getFunc.searchTypicalDayById(id: dataAPI.typicalDayId!, userConnected: userConnected)
                            search!.modifiedDate = dataAPI.modifiedDate
                            if !TimeScoresDataHelpers.getFunc.setTimeScore(timeScore: search, userConnected: userConnected, withoutSynchronization: true) {
                                //
                            }
                        } else if search!.modifiedDate! > dataAPI.modifiedDate {
                            if !TimeScoresDataHelpers.getFunc.setTimeScore(timeScore: search, userConnected: userConnected, withoutSynchronization: true) {
                                //
                            }
                            APITimeScores.getFunc.updateToAPI(timeScoreId: search!, token: "", completion: { (httpCode) in
                                //
                            })
                        }
                    }
                }
                
                //Création des données sur le serveur à partir de la base portable
                let datas = TimeScoresDataHelpers.getFunc.getAllTimeScores(userConnected: userConnected)
                if datas != nil {
                    for data in datas! {
                        if data.id == 0 {
                            APITimeScores.getFunc.createToAPI(timeScoreId: data, token: "", completion: { (newData) in
                                if newData != nil {
                                    data.id = Int32(newData!.id)
                                    if !TimeScoresDataHelpers.getFunc.setTimeScore(timeScore: data, userConnected: userConnected, withoutSynchronization: true) {
                                        //
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    func timeScoreActivitiesSynchronization(userConnected: Users!) {
        APITimeScoreActivities.getFunc.getAllFromAPI(userId: Int(userConnected.id), token: "") { (dataAPIs) in
            if dataAPIs != nil {
                //Création dans données dans la base portable à partir du serveur
                for dataAPI in dataAPIs!{
                    var search: TimeScoreActivities? = TimeScoreActivitiesDataHelpers.getFunc.searchTimeScoreActivityById(id: dataAPI.id, userConnected: userConnected)
                    if search == nil {
                        let timeScore = TimeScoresDataHelpers.getFunc.searchTimeScoreById(id: dataAPI.timeScoreId, userConnected: userConnected)
                        let activity = ActivitiesDataHelpers.getFunc.searchActivityById(id: dataAPI.activityId, userConnected: userConnected)
                        if timeScore != nil && activity != nil {
                            search = TimeScoreActivitiesDataHelpers.getFunc.searchTimeScoreActivityByTimeScoreAndActivity(timeScore: timeScore!, activity: activity!, userConnected: userConnected)
                        } else {
                            search = nil
                        }
                        if search == nil  {
                            if !TimeScoreActivitiesDataHelpers.getFunc.setNewTimeScoreActivityFromTimeScoreActivityAPI(timeScoreActivityAPI: dataAPI, userConnected: userConnected) {
                                //
                            }
                        } else {
                            search!.id = Int32(dataAPI.id)
                            if search!.modifiedDate! < dataAPI.modifiedDate {
                                search!.running = dataAPI.running
                                search!.modifiedDate = dataAPI.modifiedDate
                                if !TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivity(timeScoreActivity: search!, userConnected: userConnected, withoutSynchronization: true) {
                                    //
                                }
                            } else if search!.modifiedDate! > dataAPI.modifiedDate {
                                if !TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivity(timeScoreActivity: search!, userConnected: userConnected, withoutSynchronization: true) {
                                    //
                                }
                                APITimeScoreActivities.getFunc.updateToAPI(timeScoreActivityId: search!, token: "", completion: { (httpCode) in
                                    //
                                })
                            }
                        }
                    } else {
                        if search!.modifiedDate! < dataAPI.modifiedDate {
                            search!.running = dataAPI.running
                            search!.modifiedDate = dataAPI.modifiedDate
                            if !TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivity(timeScoreActivity: search!, userConnected: userConnected, withoutSynchronization: true) {
                                //
                            }
                        } else if search!.modifiedDate! > dataAPI.modifiedDate {
                            if !TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivity(timeScoreActivity: search!, userConnected: userConnected, withoutSynchronization: true) {
                                //
                            }
                            APITimeScoreActivities.getFunc.updateToAPI(timeScoreActivityId: search!, token: "", completion: { (httpCode) in
                                //
                            })
                        }
                    }
                }
                
                //Création des données sur le serveur à partir de la base portable
                let datas = TimeScoreActivitiesDataHelpers.getFunc.getAllTimeScoreActivities(userConnected: userConnected)
                if datas != nil {
                    for data in datas! {
                        if data.id == 0 {
                            APITimeScoreActivities.getFunc.createToAPI(timeScoreActivityId: data, token: "", completion: { (newData) in
                                if newData != nil {
                                    data.id = Int32(newData!.id)
                                    if !TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivity(timeScoreActivity: data, userConnected: userConnected, withoutSynchronization: true) {
                                        //
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    func timeScoreActivityDetailsSynchronization(userConnected: Users!) {
        APITimeScoreActivityDetails.getFunc.getAllFromAPI(userId: Int(userConnected.id), token: "") { (dataAPIs) in
            if dataAPIs != nil {
                //Création dans données dans la base portable à partir du serveur
                for dataAPI in dataAPIs!{
                    var search: TimeScoreActivityDetails? = TimeScoreActivityDetailsDataHelpers.getFunc.searchTimeScoreActivityDetailById(id: dataAPI.id, userConnected: userConnected)
                    if search == nil {
                        let timeScore = TimeScoreActivitiesDataHelpers.getFunc.searchTimeScoreActivityById(id: dataAPI.timeScoreActivityId, userConnected: userConnected)
                        if timeScore != nil {
                            search = TimeScoreActivityDetailsDataHelpers.getFunc.searchTimeScoreActivityDetailByTimeScoreActivityAndStartDateTime(timeScoreActivity: timeScore!, startDateTime: dataAPI.startDateTime, userConnected: userConnected)
                        } else {
                            search = nil
                        }
                        if search == nil  {
                            if !TimeScoreActivityDetailsDataHelpers.getFunc.setNewTimeScoreActivityDetailFromTimeScoreActivityDetailAPI(timeScoreActivityDetailAPI: dataAPI, userConnected: userConnected) {
                                //
                            }
                        } else {
                            search!.id = Int32(dataAPI.id)
                            if search!.modifiedDate! < dataAPI.modifiedDate {
                                search!.running = dataAPI.running
                                search!.startLatitude = dataAPI.startLatitude
                                search!.startLongitude = dataAPI.startLongitude
                                search!.endDateTime = dataAPI.endDateTime
                                search!.endLatitude = dataAPI.endLatitude
                                search!.endLongitude = dataAPI.endLongitude
                                search!.duration = dataAPI.duration
                                search!.modifiedDate = dataAPI.modifiedDate
                                if !TimeScoreActivityDetailsDataHelpers.getFunc.setTimeScoreActivityDetail(timeScoreActivityDetail: search!, userConnected: userConnected, withoutSynchronization: true) {
                                    //
                                }
                            } else if search!.modifiedDate! > dataAPI.modifiedDate {
                                if !TimeScoreActivityDetailsDataHelpers.getFunc.setTimeScoreActivityDetail(timeScoreActivityDetail: search!, userConnected: userConnected, withoutSynchronization: true) {
                                    //
                                }
                                APITimeScoreActivityDetails.getFunc.updateToAPI(timeScoreActivityDetailId: search!, token: "", completion: { (httpCode) in
                                    //
                                })
                            }
                        }
                    } else {
                        if search!.modifiedDate! < dataAPI.modifiedDate {
                            search!.running = dataAPI.running
                            search!.startLatitude = dataAPI.startLatitude
                            search!.startLongitude = dataAPI.startLongitude
                            search!.endDateTime = dataAPI.endDateTime
                            search!.endLatitude = dataAPI.endLatitude
                            search!.endLongitude = dataAPI.endLongitude
                            search!.duration = dataAPI.duration
                            search!.modifiedDate = dataAPI.modifiedDate
                            if !TimeScoreActivityDetailsDataHelpers.getFunc.setTimeScoreActivityDetail(timeScoreActivityDetail: search!, userConnected: userConnected, withoutSynchronization: true) {
                                //
                            }
                        } else if search!.modifiedDate! > dataAPI.modifiedDate {
                            if !TimeScoreActivityDetailsDataHelpers.getFunc.setTimeScoreActivityDetail(timeScoreActivityDetail: search!, userConnected: userConnected, withoutSynchronization: true) {
                                //
                            }
                            APITimeScoreActivityDetails.getFunc.updateToAPI(timeScoreActivityDetailId: search!, token: "", completion: { (httpCode) in
                                //
                            })
                        }
                    }
                }
                
                //Création des données sur le serveur à partir de la base portable
                let datas = TimeScoreActivityDetailsDataHelpers.getFunc.getAllTimeScoreActivityDetails(userConnected: userConnected)
                if datas != nil {
                    for data in datas! {
                        if data.id == 0 {
                            APITimeScoreActivityDetails.getFunc.createToAPI(timeScoreActivityDetailId: data, token: "", completion: { (newData) in
                                if newData != nil {
                                    data.id = Int32(newData!.id)
                                    if !TimeScoreActivityDetailsDataHelpers.getFunc.setTimeScoreActivityDetail(timeScoreActivityDetail: data, userConnected: userConnected, withoutSynchronization: true) {
                                        //
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    func messagesSynchronization(userConnected: Users!) {
        if userConnected.synchronization {
            APIMessages.getFunc.getAllFromAPI(userId: Int(userConnected.id), token: "") { (dataAPIs) in
                if dataAPIs != nil {
                    var dicoUsersToCreate = [Int]()
                    for dataAPI in dataAPIs!{
                        if dataAPI.userFromId != userConnected.id && !dicoUsersToCreate.contains(dataAPI.userFromId) {
                            if UsersDataHelpers.getFunc.searchUserById(id: Int32(dataAPI.userFromId)) == nil {
                                dicoUsersToCreate.append(dataAPI.userFromId)
                            }
                        }
                        if dataAPI.userToId != userConnected.id && !dicoUsersToCreate.contains(dataAPI.userToId) {
                            if UsersDataHelpers.getFunc.searchUserById(id: Int32(dataAPI.userFromId)) == nil {
                                dicoUsersToCreate.append(dataAPI.userToId)
                            }
                        }
                    }
                    
                    if dicoUsersToCreate.count > 0 {
                        var listOfUserId: String = ""
                        for usr in dicoUsersToCreate {
                            listOfUserId += String(usr) + "-"
                        }
                        APIUsers.getFunc.getAllUsersForAListFromAPI(listOfUserId: listOfUserId, token: "", completion: { (users) in
                            if users != nil {
                                for user in users! {
                                    if !UsersDataHelpers.getFunc.setNewUserFromUserAPI(userAPI: user) {
                                        //
                                    }
                                }
                                self.messagesTraetment(dataAPIs: dataAPIs!, userConnected: userConnected)
                            }
                        })
                    } else {
                        self.messagesTraetment(dataAPIs: dataAPIs!, userConnected: userConnected)
                    }
                }
            }
            
            //Création des données sur le serveur à partir de la base portable
            let datas = MessagesDataHelpers.getFunc.getAllMessages(userConnected: userConnected)
            if datas != nil {
                for data in datas! {
                    if data.id == 0 {
                        APIMessages.getFunc.createToAPI(messageId: data, token: "", completion: { (newData) in
                            if newData != nil {
                                data.id = Int32(newData!.id)
                                if !MessagesDataHelpers.getFunc.setMessage(message: data, userConnected: userConnected, withoutSynchronization: true) {
                                    //
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
    func messagesTraetment(dataAPIs : [MessageAPI], userConnected: Users!) {
        //Création dans données dans la base portable à partir du serveur
        for dataAPI in dataAPIs{
            let userFromId = UsersDataHelpers.getFunc.searchUserById(id: Int32(dataAPI.userFromId))
            let userToId = UsersDataHelpers.getFunc.searchUserById(id: Int32(dataAPI.userToId))
            var search: Messages? = MessagesDataHelpers.getFunc.searchMessageById(id: dataAPI.id, userConnected: userConnected)
            if search == nil, userFromId != nil, userToId != nil {
                search = MessagesDataHelpers.getFunc.searchMessageByUserFromIdAndUserToIdAndDate(userFromId: userFromId!, userToId: userToId!, date: dataAPI.modifiedDate, userConnected: userConnected)
                if search == nil  {
                    if !MessagesDataHelpers.getFunc.setNewMessageFromMessageAPI(messageAPI: dataAPI, userConnected: userConnected) {
                        //
                    }
                } else {
                    search!.id = Int32(dataAPI.id)
                    if search!.modifiedDate! < dataAPI.modifiedDate {
                        search!.userFromId = userFromId
                        search!.userToId = userToId
                        search!.sms = dataAPI.sms
                        search!.read = dataAPI.read
                        search!.message = dataAPI.message
                        search!.modifiedDate = dataAPI.modifiedDate
                        if !MessagesDataHelpers.getFunc.setMessage(message: search, userConnected: userConnected, withoutSynchronization: true) {
                            //
                        }
                    } else if search!.modifiedDate! > dataAPI.modifiedDate {
                        if !MessagesDataHelpers.getFunc.setMessage(message: search, userConnected: userConnected, withoutSynchronization: true) {
                            //
                        }
                        APIMessages.getFunc.updateToAPI(messageId: search!, token: "", completion: { (httpCode) in
                            //
                        })
                    }
                }
            } else {
                if search!.modifiedDate! < dataAPI.modifiedDate {
                    search!.userFromId = userFromId
                    search!.userToId = userToId
                    search!.sms = dataAPI.sms
                    search!.read = dataAPI.read
                    search!.message = dataAPI.message
                    search!.modifiedDate = dataAPI.modifiedDate
                    if !MessagesDataHelpers.getFunc.setMessage(message: search, userConnected: userConnected, withoutSynchronization: true) {
                        //
                    }
                } else if search!.modifiedDate! > dataAPI.modifiedDate {
                    if !MessagesDataHelpers.getFunc.setMessage(message: search, userConnected: userConnected, withoutSynchronization: true) {
                        //
                    }
                    APIMessages.getFunc.updateToAPI(messageId: search!, token: "", completion: { (httpCode) in
                        //
                    })
                }
            }
        }
    }
    
    func updateUsersSynchronization(userConnected: Users) {
        let allUsers = UsersDataHelpers.getFunc.getAllUsers()
        if allUsers.count > 0 {
            var listOfUserId: String = ""
            for usr in allUsers {
                if usr != userConnected {
                    listOfUserId += String(usr.id) + "-"
                }
            }
            APIUsers.getFunc.getAllUsersForAListFromAPI(listOfUserId: listOfUserId, token: "", completion: { (users) in
                if users != nil {
                    for usr in users! {
                        let user = UsersDataHelpers.getFunc.searchUserById(id: Int32(usr.id))
                        if user != nil {
                            if usr.modifiedDate > user!.modifiedDate! {
                                if !UsersDataHelpers.getFunc.setUserFromUserAPI(userAPI: usr, userConnected: userConnected, withoutSynchronization: true) {
                                    //
                                }
                            }
                        }
                    }
                }
            })
        }
    }
}
