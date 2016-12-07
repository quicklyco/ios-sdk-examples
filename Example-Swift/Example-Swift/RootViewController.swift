//
//  RootViewController.swift
//  Example-Swift
//
//  Created by Anton Morozov on 12/7/16.
//  Copyright © 2016 Anton Morozov. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController {
    
    let suggestionsLoader = ZowdowSuggestionsLoader()
    var suggestionsContainer: ZowdowSuggestionsContainer?
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ZowdowSDK.sharedInstance().appKey = "some key"
        
        updateSearchBar()
        
        suggestionsLoader.delegate = self
        
        self.tableView.rowHeight = 100
    }

    // MARK: -
    
    func updateSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let contatiner = self.suggestionsContainer else {
            return 0
        }
        return contatiner.suggestionsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let contatiner = suggestionsContainer {
            let config = ZowdowSuggestionCellConfiguration.default()
            if let cell = contatiner.cell(for: tableView, at: indexPath, configuration: config, cardsCarouselType: ZowdowLinearBCarouselType) {
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension RootViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        suggestionsLoader.loadSuggestions(forFragment: searchText)
    }
}

extension RootViewController: ZowdowSuggestionsLoaderDelegate {
    
    func zowdowSuggestionsLoader(_ loader: ZowdowSuggestionsLoader!, didReceiveSuggestions container: ZowdowSuggestionsContainer!) {
        self.suggestionsContainer = container
        self.tableView.reloadData()
    }
    
    func zowdowSuggestionsLoader(_ loader: ZowdowSuggestionsLoader!, didFailWithError error: Error!) {
        guard let error = error else {
            return
        }
        print("Error", error.localizedDescription)
    }
}
