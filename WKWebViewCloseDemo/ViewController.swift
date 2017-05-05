//
//  ViewController.swift
//  WKWebViewCloseDemo
//
//  Created by liupeng on 05/05/2017.
//  Copyright © 2017 liupeng. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSWindowDelegate {
    var mywebview: BrowserWebView!
    var canClose = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.mywebview = BrowserWebView(frame: CGRect(x: 0, y: 0, width: 800, height: 800))
        self.mywebview.browserWebViewDelegate = self
//         let mywebview = BrowserWKWebView(frame: CGRect(x: 0, y: 0, width: 800, height: 800))
        self.view.addSubview(self.mywebview)
        
//        let button: NSButton = NSButton(frame: CGRect(x: 700, y: 700, width: 100, height: 100))
//        button.title = "reload"
//        button.action = #selector(ViewController.buttonClick)
//        self.view.addSubview(button)
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        //handle window close event
        self.view.window?.delegate = self
    }
    
    func buttonClick()  {
        
    }
    
    func windowShouldClose(_ sender: Any) -> Bool{
        self.mywebview.closeWebPage()
        return self.canClose
    }
    

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
    }
    
}

extension ViewController: BrowserWebViewDelegate {
    func browserWebViewWillClose() {
        self.canClose = true
        self.view.window?.close()
    }
}

