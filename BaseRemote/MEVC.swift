//
//  ViewController.swift
//  BaseRemote
//
//  Created by Lucy on 18/06/2019.
//  Copyright © 2019 Lucy. All rights reserved.
//

import UIKit
import Alamofire

class MEVC: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    
    private var timer: Timer?
    private var status = false
    
    let url = "http://192.168.178.23:9876/meStatus"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
    }
    
    @objc func updateUI() {
        guard let url = URL.init(string: self.url) else { return }
        AF.request(url).responseString { response in
            if "\(response)" == "success(\"true\")" {
                self.status = true
                self.statusLabel.text = "On"
                print("status true")
            } else {
                self.status = false
                self.statusLabel.text = "Off"
                print("status false")
            }
        }
    }

    @IBAction func toggledME(_ sender: Any) {
        guard let url = URL.init(string: self.url) else { return }
        let parameters: Parameters = ["setStatus": status ? "false" : "true"]
        status = !status
        
        _ = AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil, interceptor: .none)
    }
    
}

