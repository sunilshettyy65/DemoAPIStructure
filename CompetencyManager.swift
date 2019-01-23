//
//  CompetencyManager.swift
//  SkillsView
//
//  Created by Sunil Kumar Y on 06/02/18.
//  Copyright © 2018 Sunil Kumar Y. All rights reserved.
//

import Foundation

final class CompetencyManager {
    
    func fetchCompetency(for contactId: String,complition: @escaping APIClient.JSONTaskCompletionHandler) {
        var dataTask : URLSessionDataTask!
        guard let country = UserManager.country else {
            complition(nil,.requestFailed)
            return
        }
        switch country {
        case .newZealand:
             dataTask = APIClient.shared.decodingTask(with: APIRouter.getCompetencies(id: contactId).urlRequest, decodingType: RequirementData.self, completionHandler: complition)
        case .austarlia:
             dataTask = APIClient.shared.decodingTask(with: APIRouter.getCompetencies(id: contactId).urlRequest, decodingType: CompetencyAUData.self, completionHandler: complition)
        }
        dataTask.resume()
    }
    
    
}
