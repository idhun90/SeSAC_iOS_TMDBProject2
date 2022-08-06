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
    @IBOutlet weak var jobLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
