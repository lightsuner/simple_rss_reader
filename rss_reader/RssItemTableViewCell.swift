//
//  RssItemTableViewCell.swift
//  rss_reader
//
//  Created by Alex Kukareko on 29.03.16.
//  Copyright © 2016 iit. All rights reserved.
//

import UIKit

class RssItemTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLeftConstraint: NSLayoutConstraint!
    var defaultImgWidthConstVal: CGFloat? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if (self.defaultImgWidthConstVal == nil) {
            self.defaultImgWidthConstVal = self.imageWidthConstraint.constant
        }
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setRssItem(rssItem: RssItem) {
        title.text = rssItem.title
        
        self.imageWidthConstraint.constant = 0
        if (rssItem.thumbnail != nil) {
            ImageLoader.sharedLoader.imageForUrl(rssItem.thumbnail!, completionHandler:{(image: UIImage?, url: String) in
                if (image == nil) {
                    return
                }
                
                self.imageWidthConstraint.constant = self.defaultImgWidthConstVal!
                self.img.image = image!
                self.img.layer.cornerRadius = 10
                self.img.clipsToBounds = true
                self.setNeedsLayout()
                self.layoutSubviews()
            })
        }
        
    }
    
    func loadImageFromUrl(url: String){
        
        // Create Url from string
        let url = NSURL(string: url)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                // execute in UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.img.image = UIImage(data: data)
                })
            }
        }
        
        // Run task
        task.resume()
    }

}
