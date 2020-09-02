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
    let resourceURL: URL
    let urlString: String = "https://newsapi.org/v2/top-headlines?apiKey=f507ea00fb1b4d039c77d1ffabe378e8&country=id"
    
    init() {
        guard let urlNews = URL(string: urlString) else { fatalError()}
        
        self.resourceURL = urlNews
    }
    
    func requestURL(completion: @escaping(Result<[Article], Error>) -> Void){
        AF.request(resourceURL).response { response in
            switch response.result {
            case .success(let data):
                if let data = data {
//                    if let hasil = self.parseJSON(data: data){
//                        completion(.success(hasil))
//                    }
                    if let hasil = self.parseJSON(data: data) {
//                        print("hasil : \(hasil)")
                                                completion(.success(hasil))
                    }
                    
                }
            case .failure(let err):
                print(err)
                completion(.failure(err))
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
