//
//  Constants.swift
//  SkillsView
//
//  Created by Sunil Kumar Y on 24/01/18.
//  Copyright © 2018 Sunil Kumar Y. All rights reserved.
//

import Foundation

typealias ResponseBlock = (_ Responder: Any?,_ error: Error) -> Void

let noInternetTitle = "No Internet"
let unableToConnectToInternet = "Unable to connect to the server (Communication Failure)"

struct Server {
    static let base = AppSettingProvider.baseUrl
    static let etimeSheet = "https://etimesheet-fultonhogan.cs14.force.com/SkillsView/services/apexrest/"
    static let preProd = "https://preprod-fultonhogan.cs66.force.com/SkillsView/services/apexrest/"
    static let token = AppSettingProvider.token
}

struct Notification {
    
    struct Reachability {
        static let reachabilityChangedNotification = "ReachabilityChangedNotification"
        static let networkAvailable = "networkAvailable"
        static let networkNotAvailable = "networkNotAvailable"
    }
}

struct HTTPMethod {
    static let get = "GET"
    static let post = "POST"
    static let put = "PUT"
    static let delete = "DELETE"
    static let head = "HEAD"
}

enum Result {
    case success
    case failure(String)
}

enum ViewState {
    case loading
    case loaded
    case error(String)
}

enum SearchButttonState {
    case cancel
    case advanceSearch
    
    var value:String {
        var  stringValue = ""
        switch(self) {
        case .cancel:
            stringValue = "Cancel"
        case .advanceSearch:
            stringValue = "Advanced search"
        }
        return stringValue
    }
}

enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        }
    }
}

enum RegionList  {
    case austarlia
    case newZealand
    
    static var itemArray: [RegionList] =
        [.austarlia,.newZealand]
    
    var name: String {
        var name = ""
            switch self {
            case .austarlia:
                name = "Australia"
            case .newZealand:
                name = "New Zealand"
          }
         return name
     }
    
    var flag: String {
        var name = ""
        switch self {
        case .austarlia:
            name = "Flag-Au"
        case .newZealand:
            name = "Flag-Nz"
        }
        return name
    }
    
    var paramsTitle: String {
        var name = ""
        switch self {
        case .austarlia:
            name = "AU"
        case .newZealand:
            name = "NZ"
        }
        return name
    }
}


struct CountryInfo {
    static let key = "country"
    static let newZealand = "NZ"
    static let austarlia = "AU"
}


struct Alert {
    static let addFilterTitle = "Go back?"
    static let addResetFilterTitle = "Reset"
    static let addFilterBody = "Your filters have not been applied. Do you wish to continue?"
    static let addResetFilterBody = "Are you sure, You want to reset all the filters?"
}

//var token = "1A16E77187583C25219CA84FABCEA"
