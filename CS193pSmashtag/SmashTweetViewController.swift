//
//  SmashTweetViewController.swift
//  CS193pSmashtag
//
//  Created by zzk on 2017/3/18.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class SmashTweetViewController: TweetTableViewController {
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func insertTweets(_ newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets)
        updateDatabase(with: newTweets)
    }
   
    func updateDatabase(with tweets: [Twitter.Tweet]) {
        print("starting database load")
        container?.performBackgroundTask({ [weak self] (context) in
            for twitterInfo in tweets {
                // add tweet 
                _ = try? Tweet.findOrCreateTweet(matching: twitterInfo, in: context)
                
            }
            try? context.save()
            print("done loading database")
            self?.printDatabaseStatistics()
        })
    }
    
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            context.perform {
                if Thread.isMainThread {
                    print("is main thread")
                } else {
                    print("off main thread")
                }
                if let tweetCount = (try? context.fetch(Tweet.fetchRequest()))?.count {
                    print("\(tweetCount) tweets in database")
                }
                if let tweeterCount = try? context.count(for: TwitterUser.fetchRequest()) {
                    print("\(tweeterCount) tweeters in database")
                }                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Tweeters Mentioning Search Term" {
            if let vc = segue.destination as? SmashTweetersTableViewController {
                vc.mention = searchText
                vc.container = container
            }
        } else if segue.identifier == "Tweet Detail" {
            if let vc = segue.destination as? TweetDetailTableViewController,
                let cell = sender as? TweetTableViewCell {
                vc.tweet = cell.tweet
            }
        }
    }
}
