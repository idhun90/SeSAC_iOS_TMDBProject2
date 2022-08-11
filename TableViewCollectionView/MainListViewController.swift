import UIKit

class MainListViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    let sectionTitle = ["Popular", "Top Rated", "Upcoming", "NowPlaying" , "탑건:매버릭을 즐겨봤다면"]
    
    var popularMovie: [PopularMovie] = []
    var topRatedMovie: [TopRatedMovie] = []
    var upcomingMovie: [UpcomingMovie] = []
    var similarMovie: [SimilarMoive] = []
    var nowplayingMovie: [NowPlaying] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TMDB"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] // 라지 타이틀일 때 색 변경 방법
        
        
        mainTableView.dataSource = self
        mainTableView.delegate = self
        
        let nib = UINib(nibName: MainTableViewCell.ReusableIdentifier, bundle: nil)
        mainTableView.register(nib, forCellReuseIdentifier: MainTableViewCell.ReusableIdentifier)
        
        view.backgroundColor = .clear
        mainTableView.backgroundColor = .clear
        
        // 안됨
        // mainTableView.rowHeight = UITableView.automaticDimension
        // mainTableView.estimatedRowHeight = 200
        //
        TMDBAPIManager.shared.fetchPopularMovie { popularData in
            self.popularMovie = popularData
            //            print(self.popularMovie)
            
            TMDBAPIManager.shared.fetchTopRatedMovie { topRatedData in
                self.topRatedMovie = topRatedData
                //                print(self.topRatedMovie)
                
                TMDBAPIManager.shared.fetchUpcomingMovie { upcomingData in
                    self.upcomingMovie = upcomingData
                    
                    TMDBAPIManager.shared.fetchNowPlayingMovie { nowPlayingData in
                        self.nowplayingMovie = nowPlayingData
                        
                        TMDBAPIManager.shared.fetchSimilarMovie { similarDate in
                            self.similarMovie = similarDate
                            self.mainTableView.reloadData()
                        }
                    }
                }
            }
            // 이 곳에서만 리로드를 했을 때 컬렉션뷰셀 태그 값에 문제가 있었다. 예: 0 태그 값이 태그 3 위치에 표기되는 문제 등 -> 아래 컬렉션뷰 셀 리로드도 진행하여 문제 해결
        }
    }
}

extension MainListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.ReusableIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        cell.listCollectionView.delegate = self
        cell.listCollectionView.dataSource = self
        cell.titleLabel.text = sectionTitle[indexPath.section]
        cell.listCollectionView.tag = indexPath.section
        print("======= \(#function), section: \(indexPath.section), tag: \(cell.listCollectionView.tag) =======")
        
        
        let cellNib = UINib(nibName: ListCollectionViewCell.ReusableIdentifier, bundle: nil)
        cell.listCollectionView.register(cellNib, forCellWithReuseIdentifier: ListCollectionViewCell.ReusableIdentifier)
        cell.listCollectionView.reloadData() // 테이블 뷰에만 리로드를 해주면 셀 태그가 꼬이는 문제가 있었다. 인덱스 꼬임 해결
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowHeigt = (UIScreen.main.bounds.height * 0.2 + 10 + 28 + 4) * 1.1
        return rowHeigt
    }
    
}

extension MainListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 0 {
            return popularMovie.count
        } else if collectionView.tag == 1 {
            return topRatedMovie.count
        } else if collectionView.tag == 2 {
            return upcomingMovie.count
        } else if collectionView.tag == 3 {
            return nowplayingMovie.count
        } else {
            return similarMovie.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.ReusableIdentifier, for: indexPath) as? ListCollectionViewCell else { return UICollectionViewCell() }
                print("======= \(#function), [section:item] = [\(indexPath.section), \(indexPath.item)] ========")
        
        if collectionView.tag == 0 {
            let url = EndPoint.tmdImage + popularMovie[indexPath.item].poster
            let newUrl = URL(string: url)
            cell.bannerView.bannerImageView.kf.setImage(with: newUrl)
            cell.bannerView.bannerLabel.text = String(popularMovie[indexPath.item].vote)
            print("Popular")
            
            return cell
            
        } else if collectionView.tag == 1 {
            let url = EndPoint.tmdImage + topRatedMovie[indexPath.item].poster
            let newUrl = URL(string: url)
            cell.bannerView.bannerImageView.kf.setImage(with: newUrl)
            cell.bannerView.bannerLabel.text = String(topRatedMovie[indexPath.item].vote)
            print("Top Rated")
            
            return cell
        } else if collectionView.tag == 2 {
            let url = EndPoint.tmdImage + upcomingMovie[indexPath.item].poster
            let newUrl = URL(string: url)
            cell.bannerView.bannerImageView.kf.setImage(with: newUrl)
            cell.bannerView.bannerLabel.text = nil
            print("Upcoming")
            
            return cell
            
        } else if collectionView.tag == 3 {
            let url = EndPoint.tmdImage + nowplayingMovie[indexPath.item].poster
            let newUrl = URL(string: url)
            cell.bannerView.bannerImageView.kf.setImage(with: newUrl)
            cell.bannerView.bannerLabel.text = String(nowplayingMovie[indexPath.item].vote)
            print("NowPlaying")
            
            return cell
            
        } else {
            let url = EndPoint.tmdImage + similarMovie[indexPath.item].poster
            let newUrl = URL(string: url)
            cell.bannerView.bannerImageView.kf.setImage(with: newUrl)
            cell.bannerView.bannerLabel.text = String(format: "%.1f", similarMovie[indexPath.item].vote)
            print("탑건:매버릭을 즐겨봤다면")
            
            return cell
            
        }
    }
    
}
