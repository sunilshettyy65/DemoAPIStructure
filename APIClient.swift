//
//  APIClient.swift
//  SkillsView
//
//  Created by Sunil Kumar Y on 02/02/18.
//  Copyright © 2018 Sunil Kumar Y. All rights reserved.
//

import Foundation

class APIClient {
    
    static let shared = APIClient()
    private init() { }
    
    typealias JSONTaskCompletionHandler = (Decodable?, APIError?) -> ()

    func decodingTask<T: Decodable>(with request: URLRequest, decodingType: T.Type, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let genericModel = try decoder.decode(decodingType, from: data)
                        completion(genericModel, nil)
                    } catch {
                        completion(nil, .jsonConversionFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }
    
}


