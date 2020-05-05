//
//  media.swift
//  itunes
//
//  Created by Argueta, Adan on 5/4/20.
//  Copyright © 2020 Argueta, Adan. All rights reserved.
//

import ObjectMapper

class Media: Mappable {
    var mediaType: String?
    var name: String?
    var artistName: String?
    var trackId: Int = 0
    var artworkUrl : String?
    var previewURL : String?

    // MARK: Mappable
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        mediaType <- map["kind"]
        name <- map["trackName"]
        artistName <- map["artistName"]
        trackId <- map["trackId"]
        artworkUrl <- map["artworkUrl100"]
        previewURL <- map["previewUrl"]
    }
    
}

