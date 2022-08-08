import UIKit

class MainCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var inView: UIView!
    @IBOutlet weak var voteview: UIView!
    @IBOutlet weak var voteTextLabel: UILabel!
    @IBOutlet weak var voteIntView: UIView!
    @IBOutlet weak var voteIntLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // 값 전달 받을 목적
    var genre: [Int: String] = [:]

    override func awakeFromNib() {
        super.awakeFromNib()
        layout()
    }

    func configCell(data: Movie) {
        
        let date = DateFormatter()
        date.dateFormat = "yyyy.mm.dd"
        let newDate = date.date(from: data.release)
        dateLabel.text = date.string(from: newDate!)
        
        voteIntLabel.text = String(Int(data.vote))
        titleLabel.text = data.title
        overViewLabel.text = data.overview
        
        let url = URL(string: data.image)
        backgroundImageView.kf.setImage(with: url)
        
        genreLabel.text = "#" + (genre[data.genreid] ?? "장르")
    }
}

extension MainCollectionViewCell: CellLayout {
    func layout() {
        inView.layer.masksToBounds = true
        inView.layer.cornerRadius = 7
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 7
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        dateLabel.font = .systemFont(ofSize: 12)
        genreLabel.font = .systemFont(ofSize: 18, weight: .bold)
        
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        overViewLabel.font = .systemFont(ofSize: 17)
        overViewLabel.textColor = .darkGray
        
        detailLabel.font = .systemFont(ofSize: 14, weight: .light)
        detailLabel.text = "자세히 보기"
        
        voteview.backgroundColor = .systemPurple
        voteTextLabel.font = .systemFont(ofSize: 14)
        voteTextLabel.textColor = .white
        voteIntView.backgroundColor = .white
        voteIntLabel.font = .systemFont(ofSize: 14)
        
        linkButton.tintColor = .white
        
        backgroundImageView.contentMode = .scaleAspectFill
    }
}
