//
//  StickerBrowserViewController.swift
//  celebmoji
//
//  Created by alexei on 9/9/16.
//  Copyright © 2016 zelig. All rights reserved.
//

import Messages
import UIKit

class StickerBrowserViewController: MSStickerBrowserViewController {
    
    var stickers = [MSSticker]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSticker(name: "Beiber")
        createSticker(name: "Bernie")
        createSticker(name: "Beyonce")
        createSticker(name: "Chance")
        createSticker(name: "Drake")
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
    
    override func numberOfStickers(in stickerBrowserView: MSStickerBrowserView) -> Int {
        return stickers.count
    }
    
    override func stickerBrowserView(_ stickerBrowserView: MSStickerBrowserView,
                                     stickerAt index: Int) -> MSSticker {
        return stickers[index]
    }
    
}
