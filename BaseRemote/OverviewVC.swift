//
//  OverviewVC.swift
//  BaseRemote
//
//  Created by Lucy on 23/06/2019.
//  Copyright © 2019 Lucy. All rights reserved.
//

import UIKit
import Alamofire

class OverviewVC: UIViewController {

    @IBOutlet weak var powerProgressView: UIProgressView!
    @IBOutlet weak var powerPercentLabel: UILabel!
    @IBOutlet weak var powerStatusLabel: UILabel!
    @IBOutlet weak var powerEuChangeLabel: UILabel!
    @IBOutlet weak var powerEuLabel: UILabel!
    
    @IBOutlet weak var meUsageLabel: UILabel!
    @IBOutlet weak var meEUValueLabel: UILabel!
    @IBOutlet weak var meEuLabel: UILabel!
    @IBOutlet weak var meToggleButton: UIButton!
    
    private var timer: Timer?
    
    var meStatus = true
    var storage = 0
    var storageI = 0
    var storageHist = [0, 0, 0, 0, 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
    }
    
    static func getMeUrl() -> String? {
        guard let path = Bundle.main.path(forResource: "Values", ofType: "plist") else { return nil }
        guard let dict = NSDictionary.init(contentsOfFile: path) else { return nil }
        guard let url = dict["url"] as? String else { return nil }
        guard let meUrl = dict["meUrl"] as? String else { return nil }
        return url + meUrl
    }
    static func getPssUrl() -> String? {
        guard let path = Bundle.main.path(forResource: "Values", ofType: "plist") else { return nil }
        guard let dict = NSDictionary.init(contentsOfFile: path) else { return nil }
        guard let url = dict["url"] as? String else { return nil }
        guard let meUrl = dict["pssUrl"] as? String else { return nil }
        return url + meUrl
    }
    
    @objc func updateUI() {
        guard let meURL = URL.init(string: OverviewVC.getMeUrl() ?? "") else { return }
        guard let pssURL = URL.init(string: OverviewVC.getPssUrl() ?? "") else { return }
        
        AF.request(meURL).responseString { response in
            guard let responseStr = try? response.result.get() else { return }
            let components = responseStr.components(separatedBy: "/")
            
            self.meStatus = components[0] == "true"
            let euUsage = components[1]
            
            if self.meStatus {
                self.meUsageLabel.isHidden = false
                self.meEUValueLabel.textColor = UIColor.label
                self.meEUValueLabel.text = euUsage
                self.meEuLabel.isHidden = false
                
                self.meToggleButton.setTitle("Turn off", for: .normal)
                self.meToggleButton.titleLabel?.textColor = UIColor.systemPink
            } else {
                self.meUsageLabel.isHidden = true
                self.meEUValueLabel.textColor = UIColor.systemPink
                self.meEUValueLabel.text = "Offline"
                self.meEuLabel.isHidden = true
                
                self.meToggleButton.setTitle("Turn on", for: .normal)
                self.meToggleButton.titleLabel?.textColor = UIColor.systemGreen
            }
        }

        AF.request(pssURL).responseString { response in
            guard let responseStr = try? response.result.get() else { return }
            let components = responseStr.components(separatedBy: "/")
            
            let oldStorage = self.storage
            self.storage = Int(components[0]) ?? 0
            let capacity = Int(components[1]) ?? 1
            let maintenance = components[2] == "true"
            
            self.storageHist[self.storageI] = self.storage - oldStorage
            self.storageI += 1
            if self.storageI >= 5 { self.storageI = 0 }
            
            var change = 0
            for int in self.storageHist {
                change += int
            }
            change = change / self.storageHist.count
            change = change / 20
            if change >= 0 {
                self.powerEuChangeLabel.textColor = UIColor.systemGreen
                self.powerEuChangeLabel.text = "+\(change) EU/t"
            } else {
                self.powerEuChangeLabel.textColor = UIColor.systemPink
                self.powerEuChangeLabel.text = "-\(abs(change)) EU/t"
            }
            
            
            if maintenance {
                self.powerProgressView.progressTintColor = UIColor.systemPink
                self.powerStatusLabel.textColor = UIColor.systemPink
                self.powerStatusLabel.text = "Has maintenance issues"
            } else {
                self.powerProgressView.progressTintColor = UIColor.systemGreen
                self.powerStatusLabel.textColor = UIColor.systemGreen
                self.powerStatusLabel.text = "No issues"
            }
            
            let percentage = Float(self.storage) / Float(capacity)
            self.powerProgressView.progress = percentage
            let percentageInt = Int(percentage * 100)
            self.powerPercentLabel.text = "\(percentageInt) %"
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let storageString = numberFormatter.string(from: NSNumber(value: self.storage)) ?? "0"
            let capacityString = numberFormatter.string(from: NSNumber(value: capacity)) ?? "1"
            self.powerEuLabel.text = storageString + " / " + capacityString + " EU"
        }
    }
    
    @IBAction func toggledMe(_ sender: Any) {
        guard let meURL = OverviewVC.getMeUrl() else { return }
        meStatus = !meStatus
        let string = meURL + "?status=\(meStatus)"
        guard let url = URL.init(string: string) else { return }
        
        _ = AF.request(url)
    }
}
