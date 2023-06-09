//
//  UIImageView + Extension.swift
//  Weather_App_942142
//
//  Created by Drisya Sudevan on 08/06/23.
//

import Foundation
import UIKit

//MARK: Downloading caching image
class CustomImageView: UIImageView {

    let imgCache = NSCache<NSString, AnyObject>()
    var imageURLString: String?

    func downloadImageFrom(urlString: String, imageContentMode: UIView.ContentMode) {
        guard let url = URL(string: urlString) else { return }
        downloadImageFrom(url: url, imageContentMode: imageContentMode)
    }

    func downloadImageFrom(url: URL, imageContentMode: UIView.ContentMode) {
        contentMode = imageContentMode
        if let cachedImage = imgCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = cachedImage
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    sleep(2)
                    let imageToCache = UIImage(data: data)
                    
                    //add image to cache
                    if let img = imageToCache {
                        self.imgCache.setObject(img, forKey: url.absoluteString as NSString)
                        
                        self.image = imageToCache
                    }
                    else {
                        self.image = UIImage(named: "placeholder-square")
                    }
                }
            }.resume()
        }
    }
}
