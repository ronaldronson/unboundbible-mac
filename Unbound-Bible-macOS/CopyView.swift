//
//  CopyView.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Cocoa

struct CopyOptions : OptionSet {
    let rawValue: Int
    static let abbreviate = CopyOptions(rawValue: 1 << 0)
    static let  quotation = CopyOptions(rawValue: 1 << 1)
    static let  enumerate = CopyOptions(rawValue: 1 << 2)
    static let endinglink = CopyOptions(rawValue: 1 << 3)
}

var copyOptions: CopyOptions = []

var copyView = CopyView()

class CopyView: NSViewController {

    @IBOutlet weak var textView: NSTextView!
    
    @IBOutlet weak var abbreviateButton: NSButton!
    @IBOutlet weak var quotationButton: NSButton!
    @IBOutlet weak var enumeratedButton: NSButton!
    @IBOutlet weak var endingButton: NSButton!
    @IBOutlet weak var defaultButton: NSButton!
    
    var options: CopyOptions = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        copyView = self
    }
    
    override func viewDidAppear() {
        super.viewWillAppear()

        self.view.window!.styleMask.remove(NSWindow.StyleMask.fullScreen)
        self.view.window!.styleMask.remove(NSWindow.StyleMask.resizable )
        self.view.window!.styleMask.remove(NSWindow.StyleMask.closable  )
        
        view.window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        view.window?.standardWindowButton(.zoomButton       )?.isHidden = true
        view.window?.standardWindowButton(.closeButton      )?.isHidden = true
        
        options = copyOptions
        
        abbreviateButton.state = NSControl.StateValue(rawValue: options.contains(.abbreviate) ? 1 : 0)
         quotationButton.state = NSControl.StateValue(rawValue: options.contains(.quotation ) ? 1 : 0)
        enumeratedButton.state = NSControl.StateValue(rawValue: options.contains(.enumerate ) ? 1 : 0)
            endingButton.state = NSControl.StateValue(rawValue: options.contains(.endinglink) ? 1 : 0)
        
        textView.textStorage?.setAttributedString(copyVerses(options: options))
    }
    
    @IBAction func checkButtonAction(_ sender: NSButton) {
        options = []
        
        if abbreviateButton.state.rawValue == 1 { options.insert(.abbreviate) }
        if  quotationButton.state.rawValue == 1 { options.insert(.quotation ) }
        if enumeratedButton.state.rawValue == 1 { options.insert(.enumerate ) }
        if     endingButton.state.rawValue == 1 { options.insert(.endinglink) }
        
        textView.textStorage?.setAttributedString(copyVerses(options: options))
    }
    
    @IBAction func copyButtonAction(_ sender: NSButton) {
        copyVerses(options: options).copyToPasteboard()
        if defaultButton.state.rawValue == 1 { copyOptions = options }
        self.dismiss(self)
    }
    
    @IBAction func cancelButtonAction(_ sender: NSButton) {
        self.dismiss(self)
    }
    
}