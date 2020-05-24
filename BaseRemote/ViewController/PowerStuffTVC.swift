//
//  PowerStuffTVC.swift
//  BaseRemote
//
//  Created by Lucy Prögler on 24.05.20.
//  Copyright © 2020 Lucy. All rights reserved.
//

import UIKit
import Alamofire

class PowerStuffTVC: UITableViewController {
    
    // Storage
    @IBOutlet weak var mountainIssues: UILabel!
    @IBOutlet weak var mountainProgress: UIProgressView!
    @IBOutlet weak var mountainPercent: UILabel!
    @IBOutlet weak var mountainChange: UILabel!
    @IBOutlet weak var mountainDetail: UILabel!
    
    @IBOutlet weak var towerIssues: UILabel!
    @IBOutlet weak var towerProgress: UIProgressView!
    @IBOutlet weak var towerPercent: UILabel!
    @IBOutlet weak var towerChange: UILabel!
    @IBOutlet weak var towerDetail: UILabel!
    
    @IBOutlet weak var chemIssues: UILabel!
    @IBOutlet weak var chemProgress: UIProgressView!
    @IBOutlet weak var chemPercent: UILabel!
    @IBOutlet weak var chemChange: UILabel!
    @IBOutlet weak var chemDetail: UILabel!
    
    // Production
    @IBOutlet weak var damTotal: UILabel!
    @IBOutlet weak var damTurbineView: UIView!
    @IBOutlet weak var turbine11image: UIImageView!
    @IBOutlet weak var turbine12image: UIImageView!
    @IBOutlet weak var turbine13image: UIImageView!
    @IBOutlet weak var turbine14image: UIImageView!
    @IBOutlet weak var turbine15image: UIImageView!
    @IBOutlet weak var turbine16image: UIImageView!
    @IBOutlet weak var turbine17image: UIImageView!
    @IBOutlet weak var turbine21image: UIImageView!
    @IBOutlet weak var turbine22image: UIImageView!
    @IBOutlet weak var turbine23image: UIImageView!
    @IBOutlet weak var turbine24image: UIImageView!
    @IBOutlet weak var turbine25image: UIImageView!
    @IBOutlet weak var turbine26image: UIImageView!
    @IBOutlet weak var turbine27image: UIImageView!
    @IBOutlet weak var turbine11prod: UILabel!
    @IBOutlet weak var turbine12prod: UILabel!
    @IBOutlet weak var turbine13prod: UILabel!
    @IBOutlet weak var turbine14prod: UILabel!
    @IBOutlet weak var turbine15prod: UILabel!
    @IBOutlet weak var turbine16prod: UILabel!
    @IBOutlet weak var turbine17prod: UILabel!
    @IBOutlet weak var turbine21prod: UILabel!
    @IBOutlet weak var turbine22prod: UILabel!
    @IBOutlet weak var turbine23prod: UILabel!
    @IBOutlet weak var turbine24prod: UILabel!
    @IBOutlet weak var turbine25prod: UILabel!
    @IBOutlet weak var turbine26prod: UILabel!
    @IBOutlet weak var turbine27prod: UILabel!
    
    @IBOutlet weak var chemSolarTotal: UILabel!
    @IBOutlet weak var chemSolarView: UIView!
    @IBOutlet weak var chemArrayN1: UILabel!
    @IBOutlet weak var chemArrayN2: UILabel!
    @IBOutlet weak var chemArrayE1: UILabel!
    @IBOutlet weak var chemArrayE2: UILabel!
    @IBOutlet weak var chemArrayS1: UILabel!
    @IBOutlet weak var chemArrayS2: UILabel!
    @IBOutlet weak var chemArrayW1: UILabel!
    @IBOutlet weak var chemArrayW2: UILabel!
    
    @IBOutlet weak var mountainWindTotal: UILabel!
    @IBOutlet weak var mountainWindView: UIView!
    @IBOutlet weak var mountainWindTurbine1: UILabel!
    
    private var timer: Timer?
    
    // MARK: - View Stuff -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        damTurbineView.layer.cornerRadius = 8
        chemSolarView.layer.cornerRadius = 8
        mountainWindView.layer.cornerRadius = 8
        
        let animatedWhite = UIImage.gifImageWithName("turbine-animated-white")
        turbine11image.image = animatedWhite
        turbine12image.image = animatedWhite
        turbine13image.image = animatedWhite
        turbine14image.image = animatedWhite
        turbine15image.image = animatedWhite
        turbine16image.image = animatedWhite
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
        updateUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
    
    // MARK: - Update UI -
    
    @objc func updateUI() {
        guard let genUrl = PowerStuffTVC.getPowerURL() else { return }
        guard let storageUrl = OverviewVC.getPssUrl() else { return }
        
        AF.request(genUrl).responseJSON { response in
            guard let responseData = response.data else { return }
            let decoder = JSONDecoder.init()
            
            guard let powerGens = try? decoder.decode(PowerGens.self, from: responseData) else {
                print("Failed to decode Power Gens")
                return
            }
            
            self.got(powerGens)
        }
        
        AF.request(storageUrl).responseJSON { response in
            guard let responseData = response.data else { return }
            let decoder = JSONDecoder.init()
            
            guard let powerPacks = try? decoder.decode(PowerPacks.self, from: responseData) else {
                print("Failed to decode Power Packs")
                return
            }
            
            self.got(powerPacks)
        }
    }
    
    // MARK: - Storage -
    
    private func got(_ powerPacks: PowerPacks) {
        if let mountainPack = powerPacks.mountain {
            setView(for: mountainPack, issueLabel: mountainIssues, progressBar: mountainProgress, percentLabel: mountainPercent, changeLabel: mountainChange, detailLabel: mountainDetail)
        }
        
        if let chemPack = powerPacks.chem {
            setView(for: chemPack, issueLabel: chemIssues, progressBar: chemProgress, percentLabel: chemPercent, changeLabel: chemChange, detailLabel: chemDetail)
        }
        
        if let towerPack = powerPacks.tower {
            setView(for: towerPack, issueLabel: towerIssues, progressBar: towerProgress, percentLabel: towerPercent, changeLabel: towerChange, detailLabel: towerDetail)
        }
    }
    
    private func setView(for powerPack: PowerPack, issueLabel: UILabel, progressBar: UIProgressView, percentLabel: UILabel, changeLabel: UILabel, detailLabel: UILabel) {
        if powerPack.change >= 0 {
            changeLabel.textColor = UIColor.systemGreen
            changeLabel.text = "+\(powerPack.change) EU/t"
        } else {
            changeLabel.textColor = UIColor.systemPink
            changeLabel.text = "\(powerPack.change) EU/t"
        }
        
        if powerPack.maintenance {
            progressBar.progressTintColor = UIColor.systemPink
            issueLabel.textColor = UIColor.systemPink
            issueLabel.text = "Has maintenance issues"
        } else {
            progressBar.progressTintColor = UIColor.systemGreen
            issueLabel.textColor = UIColor.systemGreen
            issueLabel.text = "No issues"
        }
        
        let percentage = Float(powerPack.stored) / Float(powerPack.capacity)
        progressBar.progress = percentage
        let percentageInt = Int(percentage * 1000)
        let percentageFloat = Float(percentageInt) / 10
        percentLabel.text = "\(percentageFloat) %"

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let storageString = numberFormatter.string(from: NSNumber(value: powerPack.stored)) ?? "0"
        let capacityString = numberFormatter.string(from: NSNumber(value: powerPack.capacity)) ?? "1"
        detailLabel.text = storageString + " / " + capacityString + " EU"
    }
    
    // MARK: - Generation -
    
    private func got(_ powerGens: PowerGens) {
        var damTotal = 0
        var chemTotal = 0
        
        for (location, gen) in powerGens.getDamGens() {
            set(production: gen?.production ?? 0, for: location)
            damTotal += gen?.production ?? 0
        }
        self.damTotal.text = "\(damTotal)"
        
        for (location, gen) in powerGens.getChemGens() {
            set(production: gen?.production ?? 0, for: location)
            chemTotal += gen?.production ?? 0
        }
        self.chemSolarTotal.text = "\(chemTotal)"
        
        set(production: powerGens.mountainWind?.production ?? 0, for: .mountainWind)
    }
    
    private func set(production: Int, for location: PowerGenLocation) {
        let image = production == 0 ? UIImage.init(named: "turbine") : UIImage.gifImageWithName("turbine-animated-white")
        switch location {
        case .dam11: turbine11prod.text = "\(production)"; turbine11image.image = image
        case .dam12: turbine12prod.text = "\(production)"; turbine12image.image = image
        case .dam13: turbine13prod.text = "\(production)"; turbine13image.image = image
        case .dam14: turbine14prod.text = "\(production)"; turbine14image.image = image
        case .dam15: turbine15prod.text = "\(production)"; turbine15image.image = image
        case .dam16: turbine16prod.text = "\(production)"; turbine16image.image = image
        case .dam17: turbine17prod.text = "\(production)"; turbine17image.image = image
        
        case .dam21: turbine21prod.text = "\(production)"; turbine21image.image = image
        case .dam22: turbine22prod.text = "\(production)"; turbine22image.image = image
        case .dam23: turbine23prod.text = "\(production)"; turbine23image.image = image
        case .dam24: turbine24prod.text = "\(production)"; turbine24image.image = image
        case .dam25: turbine25prod.text = "\(production)"; turbine25image.image = image
        case .dam26: turbine26prod.text = "\(production)"; turbine26image.image = image
        case .dam27: turbine27prod.text = "\(production)"; turbine27image.image = image
            
        case .chemN1: chemArrayN1.text = "\(production)"
        case .chemN2: chemArrayN2.text = "\(production)"
        case .chemE1: chemArrayE1.text = "\(production)"
        case .chemE2: chemArrayE2.text = "\(production)"
        case .chemS1: chemArrayS1.text = "\(production)"
        case .chemS2: chemArrayS2.text = "\(production)"
        case .chemW1: chemArrayW1.text = "\(production)"
        case .chemW2: chemArrayW2.text = "\(production)"
            
        case .mountainWind: mountainWindTurbine1.text = "\(production)"; mountainWindTotal.text = "\(production)"
        }
    }
    
    // MARK: - Misc. -
    
    static func getPowerURL() -> URL? {
        guard let path = Bundle.main.path(forResource: "Values", ofType: "plist") else { return nil }
        guard let dict = NSDictionary.init(contentsOfFile: path) else { return nil }
        guard let url = dict["url"] as? String else { return nil }
        guard let powerUrl = dict["pssUrl"] as? String else { return nil }
        return URL.init(string: url + powerUrl)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard UIApplication.shared.applicationState == .inactive else {
            return
        }

        updateAnimations(style: traitCollection.userInterfaceStyle)
    }
    
    private func updateAnimations(style: UIUserInterfaceStyle) {
        // TODO
        if style == .dark {
            
        }
    }
}
