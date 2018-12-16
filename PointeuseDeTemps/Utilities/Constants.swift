//
//  Constants.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 15/08/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

//let url = "http://timescore.benoitg.net/api/"
let url = "http://timescoreunsecure.benoitg.net/api/"

let googleAPIKey = "AIzaSyCpQ1nrEPqBVqWUmHKU_V2vuw65Po5-l2o"
let urlAPIGeocoding = "https://maps.googleapis.com/maps/api/geocode/"

let blueBubble = UIColor(red: 184/255, green: 233/255, blue: 255/255, alpha: 1)
let greenBubble = UIColor(red: 197/255, green: 233/255, blue: 192/255, alpha: 1)

var timerMessages: Timer?
let timerMessagesInterval: Double = 2

var timerUsersUpdate: Timer?
let timerUsersUpdateInterval: Double = 30

var usersForMessages = [UserAPI]()

var textFieldToEdit: UITextField?
