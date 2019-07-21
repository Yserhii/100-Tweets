//
//  APIController.swift
//  D04
//
//  Created by Yolankyi SERHII on 6/28/19.
//  Copyright © 2019 Yolankyi SERHII. All rights reserved.
//

import Foundation

protocol APITwitterDelegate : class {
    func receiveTweets (tweets: [Tweet])
    func errorTweets (error: NSError)
}

class APIController {
    weak var delegate : APITwitterDelegate?
    let token : String
    
    init(delegate: APITwitterDelegate?, token: String) {
        self.delegate = delegate
        self.token = token
    }
    
    func get_tweet(search: String) {
        let url = NSURL(string: "https://api.twitter.com/1.1/search/tweets.json?" + search)
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                DispatchQueue.main.async(execute: {
                    self.delegate?.errorTweets(error: error! as NSError)
                })
                return
            }
            
            let d = data
            do {
                var tweets: [Tweet] = []
                if let resp: NSDictionary = try JSONSerialization.jsonObject(with: d!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    if let statuses: [NSDictionary] = resp["statuses"] as? [NSDictionary] {
                        for status in statuses {
                            let name = (status["user"] as? NSDictionary)?["name"] as? String
                            let text = status["text"] as? String
                            let date = status["created_at"] as? String
                            if (name != nil) && (text != nil) && (date != nil) {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
                                if let date = dateFormatter.date(from: date!) {
                                    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                                    let newDate = dateFormatter.string(from: date)
                                    tweets.append(Tweet(name: name!, text: text!, date: newDate))
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.delegate?.receiveTweets(tweets: tweets)
                        }
                    }
                }
            } catch (let err){
                DispatchQueue.main.async(execute: {
                    self.delegate?.errorTweets(error: err as NSError)
                })
                return
            }
            
        }
        task.resume()
    }
}

