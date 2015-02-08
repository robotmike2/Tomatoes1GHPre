//
//  tableViewMovieClass.swift
//  code1RotTomatoes
//
//  Created by Michael Winter on 2/3/15.
//  Copyright (c) 2015 com.codepath. All rights reserved.
//


import UIKit

struct MovieMetaData {
    static var index = 0
    static var moviesArray: NSArray?
    static var tableData = [RotMovieData]()
}

class tableViewMovieClass: UITableViewController {
    @IBOutlet weak var navBarButton: UIBarButtonItem!
    var thumbArray: NSArray?
    var imageCache = [String : UIImage]()  // Dictionary of URL Strings and images

    // Read metadata from rottem server
    func readMovieServer()
    {
        navBarButton.title = "Loading"
        let manager = AFHTTPRequestOperationManager()
        manager.GET("http://api.rottentomatoes.com/api/public/v1.0/lists/movies/opening.json?apikey=g33ukjt9qmxhcrfymh3kbnkq",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                println("====JSON: " )
                self.navBarButton.title = " "
                self.fillMovieArrayFromJSON(responseObject)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.navBarButton.title = "1Network error"
        })
    }
    
    
    // Populate movies array with data on each movie
    func fillMovieArrayFromJSON(response: AnyObject)
    {
        let responseDict = response as Dictionary<String, AnyObject>
        MovieMetaData.moviesArray = (responseDict["movies"] as AnyObject?) as? NSArray
        println("testparse count \(MovieMetaData.moviesArray?.count)")
        for movie in MovieMetaData.moviesArray!
        {
            let titleMovie = movie["title"] as NSString
            let posters = movie["posters"] as NSDictionary
            var poster_url = posters["thumbnail"] as NSString
            let synMovie = movie["synopsis"] as NSString
            let ratingMovie = movie["mpaa_rating"] as NSString
            let ratings = movie["ratings"] as NSDictionary
            let cRatingMovie = ""
            let aRatingMovie = ""
            var rotMovieData = RotMovieData(title: titleMovie, posterURL: poster_url, synopsis: synMovie, rating: ratingMovie,critics_rating: cRatingMovie,audience_rating: aRatingMovie)
            MovieMetaData.tableData.append(rotMovieData)
            println("nfnetwork fill array \(titleMovie) \(cRatingMovie) \(aRatingMovie)")
        }
        self.tableView.reloadData()
    }
    
    
    func refresh(sender:AnyObject)
    {
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
        readMovieServer();
    }
    
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }

    
    // Return number of cells
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let array = MovieMetaData.moviesArray
        {
            return array.count
        }
        else
        {
            return 0
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var nameFile = ""
        var namePerson = ""
        let cell = tableView.dequeueReusableCellWithIdentifier("CELLMOVIE") as? MovieCellTableViewCell
        let movie = MovieMetaData.moviesArray![indexPath.row] as NSDictionary
        let posters = movie["posters"] as NSDictionary
        var poster_url = posters["thumbnail"] as NSString
        poster_url = poster_url.stringByReplacingOccurrencesOfString("_tmb", withString: "_ori")
        cell?.cellMovieDesc.text = movie["title"] as NSString
        let ratingStr = movie["mpaa_rating"] as NSString
        let descStr = movie["synopsis"] as NSString
        var fullRateDescStr = "\(ratingStr)  \(descStr)"
        cell?.cellMovieLabel.text = fullRateDescStr
        let url = NSURL(string: poster_url)
        let data = NSData(contentsOfURL: url!)
        if indexPath.row < MovieMetaData.tableData.count
        {
            var urlString = MovieMetaData.tableData[indexPath.row].posterURL
            var imageFromServer = self.imageCache[urlString]  // Load image from cache
            // No image yet: Need to get it from server
            if( imageFromServer == nil ) // If no image in cache, Load image from server (and set it async)
            {
                var imgURL: NSURL = NSURL(string: urlString)!
                // Download an NSData representation of the image at the URL
                let request: NSURLRequest = NSURLRequest(URL: imgURL)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,dataImg: NSData!,error: NSError!) -> Void in
                    if error == nil   // If no error, store image in dictionary cache
                    {
                        imageFromServer = UIImage(data: dataImg)
                        self.imageCache[urlString] = imageFromServer
                        tableView.reloadData()
                    }
                    else
                    {
                        self.navBarButton.title = "Network error 2"
                    }
                })
            }
            // Set image after it is loaded - Async
            dispatch_async(dispatch_get_main_queue(), {
                if let photoImageView = cell?.viewWithTag(300) as? UIImageView
                {
                    photoImageView.image = imageFromServer
                }
            })
        }
        return cell!
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: (NSIndexPath!))
    {
        MovieMetaData.index = indexPath.row
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    

}
