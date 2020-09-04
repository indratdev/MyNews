//
//  Utilities.swift
//  MyNews
//
//  Created by IndratS on 02/09/20.
//  Copyright © 2020 IndratSaputra. All rights reserved.
//

import Foundation

struct Utilities {
    let appName: String = "INI BERITA"
    let newsCellIdentifier: String = "newsCell"
    let newsNib: String = "NewsTableViewCell"
    let segueToDetail: String = "detailSegue"
    
    
    func convertDate(date: String) -> String {
        var dateConvert: String
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        
        if let date = dateFormatterGet.date(from: date) {
            dateConvert = dateFormatterPrint.string(from: date)
            
        } else {
        dateConvert = "There was an error decoding the string"
        }
        
        return dateConvert
        
    }
    
    var getAppName: String {
        return appName
    }
    
    
}
