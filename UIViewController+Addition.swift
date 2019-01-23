//
//  UIViewController+Addition.swift
//  BusSeat
//
//  Created by sunil on 17/01/19.
//  Copyright © 2019 sunil. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showWarningAlert(message: String){
        
        let alertController: UIAlertController = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title:String,message: String,leftTitle:String?,rightTitle:String?,completion:@escaping ((UIAlertAction) -> Void)){
        
        let alertController: UIAlertController = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        
        if leftTitle != nil {
            let leftAction: UIAlertAction = UIAlertAction(title: leftTitle, style: .default) { action -> Void in
                completion(action)
            }
            alertController.addAction(leftAction)
        }
        
        if rightTitle != nil {
            let rightAction: UIAlertAction = UIAlertAction(title: rightTitle, style: .default) { action -> Void in
                completion(action)
            }
            alertController.addAction(rightAction)
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
}
