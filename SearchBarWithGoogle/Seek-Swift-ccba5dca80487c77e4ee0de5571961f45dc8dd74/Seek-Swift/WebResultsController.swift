//
//  WebResults.swift
//  Seek-Swift
//
//  Created by Jamie Smith on 6/7/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

import UIKit

class WebResultsController: RootViewController {
    @IBOutlet var tableView: UITableView
    var query: String!
    var results: WebResult[]?
    @lazy var searchAPI = SearchAPI()
    
    class func resultsControllerWithQuery(query: String) -> WebResultsController {
        let resultsController = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier("WebResultsController") as WebResultsController
        resultsController.query = query
        return resultsController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchResultsWithQuery(query)
        navigationController.delegate = self
    }
    
    func fetchResultsWithQuery(query: String) {
        searchAPI.searchWithQuery(query) { response in
            
            switch(response) {
            case .Error(let error):
                println(error)
            case .Results(let searchResults):
                self.results = searchResults
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func showWebViewWithURL(URL: NSURL) {
        let webController = WebController.webControllerWithURL(URL)
        navigationController.pushViewController(webController, animated: true)
    }
    
}

extension WebResultsController: UITableViewDataSource, UITableViewDelegate {
    
    // Data Source
    // ----------------------------------
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return results ? results!.count : 0
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        return cellForIndexPath(indexPath)
    }
    
    // Delegate
    // ----------------------------------
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let cell = cellForIndexPath(indexPath)
        return cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + 1.0
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let result = results![indexPath.row]
        showWebViewWithURL(result.URL)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // Helpers
    // ----------------------------------
    func cellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        let cell: WebResultCell = self.tableView.dequeueReusableCellWithIdentifier("WebResultCell") as WebResultCell
        cell.configureForWebResult(results![indexPath.row])
        return cell
    }
}