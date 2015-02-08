//
//  DetailsViewController.swift
//  code1RotTomatoes
//
//  Created by Michael Winter on 2/5/15.
//  Copyright (c) 2015 com.codepath. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var synLabel: UILabel!
    @IBOutlet weak var ratings: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var movieTableIndex = MovieMetaData.index
        titleLabel.text = MovieMetaData.tableData[movieTableIndex].title
        synLabel.text = MovieMetaData.tableData[movieTableIndex].synopsis
        ratings.text = MovieMetaData.tableData[movieTableIndex].rating
        fetchBigPhotoFromServer(movieTableIndex)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // Get full size poster images
    func fetchBigPhotoFromServer(index: Int)
    {
        if index < MovieMetaData.tableData.count
        {
            var urlString = MovieMetaData.tableData[MovieMetaData.index].posterURL
            urlString = urlString.stringByReplacingOccurrencesOfString("_tmb", withString: "_ori")
            var imgURL: NSURL = NSURL(string: urlString)!
            // Download an NSData representation of the image at the URL
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,dataImg: NSData!,error: NSError!) -> Void in
                    if error == nil   // If no error, store image in dictionary cache
                    {
                        var imageFromServer = UIImage(data: dataImg)
                        self.posterImage.image = imageFromServer
                    }
                    else
                    {
                        println("tableView Error : \(error.localizedDescription)")
                    }
                })
        }
    }

}
