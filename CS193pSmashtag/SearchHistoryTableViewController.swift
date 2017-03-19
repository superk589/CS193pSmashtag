//
//  SearchHistoryTableViewController.swift
//  CS193pSmashtag
//
//  Created by zzk on 2017/3/19.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class SearchHistoryTableViewController: UITableViewController {
    
    
    var searchTerms = [SearchTerm]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTerms.removeAll()
        searchTerms.append(contentsOf: SearchHistoryManager.shared.getRecent(count: 100))
        tableView.reloadData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTerms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Search Term Cell", for: indexPath)
        cell.textLabel?.text = searchTerms[indexPath.row].keyword
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Search Result" {
            if let vc = segue.destination as? SmashTweetViewController {
                vc.searchText = (sender as? UITableViewCell)?.textLabel?.text
            }
        }
    }
}
