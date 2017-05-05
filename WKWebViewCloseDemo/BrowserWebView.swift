//
//  BrowserWebView.swift
//  WKWebViewCloseDemo
//
//  Created by liupeng on 05/05/2017.
//  Copyright © 2017 liupeng. All rights reserved.
//

import Cocoa
import WebKit

@objc
protocol BrowserWebViewDelegate: class {
    
    func browserWebViewWillClose()
}

class BrowserWebView: NSView {
    var mywebview: WebView!
    weak var browserWebViewDelegate: BrowserWebViewDelegate?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonUI()
    }
    
    func commonUI(){
        self.mywebview = WebView(frame: NSMakeRect(0, 0, self.frame.width, self.bounds.height))
        self.mywebview.frameLoadDelegate = self
        self.mywebview.policyDelegate = self
        self.mywebview.uiDelegate = self
        self.mywebview.shouldCloseWithWindow = true
        
        self.addSubview(self.mywebview)
        
        let button: NSButton = NSButton(frame: CGRect(x: 700, y: 700, width: 100, height: 100))
        button.title = "close web"
        button.action = #selector(BrowserWebView.buttonClick)
        self.addSubview(button)
        
        loadHtml()
        
    }
    
    func buttonClick()  {
       Swift.print(#function)
//       self.mywebview.mainFrame.reload()//"about:bank"
        guard let bankURL = getBankHtmlURL() else {
            return
        }
        self.mywebview.mainFrame.load(URLRequest(url: bankURL))
    }
    
    private func loadHtml(){
//        if let path = Bundle.main.path(forResource: "demo", ofType: "html", inDirectory: nil) {
//            //            self.mywebview.load(URLRequest(url: URL(fileURLWithPath: path)) )
//            self.mywebview.mainFrame.load(URLRequest(url: URL(fileURLWithPath: path)))
//        }
        let onbeforeunloadUrl = NSURL(string: "http://www.w3cschool.cn/tryrun/showhtml/tryjsref_onbeforeunload")!
//        let normalPageUrl = NSURL(string: "http://www.w3cschool.cn/jsref/jsref-event-onbeforeunload.html")!
        self.mywebview.mainFrame.load(NSURLRequest(url: onbeforeunloadUrl as URL) as URLRequest!)
    }
    
    func closeWebPage(){
        guard let bankURL = getBankHtmlURL() else {
            return
        }
        self.mywebview.mainFrame.load(URLRequest(url: bankURL))
    }
    
    func getBankHtmlURL()-> URL? {
        if let path = Bundle.main.path(forResource: "bank", ofType: "html", inDirectory: nil) {
           return URL(fileURLWithPath: path)
        }
        return nil
    }
    
}

extension BrowserWebView: WebUIDelegate {
    
    public func webView(_ sender: WebView!, createWebViewWith request: URLRequest!) -> WebView!
    {
        Swift.print(#function)
        return WebView(frame: self.frame)
    }
    
    public func webView(_ sender: WebView!, runJavaScriptAlertPanelWithMessage message: String!, initiatedBy frame: WebFrame!)
    {
        Swift.print(#function)
        let alert: NSAlert = NSAlert()
        alert.messageText = "runJavaScriptAlertPanelWithMessage"
        alert.informativeText = message
        alert.alertStyle = NSAlertStyle.warning
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.runModal()
    }
    
    public func webView(_ sender: WebView!, runJavaScriptConfirmPanelWithMessage message: String!, initiatedBy frame: WebFrame!) -> Bool
    {
        Swift.print(#function)
        let alert: NSAlert = NSAlert()
        alert.messageText = "runJavaScriptConfirmPanelWithMessage"
        alert.informativeText = message
        alert.alertStyle = NSAlertStyle.warning
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        return alert.runModal() == NSAlertFirstButtonReturn
    }
    
    
    public func webView(_ sender: WebView!, runBeforeUnloadConfirmPanelWithMessage message: String!, initiatedBy frame: WebFrame!) -> Bool
    {
        Swift.print(#function)
        let alert: NSAlert = NSAlert()
        alert.messageText = "Are you sure you want to leave this page?"
        alert.informativeText = message
        alert.alertStyle = NSAlertStyle.warning
        alert.addButton(withTitle: "Leave Page")
        alert.addButton(withTitle: "Stay on Page")
        let willClosePage = alert.runModal() == NSAlertFirstButtonReturn
        if willClosePage {
            Swift.print("close page")
            sender.isHidden = true
            sender.mainFrame.stopLoading()
            self.browserWebViewDelegate?.browserWebViewWillClose()
        }
        return willClosePage
    }
}

extension BrowserWebView: WebFrameLoadDelegate {
    
    func webView(_ sender: WebView!, didFinishLoadFor frame: WebFrame!) {
        Swift.print(#function)
    }
    
    func webView(_ sender: WebView!, didFailLoadWithError error: Error!, for frame: WebFrame!) {
        Swift.print(#function)
    }
    
    func webView(_ sender: WebView!, didStartProvisionalLoadFor frame: WebFrame!) {
        Swift.print(#function)
        if sender.mainFrameURL == getBankHtmlURL()?.absoluteString  {
            browserWebViewDelegate?.browserWebViewWillClose()
        }
    }
    
    func webView(_ sender: WebView!, willClose frame: WebFrame!){
        Swift.print(#function)
    }
    
}

extension BrowserWebView : WebPolicyDelegate {
    
    public func webView(_ webView: WebView!, decidePolicyForNavigationAction actionInformation: [AnyHashable : Any]!, request: URLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!)
    {
        Swift.print(#function)
        Swift.print(request)
        listener.use()
    }
    
    public func webView(_ webView: WebView!, decidePolicyForNewWindowAction actionInformation: [AnyHashable : Any]!, request: URLRequest!, newFrameName frameName: String!, decisionListener listener: WebPolicyDecisionListener!)
    {
        Swift.print(#function)
        listener.use()
    }
    
    public func webView(_ webView: WebView!, decidePolicyForMIMEType type: String!, request: URLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!)
    {
        Swift.print(#function)
        Swift.print(type)
        listener.use()
    }
    
    public func webView(_ webView: WebView!, unableToImplementPolicyWithError error: Error!, frame: WebFrame!)
    {
        Swift.print(#function)
    }
}
