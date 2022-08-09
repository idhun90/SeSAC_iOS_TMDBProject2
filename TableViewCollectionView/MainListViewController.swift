import UIKit

class MainListViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    let colorList: [UIColor] = [.systemGreen, .systemGray, .systemPink, .systemBlue, .systemBrown, .systemOrange, .systemPurple]
    let sectionTitle = ["아는 와이프와 비슷한 콘텐츠", "미스터 션샤인과 비슷한 콘텐츠", "액션 SF", "미국 TV 프로그램"]
    let numberList: [[Int]] = [
        [Int](100...110),
        [Int](50...70),
        [Int](200...210),
        [Int](51...60),
        [Int](70...90)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.dataSource = self
        mainTableView.delegate = self
        
        let nib = UINib(nibName: MainTableViewCell.ReusableIdentifier, bundle: nil)
        mainTableView.register(nib, forCellReuseIdentifier: MainTableViewCell.ReusableIdentifier)
        
        view.backgroundColor = .black
        mainTableView.backgroundColor = .clear
        
        // 안됨
        // mainTableView.rowHeight = UITableView.automaticDimension
        // mainTableView.estimatedRowHeight = 200
        
    }
    
}

extension MainListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.ReusableIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        cell.listCollectionView.delegate = self
        cell.listCollectionView.dataSource = self
        cell.titleLabel.text = sectionTitle[indexPath.section]
        cell.listCollectionView.tag = indexPath.section
        print(indexPath.section)
        
        
        let cellNib = UINib(nibName: ListCollectionViewCell.ReusableIdentifier, bundle: nil)
        cell.listCollectionView.register(cellNib, forCellWithReuseIdentifier: ListCollectionViewCell.ReusableIdentifier)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (UIScreen.main.bounds.height * 0.2 + 10 + 28 + 5) // 높이가 item 및 여백 합한 값과 딱 같을 경우 콘솔창에 아이템 높이는 컬렉션 뷰 상, 하 여백 을 뺀 값보다 작아야 한다고 한다. 딱 같아도 콘솔 오류가 뜸.

    }
    
}

extension MainListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberList[collectionView.tag].count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.ReusableIdentifier, for: indexPath) as? ListCollectionViewCell else { return UICollectionViewCell() }
        print("======= \(indexPath.section): \(indexPath.item) ========")
        
        return cell
    }
}
