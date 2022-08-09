//
//  MainTableViewCell.swift
//  TMDBProject2
//
//  Created by 이도헌 on 2022/08/09.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layout()
    }
    
    func cellConfigure() {
        
    }
    
    func layout() {
    
        titleLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        titleLabel.textColor = .white
        
//        self.backgroundColor = .systemGreen
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
//        self.backgroundColor = .clear
        listCollectionView.backgroundColor = .black
        listCollectionView.collectionViewLayout = collectionViewLayout()
        
        // 컬렉션뷰 스크롤 인디케이터 안 보이기 설정
        listCollectionView.showsHorizontalScrollIndicator = false
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.2)
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        layout.scrollDirection = .horizontal
        
        return layout
    }

}
