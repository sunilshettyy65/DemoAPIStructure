//
//  AdvancedSearchViewModelLicenceClassItem.swift
//  SkillsView
//
//  Created by Sunil Kumar Y on 22/02/18.
//  Copyright © 2018 Sunil Kumar Y. All rights reserved.
//

import Foundation

class AdvancedSearchViewModelLicenceClassItem: AdvancedSearchViewModelItem {
      
    var isItemModified: Bool = false
    
    var selectedItemList = [String]()
    
    var complition: AdvancedSearchItemSelected?
        
    var itemSelectionCompletion: AdvancedSearchItemSelected?
    
    let searchManager = AdvancedSearchManager()
    
    var type: AdvancedSearchViewModelItemType {
        return .licenceClass
    }
    
    var title: String {
        return "Licence class"
    }
    
    var dataList = [String]()
    var recentlyUsedList = [String]()

    var previousSelectedItemList = [String]()
    
    func getLicenceClass(complition: @escaping (Result) -> Void) {
        searchManager.getLicenceClass { [weak self](data, error) in
            guard let weakSelf = self else {
                complition(.failure("Object is Nil"))
                return
            }
            if let contactManagerError = error {
                complition(.failure(contactManagerError.localizedDescription))
            } else if let l_Data = data,let datas = l_Data.licenceClassList {
                weakSelf.dataList = datas
                complition(.success)
            } else {
                complition(.failure(""))
            }
        }
    }
    
    func getItem(row: Int) -> String {
        return dataList[safe: row] ?? ""
    }
    
    var count: Int {
        return dataList.count
    }
    
    
}

