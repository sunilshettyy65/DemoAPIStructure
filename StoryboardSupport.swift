//
//  StoryboardSupport.swift
//  SkillsView
//
//  Created by Sunil Kumar Y on 29/01/18.
//  Copyright © 2018 Sunil Kumar Y. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UITableViewCell {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension StoryboardIdentifiable where Self: UITableViewHeaderFooterView {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: StoryboardIdentifiable { }

extension UITableViewHeaderFooterView: StoryboardIdentifiable { }

extension UITableView {

    func dequeueReuseableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.storyboardIdentifier, for: indexPath) as? T else {
            fatalError("Could not find table view cell with identifier \(T.storyboardIdentifier)")
        }
        return cell
    }
    
    func dequeueReuseableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let cell = self.dequeueReusableHeaderFooterView(withIdentifier:  T.storyboardIdentifier) as? T else {
            fatalError("Could not find table view cell with identifier \(T.storyboardIdentifier)")
        }
        return cell
    }
    
    
    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(view: T.Type) {
        register(UINib(nibName: view.storyboardIdentifier, bundle : nil), forHeaderFooterViewReuseIdentifier: view.storyboardIdentifier)
    }
    
    func registerCell<T: UITableViewCell>(cell: T.Type) {
        register(UINib(nibName: T.storyboardIdentifier, bundle : nil), forCellReuseIdentifier: T.storyboardIdentifier)
    }
    
    func dequeueReuseableCellForIpad<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.storyboardIdentifier + "IPad", for: indexPath) as? T else {
            fatalError("Could not find table view cell with identifier \(T.storyboardIdentifier)")
        }
        return cell
    }
    
    func cellForRow<T: UITableViewCell>(at indexPath: IndexPath) -> T {
        guard let cell = cellForRow(at: indexPath) as? T else {
            fatalError("Could not get cell as type \(T.self)")
        }
        return cell
    }
}
