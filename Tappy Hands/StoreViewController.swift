//  StoreViewController.swift
//  Tappy Hands
//
//  Created by Ernest Delgado on 12/25/17.
//  Copyright © 2017 Ernest Delgado. All rights reserved.
//

import UIKit
import StoreKit

class StoreViewController: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var restoreButton: UIButton!
    
    var product: SKProduct?
    var productID: Set = ["com.smokeyGames.tappyhands.removeAds"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label1.layer.cornerRadius = 5.0
        button1.layer.cornerRadius = 5.0
        buyButton.layer.cornerRadius = 5.0
        restoreButton.layer.cornerRadius = 5.0
        
        buyButton.isEnabled = false
        SKPaymentQueue.default().add(self)
        getPurchaseInfo()
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func purchase(_ sender: Any) {
        
        let payment = SKPayment(product: product!)
        SKPaymentQueue.default().add(payment)
        
    }
    @IBAction func restorePurchases(_ sender: Any) {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func getPurchaseInfo() {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: productID)
            request.delegate = self
            request.start()
        } else {
            productTitle.text = "Warning"
            productDescription.text = "Please enable in app purchases in your settings"
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        var products = response.products
        
        if (products.count == 0) {
            productTitle.text = "Warning"
            productDescription.text = "Product not found!"
        } else {
            product = products[0]
            productTitle.text = product!.localizedTitle
            productDescription.text = product!.localizedDescription
            buyButton.isEnabled = true
        }
        
        let invalids = response.invalidProductIdentifiers
        
        for product in invalids {
            
            print("product not found: \(product)")
            
        }
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                productTitle.text = "Thank You"
                productDescription.text = "The product has been purchased"
                buyButton.isEnabled = false
                
                let save = UserDefaults.standard
                save.set(true, forKey: "purchase")
                
            case SKPaymentTransactionState.restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                productTitle.text = "Thank You"
                productDescription.text = "The product has been purchased"
                buyButton.isEnabled = false
                
                let save = UserDefaults.standard
                save.set(true, forKey: "purchase")
            
            case SKPaymentTransactionState.failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                productTitle.text = "Warning"
                productDescription.text = "The product has not been purchased"
                
            default:
                break
            }
        }
    }
    
    
}
