//
//  ViewController.swift
//  Tappy Hands
//
//  Created by Ernest Delgado on 12/17/17.
//  Copyright © 2017 Ernest Delgado. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate {

    
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cRaduis: CGFloat = 10
        label1.layer.cornerRadius = cRaduis
        label2.layer.cornerRadius = cRaduis
        button.layer.cornerRadius = cRaduis
        
        bannerView.isHidden = true
        bannerView.delegate = self
        
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        bannerView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let userDefaults = Foundation.UserDefaults.standard
        let value = userDefaults.string(forKey: "Record")
        
        if value == nil {
            label2.text = "0"
        } else {
            label2.text = value
        }
        
        let save = UserDefaults.standard
        if save.value(forKey: "purchase") == nil {
            bannerView.adUnitID = "ca-app-pub-1445106982369119/6181939246"
            bannerView.adSize = kGADAdSizeSmartBannerPortrait
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        } else {
            bannerView.isHidden = true 
        }
    }

}

