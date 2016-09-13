//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by alexei on 9/9/16.
//  Copyright © 2016 zelig. All rights reserved.
//

import UIKit
import Messages
import StoreKit

class MessagesViewController: MSMessagesAppViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    var purchasedProductIDs = [String]()
//    var purchasedProductIDs = ["bieber", "kim"]
    var productsArray = [SKProduct]()

    var stickerNames = [
        "bieber": ["Bieber (1)", "Bieber (10)", "Bieber (11)", "Bieber (12)", "Bieber (13)", "Bieber (14)", "Bieber (15)", "Bieber (2)", "Bieber (3)", "Bieber (4)", "Bieber (5)", "Bieber (6)", "Bieber (7)", "Bieber (8)", "Bieber (9)"],
        "bernie": ["Bernie (1)", "Bernie (10)", "Bernie (2)", "Bernie (3)", "Bernie (4)", "Bernie (5)", "Bernie (6)", "Bernie (7)", "Bernie (8)", "Bernie (9)"],
        "beyonce": ["Beyonce (1)", "Beyonce (10)", "Beyonce (11)", "Beyonce (12)", "Beyonce (13)", "Beyonce (14)", "Beyonce (15)", "Beyonce (2)", "Beyonce (3)", "Beyonce (4)", "Beyonce (5)", "Beyonce (6)", "Beyonce (7)", "Beyonce (8)", "Beyonce (9)"],
        "chance": ["Chance (1)", "Chance (10)", "Chance (11)", "Chance (12)", "Chance (13)", "Chance (14)", "Chance (15)", "Chance (2)", "Chance (3)", "Chance (4)", "Chance (5)", "Chance (6)", "Chance (7)", "Chance (8)", "Chance (9)"],
        "drake": ["Drake (1)", "Drake (10)", "Drake (2)", "Drake (3)", "Drake (4)", "Drake (5)", "Drake (6)", "Drake (7)", "Drake (8)", "Drake (9)"],
        "frank": ["Frank (1)", "Frank (10)", "Frank (11)", "Frank (12)", "Frank (13)", "Frank (14)", "Frank (15)", "Frank (2)", "Frank (3)", "Frank (4)", "Frank (5)", "Frank (6)", "Frank (7)", "Frank (8)", "Frank (9)"],
        "hillary": ["Hillary (1)", "Hillary (10)", "Hillary (2)", "Hillary (3)", "Hillary (4)", "Hillary (5)", "Hillary (6)", "Hillary (7)", "Hillary (8)", "Hillary (9)"],
        "jayz": ["Jayz (1)", "Jayz (10)", "Jayz (2)", "Jayz (3)", "Jayz (4)", "Jayz (5)", "Jayz (6)", "Jayz (7)", "Jayz (8)", "Jayz (9)"],
        "jerry": ["Jerry (1)", "Jerry (10)", "Jerry (2)", "Jerry (3)", "Jerry (4)", "Jerry (5)", "Jerry (6)", "Jerry (7)", "Jerry (8)", "Jerry (9)"],
        "kanyewest": ["Kanye (1)", "Kanye (10)", "Kanye (11)", "Kanye (12)", "Kanye (13)", "Kanye (14)", "Kanye (15)", "Kanye (2)", "Kanye (3)", "Kanye (4)", "Kanye (5)", "Kanye (6)", "Kanye (7)", "Kanye (8)", "Kanye (9)"],
        "kim": ["Kim (1)", "Kim (10)", "Kim (11)", "Kim (12)", "Kim (13)", "Kim (14)", "Kim (15)", "Kim (2)", "Kim (3)", "Kim (4)", "Kim (5)", "Kim (6)", "Kim (7)", "Kim (8)", "Kim (9)"],
        "taylor": ["Taylor (1)", "Taylor (10)", "Taylor (11)", "Taylor (12)", "Taylor (13)", "Taylor (14)", "Taylor (15)", "Taylor (2)", "Taylor (3)", "Taylor (4)", "Taylor (5)", "Taylor (6)", "Taylor (7)", "Taylor (8)", "Taylor (9)"],
        "trump": ["Trump (1)", "Trump (10)", "Trump (2)", "Trump (3)", "Trump (4)", "Trump (5)", "Trump (6)", "Trump (7)", "Trump (8)", "Trump (9)"]
    ]
    
    var selectedProductIndex: Int!
    var transactionInProgress = false
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestProductInfo()
        
        SKPaymentQueue.default().add(self)
    }
    
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productRequest = SKProductsRequest(productIdentifiers: Set(stickerNames.keys))
            
            productRequest.delegate = self
            productRequest.start()
        } else {
            print("Cannot perform In App Purchases.")
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product)
                
                let purchased = UserDefaults.standard.bool(forKey: product.productIdentifier)
                if purchased {
                    purchasedProductIDs.append(product.productIdentifier)
                }
                
            }
            OperationQueue.main.addOperation {
                self.collectionView.reloadData()
            }
        } else {
            print("There are no products.")
        }
        
        if response.invalidProductIdentifiers.count != 0 {
            print(response.invalidProductIdentifiers.description)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                print("Transaction completed successfully.")
                SKPaymentQueue.default().finishTransaction(transaction)
                purchasedProductIDs.append(productsArray[selectedProductIndex].productIdentifier)
                UserDefaults.standard.set(true, forKey: productsArray[selectedProductIndex].productIdentifier)
                OperationQueue.main.addOperation {
                    self.collectionView.reloadData()
                }
                transactionInProgress = false
            case .failed:
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
            default:
                print(transaction.transactionState.rawValue)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }
}

extension MessagesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.imageView.image = UIImage(named: productsArray[indexPath.row].productIdentifier)
        if purchasedProductIDs.contains(productsArray[indexPath.row].productIdentifier) {
            cell.imageView.alpha = 1.0
        } else {
            cell.imageView.alpha = 0.5
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if transactionInProgress {
            return
        }
        
        selectedProductIndex = indexPath.row
        
        if purchasedProductIDs.contains(productsArray[selectedProductIndex].productIdentifier) {
            showStickerBrowser(index: indexPath.row)
        } else {
            let payment = SKPayment(product: productsArray[selectedProductIndex])
            SKPaymentQueue.default().add(payment)
            transactionInProgress = true
        }
    }
    
    func showStickerBrowser(index: Int) {
        let stickerBrowserVC = UIStoryboard(name: "MainInterface", bundle: nil).instantiateViewController(withIdentifier: "StickerBrowserViewController") as! StickerBrowserViewController
        stickerBrowserVC.packName = productsArray[index].productIdentifier
        stickerBrowserVC.stickerNames = stickerNames[productsArray[index].productIdentifier]!
        OperationQueue.main.addOperation {
            self.present(stickerBrowserVC, animated: false, completion: nil)
        }
    }
}
