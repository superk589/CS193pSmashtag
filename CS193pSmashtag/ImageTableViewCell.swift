//
//  ImageTableViewCell.swift
//  CS193pSmashtag
//
//  Created by zzk on 2017/3/19.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import Twitter

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var customImageView: UIImageView!
    
    var mediaItem: MediaItem?
    
    func setup(with item: MediaItem) {
        self.mediaItem = item
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data.init(contentsOf: item.url) {
                let image = UIImage.init(data: data)
                DispatchQueue.main.async { [weak self] in
                    if item.url == self?.mediaItem?.url {
                        self?.customImageView.image = image
                    }
                }
            }
        }
    }
}
