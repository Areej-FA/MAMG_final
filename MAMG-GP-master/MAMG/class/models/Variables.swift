//
//  Variables.swift
//  MAMG
//
//  Created by Areej on 2/6/19.
//  Copyright © 2019 Areej. All rights reserved.
//

import Foundation

// MARK:This file has all the globle varibles here

//To check on each interface if the language that was selected in settings to display the values in that language
var isItArabic : Bool = false
//To check on each interface with audio if auto play is enabled or not was selected in settings to auto play audio
var autoPlaySound : Bool = false
//To check if the users is logged in or not
var isUserAGust : Bool = false
//To save users email after loggeing in to retrieve the values of the user from the database which is the primary key/user unique identification
var usersEmaile : String = ""
//Beggining string of the api link
var URLNET : String = "http://192.168.64.2/dashboard/MyWebServices/api/"

