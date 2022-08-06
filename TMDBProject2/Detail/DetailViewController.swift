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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTableView.dataSource = self
        detailTableView.delegate = self
        
        let overViewNib = UINib(nibName: OverViewTableViewCell.ReusableIdentifier, bundle: nil)
        let CastCrewViewNib = UINib(nibName: CastCrewTableViewCell.ReusableIdentifier, bundle: nil)
        detailTableView.register(overViewNib, forCellReuseIdentifier: OverViewTableViewCell.ReusableIdentifier)
        detailTableView.register(CastCrewViewNib, forCellReuseIdentifier: CastCrewTableViewCell.ReusableIdentifier)
        
        detailTableView.rowHeight = 80
        
        viewLayout()
        loadData()
        
    }
    
    func viewLayout() {
        
        blurImageView.backgroundColor = .black.withAlphaComponent(0.5)
        
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
            return 2
        case 2:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = detailTableView.dequeueReusableCell(withIdentifier: CastCrewTableViewCell.ReusableIdentifier, for: indexPath) as? CastCrewTableViewCell else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            guard let cell = detailTableView.dequeueReusableCell(withIdentifier: OverViewTableViewCell.ReusableIdentifier, for: indexPath) as? OverViewTableViewCell else { return UITableViewCell() }
            return cell
        case 1:
            // 케스트
            return cell
        case 2:
            // 캐스트
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
}
