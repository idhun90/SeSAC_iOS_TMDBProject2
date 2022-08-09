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
        bannerView.bannerLabel.font = .systemFont(ofSize: 17)
    }
}
