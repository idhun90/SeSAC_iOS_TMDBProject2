import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var MainCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainCollectionView.delegate = self
        MainCollectionView.dataSource = self
        
        let nib = UINib(nibName: MainCollectionViewCell.ReusableIdentifier, bundle: nil)
        MainCollectionView.register(nib, forCellWithReuseIdentifier: MainCollectionViewCell.ReusableIdentifier)
        collectionViewLayout()
    }
    
    func collectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 7
        let itemCount: CGFloat = 1
        
        let width = (UIScreen.main.bounds.width - spacing * (itemCount + 1)) / itemCount
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        MainCollectionView.collectionViewLayout = layout
    }

}

//MARK: - CollectionView Protocol 채택
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = MainCollectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.ReusableIdentifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}
