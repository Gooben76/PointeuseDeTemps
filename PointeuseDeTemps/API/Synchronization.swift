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
    
    func userSynchronization(userConnected: Users!) -> String {
        if userConnected.synchronization {
            if userConnected.id == 0 {
                //si utilisateur n'existe pas sur le serveur, on le crée
                APIUsers.getFunc.createUserToAPI(userId: userConnected, token: "") { (data) in
                    if data != nil {
                        userConnected.id = Int32(data!.id)
                        if !UsersDataHelpers.getFunc.setUser(user: userConnected) {
                            print("Erreur de synchronisation de Users")
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
                                    print("HTTP Code (users) : \(httpCode)")
                                })
                            } else if data!.modifiedDate > userConnected.modifiedDate! {
                                userConnected.password = data!.password
                                userConnected.allowMessages = data!.allowMessages
                                userConnected.firstName = data!.firstName
                                userConnected.lastName = data!.lastName
                                if !UsersDataHelpers.getFunc.setUser(user: userConnected) {
                                    print("Erreur de synchronisation de Users")
                                }
                            }
                        } else {
                            // si il n'y a pas de cohérence entre l'id et la login et mail de l'utilisateur, on vérifie si le login et le mail existe déjà et si oui on change d'id mobile
                            APIUsers.getFunc.getUserFromLoginAndMail(login: userConnected.login!, mail: userConnected.password!, token: "", completion: { (data) in
                                if data != nil {
                                    userConnected.id = Int32(data!.id)
                                    if !UsersDataHelpers.getFunc.setUser(user: userConnected) {
                                        print("Erreur de synchronisation de Users")
                                    }
                                } else {
                                    // si le login et le mail n'existe pas, on crée un nouvel utilisateur
                                    APIUsers.getFunc.createUserToAPI(userId: userConnected, token: "") { (data) in
                                        if data != nil {
                                            userConnected.id = Int32(data!.id)
                                            if !UsersDataHelpers.getFunc.setUser(user: userConnected) {
                                                print("Erreur de synchronisation de Users")
                                            }
                                        }
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
        return userConnected.password!
    }
    
    func generalSynchronization(userConnected: Users!) {
        if userConnected.synchronization {
            activitiesSynchronization(userConnected: userConnected)
            typicalDaysSynchronization(userConnected: userConnected)
            typicalDayActivitiesSynchronization(userConnected: userConnected)
            timeScoresSynchronization(userConnected: userConnected)
            timeScoreActivitiesSynchronization(userConnected: userConnected)
            timeScoreActivityDetailsSynchronization(userConnected: userConnected)
            friendsSynchronization(userConnected: userConnected)
            messagesSynchronization(userConnected: userConnected)
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
                                print("Erreur de synchronisation d'Activities")
                            }
                        } else {
                            search!.id = Int32(dataAPI.id)
                            if search!.modifiedDate! < dataAPI.modifiedDate {
                                search!.order = Int32(dataAPI.order)
                                search!.gpsPosition = dataAPI.gpsPosition
                                search!.modifiedDate = dataAPI.modifiedDate
                                if !ActivitiesDataHelpers.getFunc.setActivity(activity: search, userConnected: userConnected) {
                                    print("Erreur de synchronisation d'Activities")
                                }
                            } else if search!.modifiedDate! > dataAPI.modifiedDate {
                                if !ActivitiesDataHelpers.getFunc.setActivity(activity: search, userConnected: userConnected) {
                                    print("Erreur de synchronisation d'Activities")
                                }
                                APIActivities.getFunc.updateToAPI(activityId: search!, token: "", completion: { (httpCode) in
                                    print("HTTP Code : \(httpCode)")
                                })
                            }
                        }
                    } else {
                        if search!.modifiedDate! < dataAPI.modifiedDate {
                            search!.order = Int32(dataAPI.order)
                            search!.gpsPosition = dataAPI.gpsPosition
                            search!.modifiedDate = dataAPI.modifiedDate
                            if !ActivitiesDataHelpers.getFunc.setActivity(activity: search, userConnected: userConnected) {
                                print("Erreur de synchronisation d'Activities")
                            }
                        } else if search!.modifiedDate! > dataAPI.modifiedDate {
                            if !ActivitiesDataHelpers.getFunc.setActivity(activity: search, userConnected: userConnected) {
                                print("Erreur de synchronisation d'Activities")
                            }
                            APIActivities.getFunc.updateToAPI(activityId: search!, token: "", completion: { (httpCode) in
                                print("HTTP Code (activities) : \(httpCode)")
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
                                    if !ActivitiesDataHelpers.getFunc.setActivity(activity: data, userConnected: userConnected) {
                                        print("Erreur de synchronisation d'Activities")
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
                                print("Erreur de synchronisation de TypicalDays")
                            }
                        } else {
                            search!.id = Int32(dataAPI.id)
                            if search!.modifiedDate! < dataAPI.modifiedDate {
                                search!.modifiedDate = dataAPI.modifiedDate
                                if !TypicalDaysDataHelpers.getFunc.setTypicalDay(typicalDay: search, userConnected: userConnected) {
                                    print("Erreur de synchronisation de TypicalDays")
                                }
                            } else if search!.modifiedDate! > dataAPI.modifiedDate {
                                if !TypicalDaysDataHelpers.getFunc.setTypicalDay(typicalDay: search, userConnected: userConnected) {
                                    print("Erreur de synchronisation de TypicalDays")
                                }
                                APITypicalDays.getFunc.updateToAPI(typicalDayId: search!, token: "", completion: { (httpCode) in
                                    print("HTTP Code : \(httpCode)")
                                })
                            }
                        }
                    } else {
                        if search!.modifiedDate! < dataAPI.modifiedDate {
                            search!.modifiedDate = dataAPI.modifiedDate
                            if !TypicalDaysDataHelpers.getFunc.setTypicalDay(typicalDay: search, userConnected: userConnected) {
                                print("Erreur de synchronisation de TypicalDays")
                            }
                        } else if search!.modifiedDate! > dataAPI.modifiedDate {
                            if !TypicalDaysDataHelpers.getFunc.setTypicalDay(typicalDay: search, userConnected: userConnected) {
                                print("Erreur de synchronisation de TypicalDays")
                            }
                            APITypicalDays.getFunc.updateToAPI(typicalDayId: search!, token: "", completion: { (httpCode) in
                                print("HTTP Code (TypicalDays) : \(httpCode)")
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
                                    if !TypicalDaysDataHelpers.getFunc.setTypicalDay(typicalDay: data, userConnected: userConnected) {
                                        print("Erreur de synchronisation de TypicalDays")
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
                                print("Erreur de synchronisation de TypicalDayActivities")
                            }
                        } else {
                            search!.id = Int32(dataAPI.id)
                            if search!.modifiedDate! < dataAPI.modifiedDate {
                                search!.modifiedDate = dataAPI.modifiedDate
                                if !TypicalDayActivitiesDataHelpers.getFunc.setTypicalDayActivity(typicalDay: search!.typicalDayId, activity: search!.activityId, userConnected: userConnected) {
                                    print("Erreur de synchronisation de TypicalDayActivities")
                                }
                            } else if search!.modifiedDate! > dataAPI.modifiedDate {
                                if !TypicalDayActivitiesDataHelpers.getFunc.setTypicalDayActivity(typicalDay: search!.typicalDayId, activity: search!.activityId, userConnected: userConnected) {
                                    print("Erreur de synchronisation de TypicalDayActivities")
                                }
                                APITypicalDayActivities.getFunc.updateToAPI(typicalDayAvtivityId: search!, token: "", completion: { (httpCode) in
                                    print("HTTP Code : \(httpCode)")
                                })
                            }
                        }
                    } else {
                        if search!.modifiedDate! < dataAPI.modifiedDate {
                            search!.modifiedDate = dataAPI.modifiedDate
                           if !TypicalDayActivitiesDataHelpers.getFunc.setTypicalDayActivity(typicalDay: search!.typicalDayId, activity: search!.activityId, userConnected: userConnected) {
                                print("Erreur de synchronisation de TypicalDayActivities")
                            }
                        } else if search!.modifiedDate! > dataAPI.modifiedDate {
                            if !TypicalDayActivitiesDataHelpers.getFunc.setTypicalDayActivity(typicalDay: search!.typicalDayId, activity: search!.activityId, userConnected: userConnected) {
                                print("Erreur de synchronisation de TypicalDayActivities")
                            }
                            APITypicalDayActivities.getFunc.updateToAPI(typicalDayAvtivityId: search!, token: "", completion: { (httpCode) in
                                print("HTTP Code (TypicalDayActivities) : \(httpCode)")
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
                                    if !TypicalDayActivitiesDataHelpers.getFunc.setTypicalDayActivity(typicalDay: data.typicalDayId, activity: data.activityId, userConnected: userConnected) {
                                        print("Erreur de synchronisation de TypicalDays")
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
                                print("Erreur de synchronisation de TimeScores")
                            }
                        } else {
                            search!.id = Int32(dataAPI.id)
                            if search!.modifiedDate! < dataAPI.modifiedDate {
                                search!.typicalDayId = TypicalDaysDataHelpers.getFunc.searchTypicalDayById(id: dataAPI.typicalDayId!, userConnected: userConnected)
                                search!.modifiedDate = dataAPI.modifiedDate
                                if !TimeScoresDataHelpers.getFunc.setTimeScore(timeScore: search, userConnected: userConnected) {
                                    print("Erreur de synchronisation de TimeScores")
                                }
                            } else if search!.modifiedDate! > dataAPI.modifiedDate {
                                if !TimeScoresDataHelpers.getFunc.setTimeScore(timeScore: search, userConnected: userConnected) {
                                    print("Erreur de synchronisation de TimeScores")
                                }
                                APITimeScores.getFunc.updateToAPI(timeScoreId: search!, token: "", completion: { (httpCode) in
                                    print("HTTP Code : \(httpCode)")
                                })
                            }
                        }
                    } else {
                        if search!.modifiedDate! < dataAPI.modifiedDate {
                            search!.typicalDayId = TypicalDaysDataHelpers.getFunc.searchTypicalDayById(id: dataAPI.typicalDayId!, userConnected: userConnected)
                            search!.modifiedDate = dataAPI.modifiedDate
                            if !TimeScoresDataHelpers.getFunc.setTimeScore(timeScore: search, userConnected: userConnected) {
                                print("Erreur de synchronisation de TimeScores")
                            }
                        } else if search!.modifiedDate! > dataAPI.modifiedDate {
                            if !TimeScoresDataHelpers.getFunc.setTimeScore(timeScore: search, userConnected: userConnected) {
                                print("Erreur de synchronisation de TimeScores")
                            }
                            APITimeScores.getFunc.updateToAPI(timeScoreId: search!, token: "", completion: { (httpCode) in
                                print("HTTP Code (TimeScores) : \(httpCode)")
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
                                    if !TimeScoresDataHelpers.getFunc.setTimeScore(timeScore: data, userConnected: userConnected) {
                                        print("Erreur de synchronisation de TimeScores")
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
                                print("Erreur de synchronisation de TimeScoreActivities")
                            }
                        } else {
                            search!.id = Int32(dataAPI.id)
                            if search!.modifiedDate! < dataAPI.modifiedDate {
                                search!.running = dataAPI.running
                                search!.modifiedDate = dataAPI.modifiedDate
                                if !TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivity(timeScoreActivity: search!, userConnected: userConnected) {
                                    print("Erreur de synchronisation de TimeScoreActivities")
                                }
                            } else if search!.modifiedDate! > dataAPI.modifiedDate {
                                if !TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivity(timeScoreActivity: search!, userConnected: userConnected) {
                                    print("Erreur de synchronisation de TimeScoreActivities")
                                }
                                APITimeScoreActivities.getFunc.updateToAPI(timeScoreActivityId: search!, token: "", completion: { (httpCode) in
                                    print("HTTP Code : \(httpCode)")
                                })
                            }
                        }
                    } else {
                        if search!.modifiedDate! < dataAPI.modifiedDate {
                            search!.running = dataAPI.running
                            search!.modifiedDate = dataAPI.modifiedDate
                            if !TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivity(timeScoreActivity: search!, userConnected: userConnected) {
                                print("Erreur de synchronisation de TimeScoreActivities")
                            }
                        } else if search!.modifiedDate! > dataAPI.modifiedDate {
                            if !TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivity(timeScoreActivity: search!, userConnected: userConnected) {
                                print("Erreur de synchronisation de TimeScoreActivities")
                            }
                            APITimeScoreActivities.getFunc.updateToAPI(timeScoreActivityId: search!, token: "", completion: { (httpCode) in
                                print("HTTP Code (TimeScoreActivities) : \(httpCode)")
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
                                    if !TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivity(timeScoreActivity: data, userConnected: userConnected) {
                                        print("Erreur de synchronisation de TimeScoreActivities")
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
                                print("Erreur de synchronisation de TimeScoreActivityDetails")
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
                                if !TimeScoreActivityDetailsDataHelpers.getFunc.setTimeScoreActivityDetail(timeScoreActivityDetail: search!, userConnected: userConnected) {
                                    print("Erreur de synchronisation de TimeScoreActivityDetails")
                                }
                            } else if search!.modifiedDate! > dataAPI.modifiedDate {
                                if !TimeScoreActivityDetailsDataHelpers.getFunc.setTimeScoreActivityDetail(timeScoreActivityDetail: search!, userConnected: userConnected) {
                                    print("Erreur de synchronisation de TimeScoreActivityDetails")
                                }
                                APITimeScoreActivityDetails.getFunc.updateToAPI(timeScoreActivityDetailId: search!, token: "", completion: { (httpCode) in
                                    print("HTTP Code : \(httpCode)")
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
                            if !TimeScoreActivityDetailsDataHelpers.getFunc.setTimeScoreActivityDetail(timeScoreActivityDetail: search!, userConnected: userConnected) {
                                print("Erreur de synchronisation de TimeScoreActivityDetails")
                            }
                        } else if search!.modifiedDate! > dataAPI.modifiedDate {
                            if !TimeScoreActivityDetailsDataHelpers.getFunc.setTimeScoreActivityDetail(timeScoreActivityDetail: search!, userConnected: userConnected) {
                                print("Erreur de synchronisation de TimeScoreActivityDetails")
                            }
                            APITimeScoreActivityDetails.getFunc.updateToAPI(timeScoreActivityDetailId: search!, token: "", completion: { (httpCode) in
                                print("HTTP Code (TimeScoreActivityDetails) : \(httpCode)")
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
                                    if !TimeScoreActivityDetailsDataHelpers.getFunc.setTimeScoreActivityDetail(timeScoreActivityDetail: data, userConnected: userConnected) {
                                        print("Erreur de synchronisation de TimeScoreActivityDetails")
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    func friendsSynchronization(userConnected: Users!) {
        APIFriends.getFunc.getAllFromAPI(userId: Int(userConnected.id), token: "") { (dataAPIs) in
            if dataAPIs != nil {
                //Création dans données dans la base portable à partir du serveur
                for dataAPI in dataAPIs!{
                    var search: Friends? = FriendsDataHelpers.getFunc.searchFriendById(id: dataAPI.id, userConnected: userConnected)
                    if search == nil {
                        search = FriendsDataHelpers.getFunc.searchFriendByFriendId(id: Int32(dataAPI.friendId), userConnected: userConnected)
                        if search == nil  {
                            if !FriendsDataHelpers.getFunc.setNewFriendFromFriendAPI(friendAPI: dataAPI, userConnected: userConnected) {
                                print("Erreur de synchronisation de Friends")
                            }
                        } else {
                            search!.id = Int32(dataAPI.id)
                            if search!.modifiedDate! < dataAPI.modifiedDate {
                                search!.friendId = Int32(dataAPI.friendId)
                                search!.friendLogin = dataAPI.friendLogin
                                search!.friendMail = dataAPI.friendMail
                                search!.friendLastName = dataAPI.friendLastName
                                search!.friendFirstName = dataAPI.friendFirstName
                                search!.active = dataAPI.active
                                search!.modifiedDate = dataAPI.modifiedDate
                                if !FriendsDataHelpers.getFunc.setFriend(friend: search, userConnected: userConnected) {
                                    print("Erreur de synchronisation de Friends")
                                }
                            } else if search!.modifiedDate! > dataAPI.modifiedDate {
                                if !FriendsDataHelpers.getFunc.setFriend(friend: search, userConnected: userConnected) {
                                    print("Erreur de synchronisation de Friends")
                                }
                                APIFriends.getFunc.updateToAPI(friendId: search!, token: "", completion: { (httpCode) in
                                    print("HTTP Code : \(httpCode)")
                                })
                            }
                        }
                    } else {
                        if search!.modifiedDate! < dataAPI.modifiedDate {
                            search!.friendId = Int32(dataAPI.friendId)
                            search!.friendLogin = dataAPI.friendLogin
                            search!.friendMail = dataAPI.friendMail
                            search!.friendLastName = dataAPI.friendLastName
                            search!.friendFirstName = dataAPI.friendFirstName
                            search!.active = dataAPI.active
                            search!.modifiedDate = dataAPI.modifiedDate
                            if !FriendsDataHelpers.getFunc.setFriend(friend: search, userConnected: userConnected) {
                                print("Erreur de synchronisation de Friends")
                            }
                        } else if search!.modifiedDate! > dataAPI.modifiedDate {
                            if !FriendsDataHelpers.getFunc.setFriend(friend: search, userConnected: userConnected) {
                                print("Erreur de synchronisation de Friends")
                            }
                            APIFriends.getFunc.updateToAPI(friendId: search!, token: "", completion: { (httpCode) in
                                print("HTTP Code (friends) : \(httpCode)")
                            })
                        }
                    }
                }
                
                //Création des données sur le serveur à partir de la base portable
                let datas = FriendsDataHelpers.getFunc.getAllFriends(userConnected: userConnected)
                if datas != nil {
                    for data in datas! {
                        if data.id == 0 {
                            APIFriends.getFunc.createToAPI(friendId: data, token: "", completion: { (newData) in
                                if newData != nil {
                                    data.id = Int32(newData!.id)
                                    if !FriendsDataHelpers.getFunc.setFriend(friend: data, userConnected: userConnected) {
                                        print("Erreur de synchronisation de Friends")
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
        APIMessages.getFunc.getAllFromAPI(userId: Int(userConnected.id), token: "") { (dataAPIs) in
            if dataAPIs != nil {
                //Création dans données dans la base portable à partir du serveur
                for dataAPI in dataAPIs!{
                    let search: Messages? = MessagesDataHelpers.getFunc.searchMessageById(id: dataAPI.id, userConnected: userConnected)
                    if search == nil {
                        if !MessagesDataHelpers.getFunc.setNewMessageFromMessageAPI(messageAPI: dataAPI, userConnected: userConnected) {
                                print("Erreur de synchronisation de Messages")
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
                                    /*if !MessagesDataHelpers.getFunc.setMessage(message: data, userConnected: userConnected) {
                                        print("Erreur de synchronisation de Messages")
                                    }*/
                                }
                            })
                        }
                    }
                }
            }
        }
    }
}
