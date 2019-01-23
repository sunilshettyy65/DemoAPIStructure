//
//  ContactManager.swift
//  SkillsView
//
//  Created by Sunil Kumar Y on 02/02/18.
//  Copyright © 2018 Sunil Kumar Y. All rights reserved.
//

import Foundation

final class ContactManager: PagingManager {
    
    typealias ContactDataCompletion = ([Contact]?, APIError?) -> ()
    
    func getContactsForSearch(searchString: String,searchDict: [String: String],complition:@escaping ContactDataCompletion) {        
        if (canDownload()) {
            isProgress = true
            let dataTask =  APIClient.shared.decodingTask(with: APIRouter.getContacts(searchString: searchString, offset: offsetVal, limitCount: limitVal, dict: searchDict).urlRequest, decodingType: [Contact].self) { [weak self](contactData, apiError) in
                guard let weakSelf = self else {
                    complition(nil, apiError)
                    return
                }
               
                weakSelf.isProgress = false
                if let response = contactData as? [AnyObject] {
                    weakSelf.processResponse(response)
                }
                complition(contactData as? [Contact], apiError)
            }
            dataTask.resume()
        } else {
            complition(objectsArray as? [Contact], nil)
        }
    }
    
}
