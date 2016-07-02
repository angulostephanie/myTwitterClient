//
//  TweetsViewController.swift
//  TwitterApp
//
//  Created by Stephanie Angulo on 6/28/16.
//  Copyright © 2016 Stephanie Angulo. All rights reserved.
//

import UIKit


class TweetsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet]? = []
    
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
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        self.navigationController!.navigationBar.tintColor = UIColor.colorFromHex("#FFCC00")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("tweetCell") as! TweetTableViewCell
        let tweet = self.tweets![indexPath.row]
        cell.tweet = tweet
        cell.profileImageButton.tag = indexPath.row
        cell.accessoryType = UITableViewCellAccessoryType.None
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return tweets?.count ?? 0
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
   
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "detailsSegue") {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![(indexPath?.row)!]
            let detailViewController = segue.destinationViewController as! TweetDetailsViewController
            detailViewController.tweet = tweet
            print("prepare for segue has been called")
        }
        if (segue.identifier == "OtherProfileSegue"){
            let user = tweets![sender!.tag].user
            let detailViewController = segue.destinationViewController as! OthersProfilesViewController
            detailViewController.user = user
            print("prepare for segue has been called")
        }
        
        
        

    }
    

}
