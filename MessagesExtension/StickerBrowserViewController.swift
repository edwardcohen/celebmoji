//
//  StickerBrowserViewController.swift
//  celebmoji
//
//  Created by alexei on 9/9/16.
//  Copyright © 2016 zelig. All rights reserved.
//

import Messages
import UIKit

class StickerBrowserViewController: UIViewController, MSStickerBrowserViewDataSource {
    @IBOutlet var buttonBack: UIButton!
    @IBOutlet var labelPackName: UILabel!
    @IBOutlet var stickerBrowserView: MSStickerBrowserView!
    
    var packName: String!
    var stickerNames = [String]()
    var stickers = [MSSticker]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelPackName.text = packName
        for stickerName in stickerNames {
            createSticker(name: stickerName)
        }
        
        stickerBrowserView.dataSource = self
    }
    
    func createSticker(name: String) {
        let sticker: MSSticker = {
            let bundle = Bundle.main
            guard let placeholderURL = bundle.url(forResource: name, withExtension: "png") else {
                fatalError("Unable to find placeholder sticker image")
            }
            do {
                let description = NSLocalizedString(name, comment: "")
                return try MSSticker(contentsOfFileURL: placeholderURL, localizedDescription: description)
            }
            catch {
                fatalError("Failed to create placeholder sticker: \(error)")
            }
        }()
        stickers.append(sticker)
    }
    
    func numberOfStickers(in stickerBrowserView: MSStickerBrowserView) -> Int {
        return stickers.count
    }
    
    func stickerBrowserView(_ stickerBrowserView: MSStickerBrowserView,
                                     stickerAt index: Int) -> MSSticker {
        return stickers[index]
    }
    
    @IBAction func actionBack() {
        let messagesVC = UIStoryboard(name: "MainInterface", bundle: nil).instantiateViewController(withIdentifier: "MessagesViewController") as! MessagesViewController
        OperationQueue.main.addOperation {
            self.present(messagesVC, animated: false, completion: nil)
        }
    }
    
}
