//
//  InupiaqKeyboard.swift
//
//  Created by Grant Magdanz on 9/24/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

import UIKit

class InupiaqKeyboard: KeyboardViewController {
    
    let takeDebugScreenshot: Bool = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        UserDefaults.standard
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func keyPressed(_ key: Key) {
        let textDocumentProxy = self.textDocumentProxy
        let keyOutput = key.outputForCase(self.shiftState.uppercase())
        
        if key.type == .Character || key.type == .SpecialCharacter {
            let context = textDocumentProxy.documentContextBeforeInput
            if context != nil {
                if context!.characters.count < 2 {
                    textDocumentProxy.insertText(keyOutput)
                    return
                }
                
                var index = context!.endIndex
                
                index = context!.index(before: index)
                if context![index] != " " {
                    textDocumentProxy.insertText(keyOutput)
                    return
                }
                
                index = context!.index(before: index)
                if context![index] == " " {
                    textDocumentProxy.insertText(keyOutput)
                    return
                }

                textDocumentProxy.insertText(keyOutput)
                return
            }
            else {
                textDocumentProxy.insertText(keyOutput)
                return
            }
        }
        else {
            textDocumentProxy.insertText(keyOutput)
            return
        }
    }
    
    override func setupKeys() {
        super.setupKeys()
        
        if takeDebugScreenshot {
            if self.layout == nil {
                return
            }
            
            for page in keyboard.pages {
                for rowKeys in page.rows {
                    for key in rowKeys {
                        if let keyView = self.layout!.viewForKey(key) {
                            keyView.addTarget(self, action: "takeScreenshotDelay", for: .touchDown)
                        }
                    }
                }
            }
        }
    }
    
    override func createBanner() -> ExtraView? {
        return Banner(globalColors: type(of: self).globalColors, darkMode: false, solidColorMode: self.solidColorMode())
    }
}
