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
        
        AF.request(meURL).responseJSON { response in
            guard let responseData = response.data else { return }
            let decoder = JSONDecoder.init()
            
            guard let meSystems = try? decoder.decode(MeSystems.self, from: responseData) else {
                print("Failed to decode ME Systems")
                return
            }
            
            if meSystems.oldBase.active {
                self.meUsageLabel.isHidden = false
                self.meEUValueLabel.textColor = UIColor.label
                self.meEUValueLabel.text = "\(meSystems.oldBase.powerConsumption)"
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

        AF.request(pssURL).responseJSON { response in
            guard let responseData = response.data else { return }
            let decoder = JSONDecoder.init()
            
            guard let pssSystems = try? decoder.decode(PowerPacks.self, from: responseData) else {
                print("Failed to decode PowerPack Systems")
                return
            }
            
            guard let powerPack = pssSystems.mountain else { return }
            
            if powerPack.change >= 0 {
                self.powerEuChangeLabel.textColor = UIColor.systemGreen
                self.powerEuChangeLabel.text = "+\(powerPack.change) EU/t"
            } else {
                self.powerEuChangeLabel.textColor = UIColor.systemPink
                self.powerEuChangeLabel.text = "\(powerPack.change)) EU/t"
            }


            if powerPack.maintenance {
                self.powerProgressView.progressTintColor = UIColor.systemPink
                self.powerStatusLabel.textColor = UIColor.systemPink
                self.powerStatusLabel.text = "Has maintenance issues"
            } else {
                self.powerProgressView.progressTintColor = UIColor.systemGreen
                self.powerStatusLabel.textColor = UIColor.systemGreen
                self.powerStatusLabel.text = "No issues"
            }

            let percentage = Float(powerPack.stored) / Float(powerPack.capacity)
            self.powerProgressView.progress = percentage
            let percentageInt = Int(percentage * 1000)
            let percentageFloat = percentageInt / 10
            self.powerPercentLabel.text = "\(percentageFloat) %"

            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let storageString = numberFormatter.string(from: NSNumber(value: powerPack.stored)) ?? "0"
            let capacityString = numberFormatter.string(from: NSNumber(value: powerPack.capacity)) ?? "1"
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
