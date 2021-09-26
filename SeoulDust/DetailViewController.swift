//
//  DetailViewController.swift
//  SeoulDust
//
//  Created by jmlee on 2021/06/12.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    var staionName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let urlKorString = "https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=0&ie=utf8&query=" + staionName + "+미세먼지"
        guard let urlString = urlKorString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        

        // Do any additional setup after loading the view.
    }

}
