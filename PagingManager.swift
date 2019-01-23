//
//  PagingManager.swift
//  SkillsView
//
//  Created by Sunil Kumar Y on 28/03/18.
//  Copyright © 2018 Sunil Kumar Y. All rights reserved.
//

import Foundation

struct Paging {
    static let downloadPageSize = 10
}

class ModelManager {
     var objectsArray = [AnyObject]()
}

class PagingManager: ModelManager {
    
    var limitVal : Int = Paging.downloadPageSize
    var offsetVal : Int = 0
    var isProgress = false
    
    var recentDownloadObjectsArray:[AnyObject]?
    var isMoreItemsPendingToDownload = true
    var next: NSURL?
    
    func resetToinitialConfig() {
        self.next = nil
        self.recentDownloadObjectsArray = nil
        self.objectsArray.removeAll(keepingCapacity: false)
        self.offsetVal = 0
        self.limitVal = Paging.downloadPageSize
        self.isMoreItemsPendingToDownload = true
    }
    
}

extension PagingManager {
    
    func canDownload() -> Bool {
        return isMoreItemsPendingToDownload == true && isProgress == false
    }
    
    func processResponse(_ response : [AnyObject]?) {
        if let array = response , array.count > 0 {
            self.recentDownloadObjectsArray = array
            self.objectsArray += array
            self.configurePaginationValuesForNextRequest()
        } else {
            self.isMoreItemsPendingToDownload = false
        }
    }
    
    func configurePaginationValuesForNextRequest() -> Void {
        if let recent = self.recentDownloadObjectsArray , recent.count < Paging.downloadPageSize {
            self.isMoreItemsPendingToDownload = false
        } else {
            self.isMoreItemsPendingToDownload = true
            self.offsetVal += Paging.downloadPageSize
        }
    }
}
