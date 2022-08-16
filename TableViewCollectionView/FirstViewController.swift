//
//  FirstViewController.swift
//  TMDBProject2
//
//  Created by 이도헌 on 2022/08/17.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var introLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        introLabel.contentMode = .center
        introLabel.font = .boldSystemFont(ofSize: 30)
        introLabel.textColor = .white
        
    }

}
