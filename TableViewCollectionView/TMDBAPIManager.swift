import Foundation

import Alamofire
import SwiftyJSON

class TMDBAPIManager {
    
    static let shared = TMDBAPIManager()
    private init() {}
    
    //인기영화 가져오기
    func fetchPopularMovie(completionHandler: @escaping ([PopularMovie]) -> ()) {
    
        let url = "\(EndPoint.tmdbPopularMovie)?api_key=\(APIKey.TMDB)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                // 방법 1
//                for item in json["results"].arrayValue {
//                    
//                    let poster = item["poster_path"].stringValue
//                    let vote = item["vote_average"].doubleValue
//                }
                
                // 방법 2
                    let data = json["results"].arrayValue.map {
                        PopularMovie(poster: $0["poster_path"].stringValue, vote: $0["vote_average"].doubleValue)
                    }
               
                    completionHandler(data)
                
                
//                let key = json["results"].arrayValue.map { $0["poster_path"].stringValue }
//                let value = json["results"].arrayValue.map { $0["vote_average"].doubleValue }
//                completionHandler([key: value])
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchTopRatedMovie(completionHandler: @escaping ([TopRatedMovie]) -> ()) {
        
        let url = "\(EndPoint.tmdbTopRatedMovie)?api_key=\(APIKey.TMDB)language=ko-KR&page=1"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                let data = json["results"].arrayValue.map {
                    TopRatedMovie(poster: $0["poster_path"].stringValue, vote: $0["vote_average"].doubleValue)
                }
                completionHandler(data)
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchUpcomingMovie(completionHandler: @escaping ([UpcomingMovie]) -> ()) {
    
        let url = "\(EndPoint.tmdbUpcomingMoview)?api_key=\(APIKey.TMDB)&language=ko-KR&page=1"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                let data = json["results"].arrayValue.map { UpcomingMovie(poster: $0["poster_path"].stringValue) }
                
                completionHandler(data)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    func fetchSimilarMovie(completionHandler: @escaping ([SimilarMoive]) -> ()) {
    
        let url = "\(EndPoint.tmdCastCrew)/361743/similar?api_key=\(APIKey.TMDB)&language=ko-KR&page=1"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                let data = json["results"].arrayValue.map {
                    SimilarMoive(poster: $0["poster_path"].stringValue, vote: $0["vote_average"].doubleValue)
                }
                completionHandler(data)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchNowPlayingMovie(completionHandler: @escaping ([NowPlaying]) -> ()) {
    
        let url = "\(EndPoint.tmdCastCrew)/now_playing?api_key=\(APIKey.TMDB)&language=ko-KR&page=1"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                let data = json["results"].arrayValue.map {
                    NowPlaying(poster: $0["poster_path"].stringValue, vote: $0["vote_average"].doubleValue)
                }
                completionHandler(data)
                
            case .failure(let error):
                print(error)
            }
        }
    }

    
}
