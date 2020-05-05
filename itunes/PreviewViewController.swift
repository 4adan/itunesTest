//
//  PreviewViewController.swift
//  itunes
//
//  Created by Argueta, Adan (CHICO-C) on 5/4/20.
//  Copyright © 2020 Argueta, Adan. All rights reserved.
//

import UIKit
import WebKit

class PreviewViewController: UIViewController {

    var url: String = ""
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.load(URLRequest.init(url: URL.init(string: url)!))
    }
    

}
