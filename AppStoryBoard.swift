//
//  AppStoryBoard.swift
//  BusSeat
//
//  Created by sunil on 15/01/19.
//  Copyright © 2019 sunil. All rights reserved.
//

import Foundation
import UIKit

enum AppStoryboard : String {
    case Main = "Main"
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(viewcontrollerClass: T.Type) -> T {
        let storyBoardId =  (viewcontrollerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyBoardId) as! T
    }
}

extension UIViewController {
    
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiateFromAppStoryBoard(appStoryBoard: AppStoryboard) -> Self {
        return appStoryBoard.viewController(viewcontrollerClass: self)
    }
}
