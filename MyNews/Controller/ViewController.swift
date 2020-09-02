//
//  ViewController.swift
//  MyNews
//
//  Created by IndratS on 02/09/20.
//  Copyright © 2020 IndratSaputra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleAppLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var newsManager = NewsManager()
    var util = Utilities()
    var errorLocal: String?
    
    var listOfArticle = [Article]()
    {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleAppLabel.text = util.appName
        
        loadNews()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: util.newsNib, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: util.newsCellIdentifier)
        
        
        
    }
    
    func loadNews(){
        
        newsManager.requestURL { [weak self] result in
            switch result {
            case .success(let data):
                self?.listOfArticle = data
            case .failure(let err):
                self?.errorLocal = err.localizedDescription
            }
        }
        
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfArticle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: util.newsCellIdentifier, for: indexPath) as! NewsTableViewCell
        
        // --------- set data ---------------
        // set image news
        if let imageNews = listOfArticle[indexPath.row].urlToImage{
            cell.imageNews.downloaded(from: URL(string: imageNews)!)
        }
        // set title
        cell.titleLabel.text = listOfArticle[indexPath.row].title
        cell.sourceLabel.text = listOfArticle[indexPath.row].source?.name
        cell.optionalLabel.text = util.convertDate(date: listOfArticle[indexPath.row].publishedAt!)
        // set author
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 292
    }
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
}
