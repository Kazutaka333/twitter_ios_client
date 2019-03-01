//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Kazutaka Homma on 2/28/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()
//    var numberOfTweet: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()
    }
    
    func loadTweet() {
        let tweetsUrlString = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let parameters = ["count": 10]
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetsUrlString, parameters: parameters, success:
            {(tweets: [NSDictionary]) in
                self.tweetArray.removeAll()
                for tweet in tweets {
                    self.tweetArray.append(tweet)
                }
                self.tableView.reloadData()
        }, failure: { (error) in
            print("Could not retreive tweets")
        })
    }

    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        dismiss(animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as? TweetCell else {
            fatalError("Failed casting cell")
        }
        if let user = tweetArray[indexPath.row]["user"] as? [String : Any] {
            cell.userNameLabel.text = user["name"] as? String
            if  let imageUrlString = user["profile_image_url_https"] as? String,
                let url = URL(string: imageUrlString),
                let data = try? Data(contentsOf: url) {
                cell.profileImageView.image = UIImage(data: data)
            }
        }
        
        cell.tweetContentLabel.text = tweetArray[indexPath.row]["text"] as? String

        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

}
