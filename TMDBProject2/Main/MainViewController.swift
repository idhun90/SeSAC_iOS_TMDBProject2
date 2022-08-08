import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class MainViewController: UIViewController {
    
    var movieData: [Movie] = []
    var page = 1
    let totalPage = 1000
    var genre: [Int: String] = [:]
    
    @IBOutlet weak var MainCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainCollectionView.delegate = self
        MainCollectionView.dataSource = self
        MainCollectionView.prefetchDataSource = self
        
        let nib = UINib(nibName: MainCollectionViewCell.ReusableIdentifier, bundle: nil)
        MainCollectionView.register(nib, forCellWithReuseIdentifier: MainCollectionViewCell.ReusableIdentifier)
        collectionViewLayout()
        
        fetchMovieByAPIManager(page: page)
        
        navigationController?.navigationBar.tintColor = .black
    }
    //MARK: - TBDM 네트워크 통신 요청
    
    func fetchMovieByAPIManager(page: Int) {
        APIManager.shared.fetchMovie(page: page) { json in
            
            for movie in json["results"].arrayValue {
                
                let title = movie["title"].stringValue
                let release = movie["release_date"].stringValue
                let overview = movie["overview"].stringValue
                let backImage = EndPoint.tmdImage + movie["backdrop_path"].stringValue
                let posterImage = EndPoint.tmdImage + movie["poster_path"].stringValue
                let vote = movie["vote_average"].doubleValue
                let movieId = movie["id"].intValue
                let genreid = movie["genre_ids"][0].intValue
                
                print("현재 페이지 \(self.page)")
                print("영화 제목 \(title)")
                
                let data = Movie(title: title, release: release, overview: overview, image: backImage, vote: vote, poster: posterImage, movieid: movieId, genreid: genreid)
                
                self.movieData.append(data)
                // self.MainCollectionView.reloadData()
                
                self.fetchGenreByAPIManager()
                
                print("json 타이틀: \(title)")
                print("data 타이틀: \(data.title)")
                print("movieID: \(movieId)")
                print("genreID: \(genreid)")
                
                print("data 갯수: \(self.movieData.count)")
                print("================")
                
            }
        }
    }
    
    func fetchGenreByAPIManager() {
        APIManager.shared.fetchGenre { json in
            for dictionary in json["genres"].arrayValue {
                let key = dictionary["id"].intValue
                let value = dictionary["name"].stringValue
                
                self.genre.updateValue(value, forKey: key)
                self.MainCollectionView.reloadData()
            }
            
            print("장르 딕셔너리: \(self.genre)")
        }
    }
    
    func fetchVideoByAPIManager(id: Int) {
        APIManager.shared.fetchVideo(id: id) { json in
            let key = json["results"][0]["key"].stringValue
            self.transitionWithKeyValue(key: key)
        }
    }
    
    //MARK: - Layout
    func collectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 5
        let itemCount: CGFloat = 1
        
        let width = (UIScreen.main.bounds.width - spacing * (itemCount + 1)) / itemCount
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        MainCollectionView.collectionViewLayout = layout
    }
    
    //MARK: - Action 함수
    func transitionWithKeyValue(key: String) {
        let sb = UIStoryboard(name: StoryBoardName.web, bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: WebViewController.ReusableIdentifier) as? WebViewController else { return }
        
        vc.key = key
        
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true)
    }
    
    @objc func clickedLinkButton(sender: UIButton) {
        let id = movieData[sender.tag].movieid
        
        fetchVideoByAPIManager(id: id)
    }
}

//MARK: - CollectionView Protocol 채택
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if movieData.count - 1 == indexPath.item && movieData.count < totalPage {
                page += 1
                
                fetchMovieByAPIManager(page: page)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = MainCollectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.ReusableIdentifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        
        cell.genre = self.genre
        cell.configCell(data: movieData[indexPath.row])
        
        cell.linkButton.tag = indexPath.row
        cell.linkButton.addTarget(self, action: #selector(clickedLinkButton), for: .touchUpInside)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: StoryBoardName.detail, bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: DetailViewController.ReusableIdentifier) as? DetailViewController else { return }
        
        vc.movieData = movieData[indexPath.row]
        
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(vc, animated: true)
    }
}
