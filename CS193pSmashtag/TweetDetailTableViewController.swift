//
//  TweetDetailTableViewController.swift
//  CS193pSmashtag
//
//  Created by zzk on 2017/3/19.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import Twitter

class TweetDetailTableViewController: UITableViewController {
    
    private enum CellContent {
        case mention(Mention)
        case media(MediaItem)
        var associatedValue: Any {
            switch self {
            case .media(let mediaItem):
                return mediaItem
            case .mention(let mention):
                return mention
            }
        }
    }
    
    private enum SectionType {
        case image, users, urls, hashtags
    }

    private struct Section {
        var header: String?
        var contents: [CellContent]
        var type: SectionType
    }
    
    private var sections = [Section]()
    
    var tweet: Twitter.Tweet? {
        didSet {
            prepareInternalData()
            updateUI()
        }
    }
    
    func prepareInternalData() {
        sections.removeAll()
        
        func appendSectionData(title: String, mentions: [Mention], type: SectionType) {
            var sectionData = [CellContent]()
            for mention in mentions {
                sectionData.append(CellContent.mention(mention))
            }
            if sectionData.count > 0 {
                sections.append(Section.init(header: title, contents: sectionData, type: type))
            }
        }
        
        if let tweet = tweet {
            var mediaData = [CellContent]()
            for media in tweet.media {
                mediaData.append(CellContent.media(media))
            }
            sections.append(Section.init(header: nil, contents: mediaData, type: .image))
            
            appendSectionData(title: "Mentioned Users", mentions: tweet.userMentions, type: .users)
            appendSectionData(title: "Mentioned URLs", mentions: tweet.urls, type: .urls)
            appendSectionData(title: "Mentioned Hashtags", mentions: tweet.hashtags, type: .hashtags)
        }
    }
    
    func updateUI() {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: TableViewDataSource
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sections[indexPath.section].type == .image {
            if let media = sections[indexPath.section].contents[indexPath.row].associatedValue as? MediaItem {
                return view.frame.size.width / CGFloat(media.aspectRatio)
            }
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].contents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        let data = sections[indexPath.section].contents[indexPath.row]
        switch data {
        case .media(let mediaItem):
            cell = tableView.dequeueReusableCell(withIdentifier: "Tweet Detail Media Cell", for: indexPath)
            (cell as! ImageTableViewCell).setup(with: mediaItem)
        case .mention(let mention):
            cell = tableView.dequeueReusableCell(withIdentifier: "Tweet Detail Text Cell", for: indexPath)
            cell.textLabel?.text = mention.keyword
        }
      
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if sections[indexPath.section].type == .urls {
            if let mention = sections[indexPath.section].contents[indexPath.row].associatedValue as? Mention, let url = URL.init(string: mention.keyword) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show ImageViewController" {
            if let vc = segue.destination as? ImageViewController {
                // if image already downloaded use this image in new vc, if not set new vc's image url
                if let image = (sender as? ImageTableViewCell)?.customImageView.image {
                    vc.image = image
                } else {
                    vc.imageURL = (sender as? ImageTableViewCell)?.mediaItem?.url
                }
            }
        }
    }

}
