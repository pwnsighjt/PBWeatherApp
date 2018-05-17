//
//  Response.swift
//  PBWeather
//
//  Created by Pawan Jat on 17/05/18.
//  Copyright © 2018 PB. All rights reserved.
//

import Foundation


class YQL {
    //MARK:- QUERY TO GET WEATHER FORECAST
    private let QUERY_PREFIX = "http://query.yahooapis.com/v1/public/yql?q="
    private let QUERY_SUFFIX = "&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
    
    public func query(_ statement:String, completion: @escaping ([String:AnyObject]) -> Void) {
        let url = URL(string: "\(QUERY_PREFIX)\(statement.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)\(QUERY_SUFFIX)")
        
        let task = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                do {
                    let dataDict = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    let results:[String: Any] = dataDict!
                    completion(results as [String : AnyObject])
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    //MARK:- QUERY TO GET WOEID FOR SELECTION LOCATION
    private let QUERY_PREFIX_WOEID = "https://query.yahooapis.com/v1/public/yql?q="
    private let QUERY_SUFFIX_WOEID = "&limit%201&diagnostics=false&format=json"
    
    public func queryWoeid(_ statementOne:String, completion: @escaping ([String:AnyObject]) -> Void) {
        let url = URL(string: "\(QUERY_PREFIX_WOEID)\(statementOne.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)\(QUERY_SUFFIX_WOEID)")
        
        let task = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                do {
                    let dataDict = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    completion(dataDict! as [String : AnyObject])
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
}
