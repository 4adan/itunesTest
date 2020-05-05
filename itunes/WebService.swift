//
//  WebService.swift
//  itunes
//
//  Created by Argueta, Adan (CHICO-C) on 5/4/20.
//  Copyright © 2020 Argueta, Adan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

class WebService: NSObject {

    class func requestGETURL(_ strURL: String, success:@escaping (AFDataResponse<Any>) -> Void, failure:@escaping (Error) -> Void) {
        AF.request(strURL).responseJSON { (responseObject) -> Void in
            print(responseObject)
            if let error = responseObject.error {
                failure(error)
            } else {
                success(responseObject)
            }
        }
    }
    
    func fetchItunesResultsFor(query: String, success:@escaping (Dictionary<String,[Media]>) -> Void, failure:@escaping (Error) -> Void) {
        let url = "https://itunes.apple.com/search?term=" + query
        WebService.requestGETURL(url, success: {
        (JSONResponse) -> Void in
            let jsonObject = JSON(JSONResponse.value!).dictionary
            let results = jsonObject?["results"]?.array
            var dict = Dictionary<String,[Media]> ()
            
            for object in results! {
                
                if let med = Media(JSONString: object.rawString()!) {
                    if var array = dict[med.mediaType ?? "no media type"] {
                        array.append(med)
                        dict[med.mediaType ?? "no media type"] = array
                    } else {
                        dict[med.mediaType ?? "no media type"] = [med]
                    }
                }
            }
            success(dict)
            
        }, failure:{(error) -> Void in
            failure(error)
        })
    }
}
