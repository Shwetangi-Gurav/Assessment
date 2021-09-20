//
//  Site.swift
//  Assessment
//
//  Created by SensiBolApple on 20/09/21.
//

import Foundation

class Site {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    class func urlList() -> [Site] {
        var sites: [Site] = []
        let urls = [ "apple.com", "spacex.com", "dapi.co", "facebook.com", "microsoft.com","amazon.com", "boomsupersonic.com", "twitter.com", "pipsnacks"]
        for i in 0..<urls.count {
            sites.append(Site.init(name: urls[i]))
        }
        return sites
    }
}
