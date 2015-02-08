//
//  RotMovieData.swift
//  code1RotTomatoes
//
//  Created by Michael Winter on 2/5/15.
//  Copyright (c) 2015 com.codepath. All rights reserved.
//

import Foundation

class RotMovieData: NSObject, Printable
{
    let title: String
    let posterURL: String
    let synopsis: String
    let critics_rating: String
    let audience_rating: String
    let rating: String

    override var description: String
    {
        return "Name: \(title), URL: \(posterURL), SYN: \(synopsis), Rating: \(rating), Critics Rating: \(critics_rating), Audiance Rating: \(audience_rating)\n"
    }
    
    init(title: String?, posterURL: String?, synopsis: String?, rating: String?, critics_rating: String?, audience_rating: String?)
    {
        self.title = title ?? ""
        self.posterURL = posterURL ?? ""
        self.synopsis = synopsis ?? ""
        self.rating = rating ?? ""
        self.critics_rating = critics_rating ?? ""
        self.audience_rating = audience_rating ?? ""
    }
}