//
//  NetworkManager.swift
//  Countries
//
//  Created by user on 12/03/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import PocketSVG
import WebKit

class DownloadManager: UIImageView {
    
    var imageDownloadSession = URLSession(configuration: .default)
    var imageDownloadTask : URLSessionDownloadTask?
    var catchedImage : NSCache<NSString, UIImage> = NSCache()
    
    
    // NOT Used: Download image
    
    func setImage(with urlForImage: String) {
        
        guard let urlFromString = URL(string: urlForImage) else{
            return
        }
        
        let urlRequest = URLRequest(url: urlFromString)
        
        if let image = self.catchedImage.object(forKey: urlForImage as NSString){
            self.image = image
            return
        }
        
        self.imageDownloadTask = self.imageDownloadSession.downloadTask(with: urlRequest) { (url, resonse, err) in
            
            var downLoadedimage : UIImage?
            do{
                
                let data = try? Data(contentsOf: url!)
                downLoadedimage = UIImage(data: data!)
                
            }catch{
                
            }
            
            DispatchQueue.main.async {
                let templateImage = downLoadedimage!.withRenderingMode(.alwaysTemplate)
                //self.catchedImage.setObject(downLoadedimage!, forKey: urlForImage as! NSString)
                self.image = templateImage
            }
        }
        
        self.imageDownloadTask?.resume()
    }
}


//Mark:- WKWebView to load SVG images.
extension WKWebView : WKNavigationDelegate {
    
    func loadSVGImage(imageUrl: URL){
        DispatchQueue.main.async {
            let request = NSURLRequest(url: imageUrl as URL)
            self.sizeToFit()
            self.navigationDelegate = self
            self.load(request as URLRequest)
        }
    }
    
    //MARK:- WKNavigationDelegate
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    private func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    private func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        print("finish to load")
    }
}
