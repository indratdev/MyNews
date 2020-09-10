//
//  ViewController.swift
//  MyNews
//
//  Created by IndratS on 02/09/20.
//  Copyright © 2020 IndratSaputra. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleAppLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    var newsManager = NewsManager()
    var filterNews =  FilterNews()
    var util = Utilities()
    var errorLocal: String?
    var selectedNews = [String]()
    var detailNews: [String: String] = [:]
    var selectedFilter: String = "/top-headlines"
    
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
    
    // MARK: Button Filter
    @IBAction func filterNewsPressed(_ sender: UIButton) {
        if let filter = sender.titleLabel?.text {
            if let selectedFilter = self.filterNews.newsFilter[filter] {
                self.selectedFilter = selectedFilter
                loadNews()
            }
        }
    }
    
    func loadNews(){
        newsManager.requestURL(filter: selectedFilter) { [weak self] result in
            switch result {
            case .success(let data):
                self?.listOfArticle = data
            case .failure(let err):
                self?.errorLocal = err.localizedDescription
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier) == util.segueToDetail {
            if let detailVC = segue.destination as? DetailVC {
                detailVC.newsSelected = detailNews
                
            }
        }
    }
    
    
    
    
}

// MARK: TABLEVIEW
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfArticle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: util.newsCellIdentifier, for: indexPath) as! NewsTableViewCell
        
        // --------- set data ---------------
        if let imageNews = listOfArticle[indexPath.row].urlToImage{
            cell.imageNews.downloaded(from: URL(string: imageNews)!)
        }
        
        cell.titleLabel.text = listOfArticle[indexPath.row].title
        cell.sourceLabel.text = listOfArticle[indexPath.row].source?.name
        //        cell.optionalLabel.text = util.convertDate(date: listOfArticle[indexPath.row].publishedAt!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailNews["urlToImage"] = listOfArticle[indexPath.row].urlToImage ?? ""
        detailNews["nameSource"] = listOfArticle[indexPath.row].source?.name ?? ""
        detailNews["title"] = listOfArticle[indexPath.row].title ?? ""
        
        detailNews["publishedAt"] = listOfArticle[indexPath.row].publishedAt ?? ""
        detailNews["author"] = listOfArticle[indexPath.row].author ?? ""
        
        detailNews["content"] = listOfArticle[indexPath.row].content ?? ""
        detailNews["articleDescription"] = listOfArticle[indexPath.row].articleDescription ?? ""
        
        detailNews["url"] = listOfArticle[indexPath.row].url ?? ""
        detailNews["idSource"] = listOfArticle[indexPath.row].source?.id ?? ""
        
        performSegue(withIdentifier: util.segueToDetail, sender: indexPath)
    }
    
}

// MARK: uiimage
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

extension UIViewController {
    
    
}
