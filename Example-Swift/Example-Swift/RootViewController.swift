//
//  RootViewController.swift
//  Example-Swift
//
//  Created by Anton Morozov on 12/7/16.
//  Copyright © 2016 Anton Morozov. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController {

    @IBOutlet weak var searchField: UITextField!
    
    let suggestionsLoader = ZowdowSuggestionsLoader()
    var suggestionsContainer: ZowdowSuggestionsContainer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        ZowdowSDK.sharedInstance().appKey = "some key"
        
        searchField.autocapitalizationType = .none
        searchField.autocorrectionType = .no
        searchField.becomeFirstResponder()
        searchField.addTarget(self, action: #selector(textFieldDidChange(field:)), for: .editingChanged)
        
        suggestionsLoader.delegate = self
        
        self.tableView.rowHeight = 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    
    func textFieldDidChange(field: UITextField) {
        suggestionsLoader.loadSuggestions(forFragment: field.text)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
