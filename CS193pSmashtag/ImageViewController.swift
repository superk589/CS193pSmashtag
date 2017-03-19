//
//  ImageViewController.swift
//  CS193pCassini
//
//  Created by zzk on 2017/3/6.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.maximumZoomScale = 1
            scrollView.minimumZoomScale = 0.03
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    fileprivate var imageView = UIImageView()
    
    var imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data.init(contentsOf: url)
                if let imageData = urlContents, url == self?.imageURL {
                    DispatchQueue.main.async {
                        self?.image = UIImage.init(data: imageData)
                    }
                }
            }
        }
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}


// Auto fit image view in the center
extension ImageViewController {
    private var offset: CGPoint {
        if scrollView != nil {
            var x = scrollView.bounds.origin.x
            var y = scrollView.bounds.origin.y
            
            if scrollView.contentSize.width > scrollView.frame.width {
                x = (scrollView.contentSize.width - scrollView.frame.width) / 2
            } else {
                y = (scrollView.contentSize.height - scrollView.frame.height) / 2
            }
            return CGPoint.init(x: x, y: y)
        }
        return CGPoint.zero
    }
    
    private var aspectRatio: CGFloat {
        if let image = image {
            return image.size.width / image.size.height
        }
        return 1
    }
    
    private var zoomScale: CGFloat {
        if let scrollView = scrollView, let image = image {
            let zoomToWidth = scrollView.frame.width / image.size.width
            let zoomToHeight = (scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom) / image.size.height
            
            if aspectRatio < scrollView.frame.width / scrollView.frame.height {
                scrollView.minimumZoomScale = zoomToHeight
                scrollView.maximumZoomScale = zoomToWidth * 2
                return zoomToWidth
            } else {
                scrollView.minimumZoomScale = zoomToWidth
                scrollView.maximumZoomScale = zoomToHeight * 2
                return zoomToHeight
            }
        }
        return 1
    }
    
    private func adjustImageView() {
        imageView.sizeToFit()
        scrollView?.contentSize = imageView.frame.size
        scrollView?.zoomScale = zoomScale
        scrollView?.contentOffset = offset
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        adjustImageView()
    }
}
