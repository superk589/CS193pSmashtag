//
//  TweetTableViewCell.swift
//  CS193pSmashtag
//
//  Created by zzk on 2017/3/18.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLable: UILabel!
    
    var tweet: Twitter.Tweet? { didSet {updateUI() } }
    
    private func updateUI() {
        if let tweet = tweet {
            let attributeText = NSMutableAttributedString(string: tweet.text)
            for mention in tweet.userMentions {
                attributeText.addAttributes([NSForegroundColorAttributeName: UIColor.brown], range: mention.nsrange)
            }
            for mention in tweet.hashtags {
                attributeText.addAttributes([NSForegroundColorAttributeName: UIColor.green], range: mention.nsrange)
            }
            for mention in tweet.urls {
                attributeText.addAttributes([NSForegroundColorAttributeName: UIColor.blue], range: mention.nsrange)
            }
            
            tweetTextLable.attributedText = attributeText
        }
        
        tweetUserLabel.text = tweet?.user.description
        
        tweetProfileImageView.image = nil
        if let profileImageURL = tweet?.user.profileImageURL {
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                if let imageData = try? Data(contentsOf: profileImageURL) {
                    DispatchQueue.main.async {
                        if profileImageURL == self?.tweet?.user.profileImageURL {
                            self?.tweetProfileImageView.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        } else {
            tweetProfileImageView.image = nil
        }
        
        if let created = tweet?.created {
            let formatter = DateFormatter.init()
            if Date().timeIntervalSince(created) > 24 * 60 * 60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel.text = nil
        }
    }
    
}
