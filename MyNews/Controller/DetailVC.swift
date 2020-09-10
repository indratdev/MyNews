//
//  DetailVC.swift
//  MyNews
//
//  Created by IndratS on 02/09/20.
//  Copyright © 2020 IndratSaputra. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var optionalLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var newsSelected: [String:String] = [:]
    var util = Utilities()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNews()
        
        
    }
    
    private func loadNews(){
        
        if let date = newsSelected["publishedAt"]{
            let dateF = util.convertDate(date: date)
            optionalLabel.text = "\(newsSelected["author"] ?? "") | \(dateF) \n"
        }
        
        sourceLabel.text = newsSelected["nameSource"]
        titleLabel.text = newsSelected["title"]
        
        contentLabel.text = newsSelected["content"]
        descriptionLabel.text = newsSelected["articleDescription"]
        
        if let url = newsSelected["urlToImage"]{
            newsImage.downloaded(from: URL(string: url)!)
        }
        
    }
    
}
