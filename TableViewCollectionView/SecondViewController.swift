//
//  SecondViewController.swift
//  TMDBProject2
//
//  Created by 이도헌 on 2022/08/17.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var goToMainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        introLabel.font = .boldSystemFont(ofSize: 30)
        introLabel.textColor = .white
        
        goToMainButton.setTitle("이동", for: .normal)
        goToMainButton.setTitleColor(.black, for: .normal)
        goToMainButton.tintColor = .systemOrange
    }

    @IBAction func goToMainButtonClicked(_ sender: UIButton) {
        
        print("클릭됨")
        
        UserDefaults.standard.set(true, forKey: "Intro")
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let sb = UIStoryboard(name: "MainView", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: MainListViewController.reuseIdentifier) as! MainListViewController
        
        let nav = UINavigationController(rootViewController: vc)
        
        sceneDelegate?.window?.rootViewController = nav
        sceneDelegate?.window?.makeKeyAndVisible()
        
    }
}
