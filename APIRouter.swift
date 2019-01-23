//
//  APIRouter.swift
//  SkillsView
//
//  Created by Sunil Kumar Y on 02/02/18.
//  Copyright © 2018 Sunil Kumar Y. All rights reserved.
//

import Foundation

enum APIRouter {
    
    case getContacts(searchString: String,offset: Int,limitCount: Int,dict: [String: String])
    case getCompetencies(id: String)
    case getProfilePhoto(id: String)
    case getAdvancedSearchRegion()
    case getAdvancedSearchCompetency(text: String)
    case getAdvancedSearchEndorsement()
    case getAdvancedSearchSkillslevel()
    case getAdvancedSearchLicenceClass()
    
    case getEndorsementsForContact(contact: Contact)
    case getSkillsviewLicencesForContact(contact: Contact)
    
    var path: String {
        let path: String
        switch self {
        case .getContacts:
//            #if SandBox || PreProd
                path = "skillsview_AdvanceSearch"
//            #else
//                path = "skillsviewContacts"
//            #endif
        case .getCompetencies(_):
          path = "skillsviewCompetencies"
        case .getAdvancedSearchCompetency:
            if UserManager.isNewZealand {
                 path = "skillsview_AdvanceSearch"
            } else {
                path = "skillsview_getstaticvalues"
            }
    case .getAdvancedSearchRegion,.getAdvancedSearchEndorsement,.getAdvancedSearchSkillslevel,.getAdvancedSearchLicenceClass,.getEndorsementsForContact,.getSkillsviewLicencesForContact:
            path = "skillsview_getstaticvalues"
            
        case .getProfilePhoto:
            path = "skillsviewPhoto"
            
        }
        return path
    }
    
    var httpMethod: String {
        let method: String
        switch self {
        case .getContacts:
            method = HTTPMethod.get
      case .getCompetencies(_),.getAdvancedSearchRegion,.getAdvancedSearchCompetency,.getAdvancedSearchEndorsement,.getAdvancedSearchSkillslevel,.getAdvancedSearchLicenceClass,.getEndorsementsForContact,.getSkillsviewLicencesForContact,.getProfilePhoto:
            method = HTTPMethod.get
       
        }
        return method
    }
    
    var parameters: [String: String] {
        var params = [String: String]()
        
        switch self {
        case .getContacts(let searchString,let offset,let limitCount,let dict):
            
            if searchString.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
                params["searchstr"] = searchString
            }
            params["func"] = "Adsearch"
            if let location = UserManager.country?.paramsTitle {
                params["location"] = location
            }
             params["offsetval"] = "\(offset)"
             params["limitval"] = "\(limitCount)"
            
            for (key,val) in dict {
                params[key] = val
            }

        case .getCompetencies(let id):
            params["id"] = id
            params["token"] = Server.token
            if let location = UserManager.country?.paramsTitle {
                params["location"] = location
            }
        case .getAdvancedSearchRegion:
            params["func"] = "getRegion"
            if let location = UserManager.country?.paramsTitle {
                params["location"] = location
            }
        case .getAdvancedSearchCompetency(let text):
            params["func"] = "getCompetency"
            if let location = UserManager.country?.paramsTitle {
                params["location"] = location
            }
              params["searchstr"] = text
            
        case .getAdvancedSearchEndorsement:
            params["func"] = "endorsement"
        
        case .getAdvancedSearchSkillslevel:
            params["func"] = "Skillslevel"
         
        case .getAdvancedSearchLicenceClass:
            params["func"] = "LicenceClass"
            
        case .getEndorsementsForContact(let contact):
            params["func"] = "Skillsview_Endorsement"
            
            if let id = contact.id {
                params["ContactId"] = id
            }
 //   params["ContactId"] = "003c000000m19yk"
            
        case .getSkillsviewLicencesForContact(let contact):
            params["func"] = "Skillsview_Licence"
            
            if let id = contact.id {
                params["ContactId"] = id
            }
            
  //    params["ContactId"] = "003c000000m19yk"
            
        case .getProfilePhoto(let id):
            params["id"] = id
            params["token"] = Server.token
        }
        return params
    }
    
    var headers: [String: String] {
        return ["Content-Type" : "application/json"]
    }
    
    var body: Data? {
        var bodyString: String?
        bodyString = ""
        return bodyString?.data(using: String.Encoding.utf8)
    }
    
    var cachePolicy: URLRequest.CachePolicy  {
        return URLRequest.CachePolicy.useProtocolCachePolicy
    }
    
    var timeoutInterval: TimeInterval  {
        return 10.0
    }
    
    var urlRequest: URLRequest {
        var urlReq: URLRequest?
        
        if let url = getURL() {
            urlReq = URLRequest(url: url)
            urlReq?.httpMethod = httpMethod
            for (key,value) in headers {
                urlReq?.addValue(value, forHTTPHeaderField: key)
            }
            urlReq?.httpBody = body
            urlReq?.cachePolicy = cachePolicy
            urlReq?.timeoutInterval = timeoutInterval
        }
        if self.path != "skillsviewPhoto" {
            print(urlReq!.url!)
        }
        return urlReq!
    }
    
    fileprivate func getURL() -> URL? {
        let urlString =  URLSelectionManager.shared.getBaseUrl()
        let baseURL = URL(string: urlString)
        let relativeUrl = URL(string: path, relativeTo: baseURL)
        var urlComponets = URLComponents(url: relativeUrl!, resolvingAgainstBaseURL: true)
        urlComponets?.queryItems = getQueryItems(fromParameters: parameters)
        return urlComponets?.url
    }
    
    
    fileprivate func getQueryItems(fromParameters params: [String: String]) -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        for (key,value) in params {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        return queryItems
    }
    
}


