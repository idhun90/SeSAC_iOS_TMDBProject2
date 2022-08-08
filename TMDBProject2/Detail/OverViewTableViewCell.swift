
import UIKit

class OverViewTableViewCell: UITableViewCell {

    @IBOutlet weak var overViewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell(data: Movie) {
        overViewLabel.text = data.overview
    }
}

extension OverViewTableViewCell: CellLayout {
    func layout() {
        overViewLabel.font = .systemFont(ofSize: 16)
        overViewLabel.numberOfLines = 2
    }
}
