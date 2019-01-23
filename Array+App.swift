//
//  Array+App.swift
//  BusSeat
//
//  Created by sunil on 15/01/19.
//  Copyright © 2019 sunil. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
