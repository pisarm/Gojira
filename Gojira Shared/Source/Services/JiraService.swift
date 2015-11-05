//
//  JiraService.swift
//  Gojira
//
//  Created by Flemming Pedersen on 24/10/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

final class JiraService {
    static let sharedInstance = JiraService()

    private var session: NSURLSessionDataTask?
    private var authValue = ""
    private let authField = "Authorization"
    private var baseURL = ""
    private let totalKey = "total"

    func refreshTotal(query: String, completion: (total: Int?) -> Void) {
        guard let encodedQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet()),
            URL = NSURL(string: baseURL + encodedQuery)
            else {
                return
        }

        let request = NSMutableURLRequest(URL: URL)
        request.addValue(authValue, forHTTPHeaderField: authField)

        session?.cancel()
        session = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, _, _ in
            guard let data = data else {
                return
            }

            let total = JSON(data: data)[self.totalKey].intValue

            completion(total: total)
        }
        
        session?.resume()
    }
}