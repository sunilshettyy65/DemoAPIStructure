//
//  AdvanceSearchDetailViewController.swift
//  SkillsView
//
//  Created by Sunil Kumar Y on 12/02/18.
//  Copyright © 2018 Sunil Kumar Y. All rights reserved.
//

import UIKit

class AdvanceSearchDetailViewController: SkillsBaseViewController {
    
    @IBOutlet weak var selctedItemViewHieghtConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectedItemViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectedRegionsTableView: UITableView!
    @IBOutlet weak var selectedItemBackgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var viewHeightLayoutConstraint: NSLayoutConstraint!
    var viewModel: AdvancedSearchViewModelRegionItem!
    
    var searchString: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCell(cell : SearchItemCell.self)
        selectedRegionsTableView.registerCell(cell : SearchItemCell.self)
        tableView.registerHeaderFooterView(view: SearchItemHeader.self)
        selectedRegionsTableView.registerHeaderFooterView(view: SelectedItemHeader.self)
        setUpSearchBar()
        reloadDataSource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        makeInitalSettings()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
//        }, completion: { [weak self](UIViewControllerTransitionCoordinatorContext) -> Void in
//            self?.view.endEditing(true)
//            self?.setUpSearchBar()
//        })
//       view.endEditing(true)
//    }
    
    func makeInitalSettings() {
        StyleSheet.applyShadowEffectFor(view: selectedItemBackgroundView)
        viewModel.searchActive = false
        viewModel.setPreviousSelectedItemsList()
        searchBar.text = ""
        searchString = ""
        setUpSearchBar()
        viewModel.searchActive = false
        viewModel.setRecentlyUsedFlag()
        fetchData()
        if viewModel.itemSelectionCompletion == nil {
            viewModel.itemSelectionCompletion = {
                [weak self] () -> Void in
                self?.reloadDataSource()
            }
        }
    }
    
//    func setSearchPositionForString() {
//        let string = searchString
//        let fontAttributes = [NSAttributedStringKey.font: UIFont.svmTextStyleRegular14]
//        let size = (string as NSString).size(withAttributes: fontAttributes)
//        let fontAttributesPlaceHolder = [NSAttributedStringKey.font: UIFont.svmTextStyleRegular14]
//        let sizePlaceHolder = ("Search" as NSString).size(withAttributes: fontAttributesPlaceHolder)
//        let maxWidth = self.view.frame.width
//        let resultWidth = (self.view.frame.width/2.0) - sizePlaceHolder.width - (size.width / 2.0)
//        if resultWidth >= 0 && resultWidth <= maxWidth {
//            searchBar.setPositionAdjustment(UIOffset(horizontal: resultWidth, vertical: 0), for: .search)
//            searchBar.layoutIfNeeded()
//        } else {
//            searchBar.setPositionAdjustment(UIOffset(horizontal: 0, vertical: 0), for: .search)
//            searchBar.layoutIfNeeded()
//        }
//    }
    
    func setUpSearchBar() {
        DispatchQueue.main.async {
            let textFieldOfSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField
            textFieldOfSearchBar?.font = UIFont.svmTextStyleRegular14
            let textFieldInsideSearchBarLabel = textFieldOfSearchBar!.value(forKey: "placeholderLabel") as? UILabel
            textFieldInsideSearchBarLabel?.font = UIFont.svmTextStyleRegular14
           // self.setSearchPositionForString()
            if Utility.isIPad() {
                self.viewHeightLayoutConstraint.constant = 0.0
            } else {
             self.viewHeightLayoutConstraint.constant = 0.0
           //  self.searchBar.searchBarStyle = .minimal
            }
        }
    }
    
    func fetchData() {
        if !AppModule.shared.isNetworkAvailable() {
            networkNotAvailable()
            return
        }
        self.showHUD()
        viewModel.getRegion { [weak self](result) in
            guard let weakSelf = self else {
                self?.hideHUD()
                return
            }
            DispatchQueue.main.async {
                weakSelf.heightandBottomConstraintforSelectedItemView()
                weakSelf.reloadDataSource()
                weakSelf.hideHUD()
            }
        }
    }

    override func networkAvailableAfterRetry() {
        fetchData()
    }
    
    func reloadDataSource() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.selectedRegionsTableView.reloadData()
            self.heightandBottomConstraintforSelectedItemView()
        }
    }
    
    func heightandBottomConstraintforSelectedItemView() {
        selctedItemViewHieghtConstraint.constant = viewModel.getHeightForSelectedItems()
    }
    
}

extension AdvanceSearchDetailViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView ==  self.tableView ? viewModel.count : viewModel.selectedItemList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchItemCell = tableView.dequeueReuseableCell(for: indexPath)
        let item = (tableView ==  self.tableView) ? viewModel.getItem(row: indexPath.row) :viewModel.getSelectedItem(row: indexPath.row)
        cell.item = item
        cell.selectedImageView.isHidden = viewModel.isSelectedItem(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView ==  self.tableView {
            let headerView: SearchItemHeader = tableView.dequeueReuseableHeaderFooterView()
            headerView.headerTitle.text = viewModel.headerText
            headerView.contentView.backgroundColor = UIColor.white
            return headerView
        } else {
            let headerView: SelectedItemHeader = tableView.dequeueReuseableHeaderFooterView()
            headerView.contentView.backgroundColor = UIColor.white
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView ==  self.tableView ? viewModel.headerHeight: 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = (tableView ==  self.tableView) ? viewModel.getItem(row: indexPath.row) :viewModel.getSelectedItem(row: indexPath.row)
        self.viewModel.setSelectedItem(item)
        self.tableView.reloadData()
        self.heightandBottomConstraintforSelectedItemView()
        self.selectedRegionsTableView.reloadData()
        self.view.endEditing(true)
    }
    
}

extension AdvanceSearchDetailViewController: UIScrollViewDelegate {

   
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}



extension AdvanceSearchDetailViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.isRecentlyUsedSelected = false
        self.tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        viewModel.searchActive = false
//        viewModel.setRecentlyUsedFlag()
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchActive = true
        viewModel.setFilteredItems(searchText: searchText)
        searchString = searchText
     //   setSearchPositionForString()
        self.tableView.reloadData()
    }
    
    
}

