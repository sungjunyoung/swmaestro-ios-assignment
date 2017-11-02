//
//  WebViewController.swift
//  swmaestro_ios_assignment
//
//  Created by 성준영 on 2017. 11. 2..
//  Copyright © 2017년 성준영. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    var startUrl: String = ""
    
    @IBAction func onBackWebView(_ sender: Any) {
        webview.goBack()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        webview.stopLoading()
    }
    
    
    @IBAction func onFrontWebView(_ sender: Any) {
        webview.goForward()
    }
    
    @IBAction func onRefresh(_ sender: Any) {
        webview.reload()
    }
    
    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: self.startUrl) {
            let request = URLRequest(url: url)
            print(request)
            print("loading")
            webview.load(request)
            print("loading end")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
