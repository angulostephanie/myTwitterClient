//
//  TweetsViewController.swift
//  TwitterApp
//
//  Created by Stephanie Angulo on 6/28/16.
//  Copyright © 2016 Stephanie Angulo. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll

class TweetsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet]!
    
    var initialLimit = 20
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        reloadTimeline()
        //creates refresh icon
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(refreshControl, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("tweetCell") as! TweetTableViewCell
        let tweet = self.tweets![indexPath.row]
        cell.tweet = tweet
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return tweets?.count ?? 0
    }
    
    func infiniteScroll() {
        tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            self.initialLimit += 20
            //self.loadPosts()
            if self.initialLimit > self.tweets?.count {
                self.initialLimit = (self.tweets?.count)!
            }
            tableView.reloadData()
            print("\(self.initialLimit) is now the limit")
            tableView.finishInfiniteScroll()
        }
    }
    func reloadTimeline() {
        TwitterClient.sharedInstance.homeTimeLine({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            for tweet in tweets {
                print(tweet.text)
                self.tableView.reloadData()
            }
        }) { (error: NSError) -> () in
            print(error.localizedDescription)
        }
    }
    func refreshControlAction(refreshControl: UIRefreshControl) {
        reloadTimeline()
        refreshControl.endRefreshing()
    }
    @IBAction func onLogout(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
