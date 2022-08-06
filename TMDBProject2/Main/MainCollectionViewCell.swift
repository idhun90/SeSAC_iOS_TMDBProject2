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

    override func awakeFromNib() {
        super.awakeFromNib()
        layout()
    }
    
    func layout() {
        
        inView.layer.masksToBounds = true
        inView.layer.cornerRadius = 7
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 7
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        dateLabel.font = .systemFont(ofSize: 12)
        genreLabel.font = .boldSystemFont(ofSize: 17)
        genreLabel.text = "장르"
        
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
