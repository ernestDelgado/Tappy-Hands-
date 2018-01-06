//
//  GameViewController.swift
//  Tappy Hands
//
//  Created by Ernest Delgado on 12/17/17.
//  Copyright © 2017 Ernest Delgado. All rights reserved.
//

import UIKit
import GoogleMobileAds

class GameViewController: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var bannerView: GADBannerView!
    var tapInt = 0
    var startInt = 3
    var startTimer = Timer()
    
    var gameInt = 10
    var gameTimer = Timer()
    
    var recordData: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cRaduis: CGFloat = 10
        label1.layer.cornerRadius = cRaduis
        label2.layer.cornerRadius = cRaduis
        button.layer.cornerRadius = cRaduis
        
        tapInt = 0
        scoreLabel.text = String(tapInt)
        
        startInt = 3
        button.setTitle(String(startInt), for: .normal)
        button.isEnabled = false
        
        startTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.startGameTimer), userInfo: nil, repeats: true)
        gameInt = 10
        timeLabel.text = String(gameInt)
        
        let userDefaults = Foundation.UserDefaults.standard
        let value = userDefaults.string(forKey: "Record")
        recordData = value
        
        bannerView.isHidden = true
        bannerView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    
    

    @IBAction func tapMeButton(_ sender: Any) {
        tapInt += 1
        scoreLabel.text = String(tapInt)
    }
    
    
    @objc func startGameTimer() {
        
        startInt -= 1
        button.setTitle(String(startInt), for: .normal)
        
        if startInt == 0 {
            startTimer.invalidate()
            button.setTitle("Tap Me", for: .normal)
            button.isEnabled = true
            gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.game), userInfo: nil, repeats: true)
            
        }
        
    }
    
    @objc func game() {
        gameInt -= 1
        timeLabel.text = String(gameInt)
        
        if gameInt == 0 {
            button.isEnabled = false
            gameTimer.invalidate()
            
            if recordData == nil {
                let savedString = scoreLabel.text
                let userDefaults = Foundation.UserDefaults.standard
                userDefaults.set(savedString, forKey: "Record")
            } else {
                let score: Int? = Int(scoreLabel.text!)
                let record: Int? = Int(recordData)
                
                if score! > record! {
                    let savedString = scoreLabel.text
                    let userDefaults = Foundation.UserDefaults.standard
                    userDefaults.set(savedString, forKey: "Record")
                }
            }
            
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(GameViewController.end), userInfo: nil, repeats: false)
        }
    }
    
    @objc func end() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "endGame") as! endViewController
            vc.scoreData = scoreLabel.text
            self.present(vc, animated: false, completion: nil)
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            let vc = UIStoryboard(name: "iPad", bundle: nil).instantiateViewController(withIdentifier: "endGame") as! endViewController
            vc.scoreData = scoreLabel.text
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        bannerView.isHidden = true
    }
    
    
}
