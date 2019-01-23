//
//  AddMobileViewModel.swift
//  RecroAssignement
//
//  Created by sunil on 26/05/18.
//  Copyright © 2018 sunil. All rights reserved.
//

import Foundation
import UIKit

enum MobileItem {
    case name
    case model
    case color
    case cost
    case battery
    case primary
    case secondary
    case memory
    
    var placeHolderText : String? {
        let string : String
        switch self {
        case .name:
            string = "Enter the name"
        case .model:
            string = "Enter the model"
        case .color:
            string = "Pick the color"
        case .cost:
            string = "Enter the cost"
        case .battery:
            string = "Enter the battery"
        case .primary:
            string = "Enter the primary cam pixel"
        case .secondary:
            string = "Enter the secondary cam pixel"
        case .memory:
            string = "Enter the memory"
        }
        return string
    }
    
    var keyWord : String? {
        let string : String
        switch self {
        case .name:
            string = "Name"
        case .model:
            string = "Model"
        case .color:
            string = "Color"
        case .cost:
            string = "Cost"
        case .battery:
            string = "Battery"
        case .primary:
            string = "Primary camera"
        case .secondary:
            string = "Secondary camera"
        case .memory:
            string = "Memory"
        }
        return string
    }
    
    var suffix : String? {
        let string : String
        switch self {
        case .name:
            string = ""
        case .model:
            string = ""
        case .color:
            string = ""
        case .cost:
            string = ""
        case .battery:
            string = " mAh"
        case .primary,.secondary:
            string = "MP"
        case .memory:
            string = " GB"
        }
        return string
    }
    
    var keyboardType : UIKeyboardType {
        let type : UIKeyboardType
        switch self {
        case .name:
            type = .alphabet
        case .model:
            type = .default
        case .color:
            type = .alphabet
        case .cost, .battery, .primary, .secondary, .memory:
            type = .numberPad
        }
        return type
    }
}

protocol  DataSourceProtocol{
    
    func numberOfItems(forSection section : Int) -> Int
    func viewModel(atIndexPath indexPath : IndexPath) -> Any?
    func numberOfSection() -> Int
    func viewModelForHeader(for section:Int) -> Any?
}

extension DataSourceProtocol {
    func numberOfSection() -> Int {
        return 0
    }
    
    func numberOfItems(forSection section : Int) -> Int {
        return 0
    }
    
    func viewModel(atIndexPath indexPath : IndexPath) -> Any? {
        return nil
    }
    
    func viewModelForHeader(for section:Int) -> Any? {
        return nil
    }
}

class AddMobileViewModel {
    
    private var title : String?
    private var items = [MobileItemViewModel]()
    private lazy var mobileManager = MobileManager()
    private var mobile : Mobile?
    
    init() {
        title = "Add Mobile"
        mobile = Mobile()
        createMobileItems()
    }
    
    func create(mobile:Mobile)  {
        self.mobile = mobile
    }
    
    func createMobileItems()  {
        
        let name = MobileItemViewModel(type: .name)
        name.responseBlock = {
            [weak self](sender) in
            guard let weakSelf = self else { return}
            if let theString = sender as? String {
                name.value = theString
                weakSelf.mobile?.name = theString
            }
        }
        items.append(name)
        
        let model = MobileItemViewModel(type: .model)
        model.responseBlock = {
            [weak self](sender) in
            guard let weakSelf = self else { return}
            if let theString = sender as? String {
                model.value = theString
                weakSelf.mobile?.model = theString
            }
        }
        items.append(model)
        
        let cost = MobileItemViewModel(type: .cost)
        cost.responseBlock = {
            [weak self](sender) in
            guard let weakSelf = self else { return}
            if let theString = sender as? String {
                cost.value = theString
                weakSelf.mobile?.cost = theString
            }
        }
        items.append(cost)
        
        let battery = MobileItemViewModel(type: .battery)
        battery.responseBlock = {
            [weak self](sender) in
            guard let weakSelf = self else { return}
            if let theString = sender as? String {
                battery.value = theString
                weakSelf.mobile?.battery = theString
            }
        }
        items.append(battery)
        
        let memory = MobileItemViewModel(type: .memory)
        memory.responseBlock = {
            [weak self](sender) in
            guard let weakSelf = self else { return}
            if let theString = sender as? String {
                memory.value = theString
                weakSelf.mobile?.memory = theString
            }
        }
        items.append(memory)
        
        let primaryCamera = MobileItemViewModel(type: .primary)
        primaryCamera.responseBlock = {
            [weak self](sender) in
            guard let weakSelf = self else { return}
            if let theString = sender as? String {
                primaryCamera.value = theString
                weakSelf.mobile?.primaryCamera = theString
            }
        }
        items.append(primaryCamera)
        
        let secondary = MobileItemViewModel(type: .secondary)
        secondary.responseBlock = {
            [weak self](sender) in
            guard let weakSelf = self else { return}
            if let theString = sender as? String {
                secondary.value = theString
                weakSelf.mobile?.secondaryCamera = theString
            }
        }
        items.append(secondary)
        
        let color = MobileItemViewModel(type: .color)
        color.responseBlock = {
            [weak self](sender) in
            guard let weakSelf = self else { return}
            if let theString = sender as? String {
                color.value = theString
                weakSelf.mobile?.color = theString
            }
        }
        items.append(color)
    }
    
    var titleString : String {
        return title ?? ""
    }
    
    var mobileData : Mobile? {
        return mobile
    }
    
    var isValid : Bool {
        
        var isValid : Bool = true
        for item in items {
            if item.checkValidity() == false {
                isValid = false
                break
            }
        }
        return isValid
        
    }
    
    func add (completion: @escaping (Result) -> Void) {
        
        if isValid == true {
            mobileManager.add(mobile: mobile, completion: {
                [weak self](responseData, error) in
                guard let weakSelf = self else { return }
                if let responseError = error {
                    completion(.failure("\(responseError.localizedDescription)"))
                }else if let _ = responseData as? Mobile{
                    weakSelf.clear()
                    completion(.success)
                }
            })
        } else {
            completion(.failure("All the fields should be filled"))
        }
    }
    
    func clear()  {
        mobile = nil
        mobile = Mobile()
        
        for item in items {
            item.clear()
        }
    }
}

extension AddMobileViewModel : DataSourceProtocol {
    
    func numberOfSection() -> Int {
        return items.count
    }
    
    func viewModel(atIndexPath indexPath: IndexPath) -> Any? {
        return items[safe : indexPath.row]
    }
    
}
