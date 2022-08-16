import UIKit

class ListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bannerView: BannerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layout()
    }

    func layout() {
        bannerView.backgroundColor = .clear
        bannerView.bannerImageView.backgroundColor = .orange
        bannerView.bannerImageView.layer.cornerRadius = 5
        bannerView.bannerImageView.contentMode = .scaleAspectFill
        bannerView.bannerLabel.font = .systemFont(ofSize: 17)
        bannerView.bannerImageView.layer.borderWidth = 1
        bannerView.bannerImageView.layer.borderColor = UIColor.systemGray.cgColor
        bannerView.bannerLabel.textColor = .black
        bannerView.bannerLabel.backgroundColor = .white
        
    }
}
