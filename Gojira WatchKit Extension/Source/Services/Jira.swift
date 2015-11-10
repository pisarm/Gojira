//
//  JiraService.swift
//  Gojira
//
//  Created by Flemming Pedersen on 24/10/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import Foundation

enum EndPointType {
    case Favourite
    case Search(String)

    func urlString() -> String {
        switch self {
        case .Favourite:
            return "/filter/favourite"
        case let .Search(jql):
            return "/search?jql=\(jql)"
        }
    }
}

struct EndPoint {
    let baseURL: String
    let type: EndPointType

    func endPointURL() -> NSURL? {
        let urlString = baseURL + "/rest/api/2" + type.urlString()

        guard let encodedURLString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet()),
            url = NSURL(string: encodedURLString)
            else {
                return nil
        }

        return url
    }
}

struct BasicAuth {
    let username: String
    let password: String

    func authValue() -> String? {
        guard let dataToEncode = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding) else {
            return nil
        }

        return "Basic \(dataToEncode.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)))"
    }
}

private enum HTTPHeaderField: String {
    case Authorization
}

final class Jira {
    private var session: NSURLSessionDataTask?

    //MARK: Fetch
    func fetchFilterData(baseURL: String, basicAuth: BasicAuth, completion: (data: NSData?) -> Void) {
        guard let
            url = EndPoint(baseURL: baseURL, type: .Favourite).endPointURL(),
            authValue = basicAuth.authValue()
            else {
                completion(data: nil)
                return
        }

        fetch(url, authValue: authValue, completion: completion)
    }

    func fetchTotal(jql: String, baseURL: String, basicAuth: BasicAuth, completion: (data: NSData?) -> Void) {
        guard let
            url = EndPoint(baseURL: baseURL, type: .Search(jql)).endPointURL(),
            authValue = basicAuth.authValue()
            else {
                completion(data: nil)
                return
        }

        fetch(url, authValue: authValue, completion: completion)
    }

    //MARK: Internal 
    private func fetch(url: NSURL, authValue: String, completion: (data: NSData?) -> Void) {
        let request = NSMutableURLRequest(URL: url)
        request.addValue(authValue, forHTTPHeaderField: HTTPHeaderField.Authorization.rawValue)

        session?.cancel()
        session = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, _, _ in
            completion(data: data)
        }
        session?.resume()
    }
}
