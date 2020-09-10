//
//  NewsManager.swift
//  MyNews
//
//  Created by IndratS on 02/09/20.
//  Copyright © 2020 IndratSaputra. All rights reserved.
//

import Foundation
import Alamofire

struct NewsManager {
    let resourceURL: URL? = .none
    var filterNews: String = ""
    //    let urlString: String = "https://newsapi.org/v2/top-headlines?apiKey=f507ea00fb1b4d039c77d1ffabe378e8&country=id"
    let urlString: String = "https://newsapi.org/v2"
    let apiKey: String = "?apiKey=f507ea00fb1b4d039c77d1ffabe378e8"
    let country: String = "&country=id"
    //    /top-headlines
    
    //    init() {
    //        guard let urlNews = URL(string: urlString) else { fatalError()}
    //
    //        self.resourceURL = urlNews
    ////        print(filterNews)
    //    }
    
    func genURL(data: String) -> URL{
        let url = urlString + data + apiKey + country
        let fixURL = URL(string: url)!
        
        return fixURL
        
    }
    
    func requestURL(filter: String, completion: @escaping(Result<[Article], Error>) -> Void){
        //        self.filterNews = filter
        if let urlNews = URL(string: "\(genURL(data: filter))"){
            AF.request(urlNews).response { response in
                switch response.result {
                case .success(let data):
                    if let data = data {
                        if let hasil = self.parseJSON(data: data) {
                            
                            completion(.success(hasil))
                        }
                        
                    }
                case .failure(let err):
                    print(err)
                    completion(.failure(err))
                }
            }
        }
    }
    
    func parseJSON(data: Data) -> [Article]? {
        let decoder = JSONDecoder()
        
        do{
            let decoderData = try decoder.decode(NewsFeed.self, from: data)
            guard let articleNews = decoderData.articles else { return nil}
            
            //            if let articleNews = decoderData.articles {
            //                return articleNews
            ////                print(articleNews)
            //            }
            
            return articleNews
            
            
            
            
            //            let decoderData = try decoder.decode(NewsFeed.self, from: data)
            //
            //            // yang mau diambil struct yg mana
            //            guard let articleNews = decoderData.articles else { return }
            //            completion(.success(articleNews))
            
        }catch let err{
            print(err)
            return nil
        }
    }
    
    
}

struct FilterNews {
    var newsFilter: [String:String] = [
        "Top Headlines" : "/top-headlines"
        ,"Everything" : "/everything"
    ]
}
