//
//  RssItem.swift
//  rss_reader
//
//  Created by Alex Kukareko on 28.03.16.
//  Copyright © 2016 iit. All rights reserved.
//

import Foundation
import SWXMLHash

struct RssItem: XMLIndexerDeserializable {
    let title: String
    let link: String
    let description: String
    let thumbnail: String?
    
    static func deserialize(node: XMLIndexer) throws -> RssItem {
        var thumbnail: String? = nil
        if let contentElement = node["media:content"][0].element?.attributes["url"] {
            thumbnail = contentElement
        } else {
            if let thumbElement = node["media:thumbnail"].element?.attributes["url"] {
                thumbnail = thumbElement
            }
        }
    
        return try RssItem(
            title: node["title"].value(),
            link: node["link"].value(),
            description: node["description"].value(),
            thumbnail: thumbnail
        )
    }
}