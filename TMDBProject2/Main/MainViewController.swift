import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class MainViewController: UIViewController {
    
    var movieData: [Movie] = []
    var page = 1
    let totalPage = 1000
    
    @IBOutlet weak var MainCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainCollectionView.delegate = self
        MainCollectionView.dataSource = self
        MainCollectionView.prefetchDataSource = self
        
        let nib = UINib(nibName: MainCollectionViewCell.ReusableIdentifier, bundle: nil)
        MainCollectionView.register(nib, forCellWithReuseIdentifier: MainCollectionViewCell.ReusableIdentifier)
        collectionViewLayout()
        fetchTBDM(page: page)
        
        navigationController?.navigationBar.tintColor = .black
    }
    
    func fetchTBDM(page: Int) {
        let url = "\(EndPoint.tmdbURL)?api_key=\(APIKey.TMDB)&page=\(page)"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //                print("JSON: \(json)")
                
                for movie in json["results"].arrayValue {
                    
                    let title = movie["title"].stringValue
                    let release = movie["release_date"].stringValue
                    let overview = movie["overview"].stringValue
                    let backImage = EndPoint.tmdImage + movie["backdrop_path"].stringValue
                    let posterImage = EndPoint.tmdImage + movie["poster_path"].stringValue
                    let vote = movie["vote_average"].doubleValue
                    let movieId = movie["id"].intValue
                    
                    print("현재 페이지 \(page)")
                    print("영화 제목 \(title)")
                    
                    let data = Movie(title: title, release: release, overview: overview, image: backImage, vote: vote, poster: posterImage, movieid: movieId)
                    
                    self.movieData.append(data)
                    
                    print("json 타이틀: \(title)")
                    print("data 타이틀: \(data.title)")
                    
                    print("data 갯수: \(self.movieData.count)")
                    print("================")
                }
                
                self.MainCollectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
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
    
}

//MARK: - CollectionView Protocol 채택
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = MainCollectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.ReusableIdentifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        
        let date = DateFormatter()
        date.dateFormat = "yyyy.mm.dd"
        let newDate = date.date(from: movieData[indexPath.row].release)
        cell.dateLabel.text = date.string(from: newDate!)
        
        cell.voteIntLabel.text = String(Int(movieData[indexPath.row].vote))
        cell.titleLabel.text = movieData[indexPath.row].title
//        print("cell title:\(movieData[indexPath.row].title), \(indexPath.row)번 째")
        cell.overViewLabel.text = movieData[indexPath.row].overview
        
        let url = URL(string: movieData[indexPath.row].image)
        cell.backgroundImageView.kf.setImage(with: url)
        
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

extension MainViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if movieData.count - 1 == indexPath.item && movieData.count < totalPage {
                page += 1
                fetchTBDM(page: page)
            }
        }
    }


}
