//
//  RssFeedTableViewController.swift
//  rss_reader
//
//  Created by Alex Kukareko on 28.03.16.
//  Copyright © 2016 iit. All rights reserved.
//

import SWXMLHash
import UIKit

class RssFeedTableViewController: UITableViewController, UISearchBarDelegate {
    
    
    
    var rssItems = [RssItem]()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchBar = UISearchBar()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        //self.definesPresentationContext = true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let url = NSURL(string: searchBar.text!)
        if (!UIApplication.sharedApplication().canOpenURL(url!)) {
            showAlert("Invalid URI!")
            return
        }
        loadRssFeedFromUrl(url!)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rssItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedItemCell", forIndexPath: indexPath) as! RssItemTableViewCell
        
        cell.setRssItem(rssItems[indexPath.row])
        
        return cell
    }

    func loadRssFeedFromUrl(url: NSURL) {
        self.rssItems.removeAll()
        self.tableView.reloadData()
        self.spinner.startAnimating()
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { data, response, error in
            
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.stopAnimating()
            })
            
            if error != nil {
                self.showAlert("Error request!")
                return
            }
            
            func pars(){
                let xml = SWXMLHash.parse(data!)
                
                do {
                    self.rssItems = try xml["rss"]["channel"]["item"].value()
                } catch XMLIndexer.XMLError {
                    self.showAlert("Error during parse rss!")
                } catch {
                    self.showAlert("Oops... something went wrong!")
                }
                
                self.tableView.reloadData()
                
            }
            
            dispatch_async(dispatch_get_main_queue(), pars)
            
        }
        task.resume()
    }
    
    func showAlert(message: String) {
        // create the alert
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .Alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "Close", style: .Cancel, handler: nil))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //showRssItem
        if segue.identifier != "showRssItem" {
            return
        }
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let destinationController = segue.destinationViewController as! RssItemViewController
            destinationController.srcUrl = rssItems[indexPath.row].link
            destinationController.descr = rssItems[indexPath.row].description
            destinationController.titl = rssItems[indexPath.row].title
        }
    }
 

}
