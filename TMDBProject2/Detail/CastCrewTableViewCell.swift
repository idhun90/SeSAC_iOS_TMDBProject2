//
//  CastCrewTableViewCell.swift
//  TMDBProject2
//
//  Created by 이도헌 on 2022/08/06.
//

import UIKit

class CastCrewTableViewCell: UITableViewCell {

    @IBOutlet weak var castCrewImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterOrJobLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCastCell(data: Cast) {
        let url = URL(string: data.profile_path)
        castCrewImageView.kf.setImage(with: url)
        nameLabel.text = data.name
        characterOrJobLabel.text = data.character
    }
    
    func configCrewCell(data: Crew) {
        let url = URL(string: data.profile_path)
        castCrewImageView.kf.setImage(with: url)
        nameLabel.text = data.name
        characterOrJobLabel.text = data.job
    }
}

extension CastCrewTableViewCell: CellLayout {
    func layout() {
        castCrewImageView.layer.cornerRadius = 5
        castCrewImageView.contentMode = .scaleAspectFill
        
        nameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        characterOrJobLabel.font = .systemFont(ofSize: 13)
    }
}
