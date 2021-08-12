//
//  DetailViewController.swift
//  Project16-Maps
//
//  Created by Matheus Lenke on 12/08/21.
//

import UIKit
import WebKit

class DetailViewController: ViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var url: URL?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let safeUrl = url {
            openPage(url: safeUrl)
        }
    }
    
    func openPage(url: URL) {
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
