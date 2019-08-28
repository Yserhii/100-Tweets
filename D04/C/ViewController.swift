//
//  ViewController.swift
//  D04
//
//  Created by Yolankyi SERHII on 6/28/19.
//  Copyright © 2019 Yolankyi SERHII. All rights reserved.
//

import UIKit

class ViewController: UIViewController, APITwitterDelegate, UISearchBarDelegate {

    func receiveTweets(tweets: [Tweet]) {
        self.tweets = tweets
        tweetTableView.reloadData()
    }
    
    func errorTweets(error: NSError) {
        print(error)
    }
    
    @IBOutlet weak var tweetTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var tweets: [Tweet] = []
    var token: String = ""
    let query:String = "&src=typd&lang=en&count=100&result_type=recent"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.text = "school 42"
        tweetTableView.dataSource = self
        
        let CUSTOMER_KEY = "FHCn8ZGPKvCkCsphNFhRoAxKh"
        let CUSTOMER_SECRET = "mFRWU8DfOlR4T1XkgiwFplwYfrC6qQdtrBYnT6SHlt0Kpreqfc"
        let BEARED = ((CUSTOMER_KEY + ":" + CUSTOMER_SECRET).data(using: String.Encoding.utf8))!.base64EncodedString()
        
        let url = NSURL(string: "https://api.twitter.com/oauth2/token")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + BEARED, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;CHARSET=UTF-8", forHTTPHeaderField: "Content-type")
        request.setValue("29", forHTTPHeaderField: "Content-lengt")
        request.setValue("gzip", forHTTPHeaderField: "Accept-encoding")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil  {
                print(error!.localizedDescription)
                return
            }
            if let d = data {
                 do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d) as? NSDictionary {
                        for (key, value) in dic {
                            if key as! String == "access_token" {
                                self.token = value as! String
                            }
                    }
                        let controller = APIController(delegate: self, token: self.token)
                        controller.get_tweet(search: "q=" + "school 42".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! + self.query)
                        
                    }
                    
                 } catch (let err) {
                    print(err)
                    return
                }
            }
        }
        task.resume()
        
        self.tweetTableView.rowHeight = UITableView.automaticDimension
        self.tweetTableView.estimatedRowHeight = 140
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil {
            tweets = []
            let controller = APIController(delegate: self, token: token)
            controller.get_tweet(search: "q=" + searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! + query)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count \(tweets.count)")
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tweetTableView.dequeueReusableCell(withIdentifier: "tableviewcell", for: indexPath) as! TableViewCell
        
        cell.sizeToFit()
        cell.layoutIfNeeded()
        
        cell.name.text = tweets[indexPath.row].name
        cell.date.text = tweets[indexPath.row].date
        cell.desc.text = tweets[indexPath.row].text
        
        return cell
    }
}
