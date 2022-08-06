//
//  WebViewController.swift
//  TMDBProject2
//
//  Created by 이도헌 on 2022/08/07.
//

import UIKit
import WebKit

import Alamofire
import SwiftyJSON

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var key: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(dismissView))
            
        openWeb(url: key!)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func openWeb(url: String) {
        let stringUrl = EndPoint.youtube + url
        guard let url = URL(string: stringUrl) else {
            print("유효하지 않은 주소")
                return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
