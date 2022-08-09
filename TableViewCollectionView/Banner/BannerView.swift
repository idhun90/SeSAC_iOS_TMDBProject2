import UIKit

class BannerView: UIView {
    
    @IBOutlet weak var bannerLabel: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    func loadView() {
        let view = UINib(nibName: String(describing: BannerView.self), bundle: nil).instantiate(withOwner: self).first as! UIView
        
        view.frame = bounds
        view.backgroundColor = .clear
        self.addSubview(view)
    }
}
