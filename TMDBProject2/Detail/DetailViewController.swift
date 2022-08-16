import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON
import TMDBFramework

enum Section: Int, CaseIterable {
    case overView
    case cast
    case crew
    
    var sectionTitle: String {
        switch self {
        case .overView:
            return "OverView"
        case .cast:
            return "Cast"
        case .crew:
            return "Crew"
        }
    }
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var blurImageView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var detailTableView: UITableView!
    
    var movieData: Movie?
    private var castInfo: [Cast] = []
    private var crewInfo: [Crew] = []
    private var isExpanded: Bool = false // flase: 2, true : 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTableView.dataSource = self
        detailTableView.delegate = self
        
        let overViewNib = UINib(nibName: OverViewTableViewCell.reuseIdentifier, bundle: nil)
        let CastCrewViewNib = UINib(nibName: CastCrewTableViewCell.reuseIdentifier, bundle: nil)
        detailTableView.register(overViewNib, forCellReuseIdentifier: OverViewTableViewCell.reuseIdentifier)
        detailTableView.register(CastCrewViewNib, forCellReuseIdentifier: CastCrewTableViewCell.reuseIdentifier)
        
        viewLayout()
        loadData()
        
        guard let movieData = movieData else { return }
        fetchCastCrewByAPIManager(moiveID: movieData.movieid)
    }
    
    //MARK: - TMDB 네트워크 통신 요청
    private func fetchCastCrewByAPIManager(moiveID: Int) {
        APIManager.shared.fetchCastCrew(movieId: moiveID) { json in
            for cast in json["cast"].arrayValue {
                let name = cast["name"].stringValue
                let character = cast["character"].stringValue
                let profile = EndPoint.tmdImage + cast["profile_path"].stringValue
                
                let data = Cast(name: name, character: character, profile_path: profile)
                self.castInfo.append(data)
                
                print("====== cast name: \(name) ======")
            }
            
            for crew in json["crew"].arrayValue {
                let name = crew["name"].stringValue
                let job = crew["job"].stringValue
                let profile = EndPoint.tmdImage + crew["profile_path"].stringValue
                
                let data = Crew(name: name, job: job, profile_path: profile)
                self.crewInfo.append(data)
                print("====== crew name: \(name) ======")
            }
            
            self.detailTableView.reloadData()
            
            print("====== cast 배열 count: \(self.castInfo.count) ======")
            print("====== crew 배열 count: \(self.crewInfo.count) ======")
        }
    }
    
    //MARK: - layout 및 초기 데이터 가져오기
    private func viewLayout() {
        
        blurImageView.backgroundColor = .black.withAlphaComponent(0.4)
        
        posterImageView.layer.borderWidth = 1
        posterImageView.layer.borderColor = UIColor.systemGray.cgColor
        posterImageView.layer.cornerRadius = 5
        
        titleLabel.font = .systemFont(ofSize: 25, weight: .bold)
        titleLabel.textColor = .white
        
    }
    
    private func loadData() {
        
        guard let movieData = movieData else { return }
        
        title = movieData.title
        
        let url = URL(string: movieData.image)
        backgroundImageView.kf.setImage(with: url)
        backgroundImageView.contentMode = .scaleAspectFill
        
        let postUrl = URL(string: movieData.poster)
        posterImageView.kf.setImage(with: postUrl)
        posterImageView.contentMode = .scaleAspectFill
        
        titleLabel.text = movieData.title
        
    }
    
    //MARK: - Action 메소드
    
    @objc func controllExpand(_ sender: UIButton) {
        
        isExpanded = !isExpanded
        detailTableView.reloadData()
        
        
    }
    
}

//MARK: - TableViewController 관련 Protocol 채택
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return Section.allCases.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == Section.overView.rawValue ? UITableView.automaticDimension : 80
        
//        detailTableView.rowHeight = UITableView.automaticDimension
//        detailTableView.estimatedRowHeight = 100
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case Section.overView.rawValue:
            return Section.overView.sectionTitle
        case Section.cast.rawValue:
            return Section.cast.sectionTitle
        case Section.crew.rawValue:
            return Section.crew.sectionTitle
        default :
            return "기본"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case Section.overView.rawValue:
            return 1
        case Section.cast.rawValue:
            return castInfo.count
            
        case Section.crew.rawValue:
            return crewInfo.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == Section.overView.rawValue {
            guard let cell = detailTableView.dequeueReusableCell(withIdentifier: OverViewTableViewCell.reuseIdentifier, for: indexPath) as? OverViewTableViewCell else { return UITableViewCell() }
            //print("===== 현재 섹션 0 체크용: \(indexPath.section) =====")
            
            if let movieData = movieData {
                cell.configCell(data: movieData)
            } else {
                print("movieData에 값이 없습니다.")
            }
            
            cell.overViewLabel.numberOfLines = isExpanded ? 0 : 2
            cell.expandButton.addTarget(self, action: #selector(controllExpand(_:)), for: .touchUpInside)
            
            return cell
            
        } else {
            //print("===== 현재 섹션: \(indexPath.section) =====")
            guard let cell = detailTableView.dequeueReusableCell(withIdentifier: CastCrewTableViewCell.reuseIdentifier, for: indexPath) as? CastCrewTableViewCell else { return UITableViewCell() }
            
            indexPath.section == Section.cast.rawValue ? cell.configCastCell(data: castInfo[indexPath.row]) : cell.configCrewCell(data: crewInfo[indexPath.row])
            
            return cell
        }
    }
}
