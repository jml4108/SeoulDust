//
//  MaskViewController.swift
//  SeoulDust
//
//  Created by jmlee on 2021/06/12.
//

import UIKit
import WebKit

class MaskViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlKorString = "https://msearch.shopping.naver.com/search/all?query=마스크&frm=NVSHSRC&cat_id=&pb=true&mall="
        guard let urlString = urlKorString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        // Do any additional setup after loading the view.
    }

}
