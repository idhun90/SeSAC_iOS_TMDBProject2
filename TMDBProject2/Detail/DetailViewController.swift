import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

enum SectionName:String, CaseIterable {
    case overView = "OverView"
    case cast = "Cast"
    case crew = "Crew"
}

class DetailViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var blurImageView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var detailTableView: UITableView!
    
    var movieData: Movie?
    var castInfo: [Cast] = []
    var crewInfo: [Crew] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTableView.dataSource = self
        detailTableView.delegate = self
        
        let overViewNib = UINib(nibName: OverViewTableViewCell.ReusableIdentifier, bundle: nil)
        let CastCrewViewNib = UINib(nibName: CastCrewTableViewCell.ReusableIdentifier, bundle: nil)
        detailTableView.register(overViewNib, forCellReuseIdentifier: OverViewTableViewCell.ReusableIdentifier)
        detailTableView.register(CastCrewViewNib, forCellReuseIdentifier: CastCrewTableViewCell.ReusableIdentifier)
        
        detailTableView.rowHeight = 90
        
        viewLayout()
        loadData()
        
        guard let movieData = movieData else { return }
        fetchID(movieId: movieData.movieid)
    }
    
    //MARK: - TMDB 네트워크 통신 요청
    func fetchID(movieId: Int) {
        
        let url = "\(EndPoint.tmdCastCrew)/\(movieId)/credits?api_key=\(APIKey.TMDB)"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
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
                
                
     
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: - layout 및 초기 데이터 가져오기
    func viewLayout() {
        
        blurImageView.backgroundColor = .black.withAlphaComponent(0.4)
        
        posterImageView.layer.borderWidth = 1
        posterImageView.layer.borderColor = UIColor.systemGray.cgColor
        posterImageView.layer.cornerRadius = 5
        
        titleLabel.font = .systemFont(ofSize: 25, weight: .bold)
        titleLabel.textColor = .white
        
    }

    func loadData() {
        
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
}

//MARK: - TableViewController 관련 Protocol 채택
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return SectionName.allCases.count // 타입 프로퍼티로 사용시 사용불가하여, case로 변경
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80 // 왜 오류가 발생하지?
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return SectionName.overView.rawValue
        case 1:
            return SectionName.cast.rawValue
        case 2:
            return SectionName.crew.rawValue
        default :
            return "기본"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return castInfo.count
           
        case 2:
            return crewInfo.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = detailTableView.dequeueReusableCell(withIdentifier: CastCrewTableViewCell.ReusableIdentifier, for: indexPath) as? CastCrewTableViewCell else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            guard let cell = detailTableView.dequeueReusableCell(withIdentifier: OverViewTableViewCell.ReusableIdentifier, for: indexPath) as? OverViewTableViewCell else { return UITableViewCell() }
            
            cell.overViewLabel.text = movieData?.overview
            
            return cell
            
        case 1:
            // Cast
            let url = URL(string: castInfo[indexPath.row].profile_path)
            cell.castCrewImageView.kf.setImage(with: url)
            cell.nameLabel.text = castInfo[indexPath.row].name
            cell.characterOrJobLabel.text = castInfo[indexPath.row].character
            
            return cell
            
        case 2:
            // Crew
            let url = URL(string: crewInfo[indexPath.row].profile_path)
            cell.castCrewImageView.kf.setImage(with: url)
            cell.nameLabel.text = crewInfo[indexPath.row].name
            cell.characterOrJobLabel.text = crewInfo[indexPath.row].job
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
}
