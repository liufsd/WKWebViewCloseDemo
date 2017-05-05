//
//  BrowserWKWebView.swift
//  WKWebViewCloseDemo
//
//  Created by liupeng on 05/05/2017.
//  Copyright © 2017 liupeng. All rights reserved.
//

import Cocoa
import WebKit

class BrowserWKWebView: NSView {
   var mywebview: WKWebView!
    
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
        let configure = WKWebViewConfiguration()
        let js = "window.webkit.messageHandlers.skhtml.postMessage(document.documentElement.innerHTML);"
        let wkUserScript = WKUserScript(source: js, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: false)
        
        configure.userContentController.addUserScript(wkUserScript)
        
        let cookiesJs = "window.webkit.messageHandlers.skcookies.postMessage(document.cookie);"
        let cookiesWKUserScript = WKUserScript(source: cookiesJs, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
        configure.userContentController.addUserScript(cookiesWKUserScript)
        
        configure.userContentController.add(self, name: "skhtml")
        configure.userContentController.add(self, name: "skcookies")
        
        
        self.mywebview = WKWebView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.bounds.height), configuration: configure)
        
        self.addSubview(mywebview)
        self.mywebview.allowsBackForwardNavigationGestures = true
        self.mywebview.navigationDelegate = self
        self.mywebview.uiDelegate = self
        
        //        let htmlString:String = "alert('test')"
        //        self.mywebview.mainFrame.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
        //        let url = NSURL(string: "http://www.baidu.com")!
        //        self.mywebview.load(NSURLRequest(url: url as URL) as URLRequest!)
        
        
        let button: NSButton = NSButton(frame: CGRect(x: 700, y: 700, width: 100, height: 100))
        button.title = "reload"
        button.action = #selector(BrowserWKWebView.buttonClick)
        self.addSubview(button)
        
        loadHtml()

    }
    
    func buttonClick()  {
        self.mywebview.reload()
    }
    
    private func loadHtml(){
        if let path = Bundle.main.path(forResource: "demo", ofType: "html", inDirectory: nil) {
            //            self.mywebview.load(URLRequest(url: URL(fileURLWithPath: path)) )
            self.mywebview.loadFileURL(URL(fileURLWithPath: path), allowingReadAccessTo: URL(fileURLWithPath: path))
        }
        //        let url = NSURL(string: ")!
        //        self.mywebview.load(NSURLRequest(url: url as URL) as URLRequest!)
    }
    

    
}

extension BrowserWKWebView:  WKUIDelegate {
    
    //
    /*! @abstract Creates a new web view.
     @param webView The web view invoking the delegate method.
     @param configuration The configuration to use when creating the new web
     view.
     @param navigationAction The navigation action causing the new web view to
     be created.
     @param windowFeatures Window features requested by the webpage.
     @result A new web view or nil.
     @discussion The web view returned must be created with the specified configuration. WebKit will load the request in the returned web view.
     
     If you do not implement this method, the web view will cancel the navigation.
     */
    @available(OSX 10.10, *)
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView?
    {
        return WKWebView(frame: webView.frame, configuration: configuration);
    }
    
    /*! @abstract Displays a JavaScript alert panel.
     @param webView The web view invoking the delegate method.
     @param message The message to display.
     @param frame Information about the frame whose JavaScript initiated this
     call.
     @param completionHandler The completion handler to call after the alert
     panel has been dismissed.
     @discussion For user security, your app should call attention to the fact
     that a specific website controls the content in this panel. A simple forumla
     for identifying the controlling website is frame.request.URL.host.
     The panel should have a single OK button.
     
     If you do not implement this method, the web view will behave as if the user selected the OK button.
     */
    @available(OSX 10.10, *)
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void)
    {
        Swift.print(#function)
        let alert: NSAlert = NSAlert()
        alert.messageText = message
        alert.informativeText = "runJavaScriptAlertPanelWithMessage"
        alert.alertStyle = NSAlertStyle.warning
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.runModal()
        completionHandler()
    }
    
    /*! @abstract Displays a JavaScript confirm panel.
     @param webView The web view invoking the delegate method.
     @param message The message to display.
     @param frame Information about the frame whose JavaScript initiated this call.
     @param completionHandler The completion handler to call after the confirm
     panel has been dismissed. Pass YES if the user chose OK, NO if the user
     chose Cancel.
     @discussion For user security, your app should call attention to the fact
     that a specific website controls the content in this panel. A simple forumla
     for identifying the controlling website is frame.request.URL.host.
     The panel should have two buttons, such as OK and Cancel.
     
     If you do not implement this method, the web view will behave as if the user selected the Cancel button.
     */
    @available(OSX 10.10, *)
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Swift.Void)
    {
        Swift.print(#function)
        let alert: NSAlert = NSAlert()
        alert.messageText = message
        alert.informativeText = "runJavaScriptConfirmPanelWithMessage"
        alert.alertStyle = NSAlertStyle.warning
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.runModal()
        completionHandler(alert.runModal() == NSAlertFirstButtonReturn)
    }
}

extension BrowserWKWebView: WKNavigationDelegate {
    
    
    @objc(webView:decidePolicyForNavigationAction:decisionHandler:) func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Swift.print(#function)
        Swift.print(navigation)
    }
    
    private func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
        Swift.print(#function)
    }
    
    @objc(webView:didFinishNavigation:) func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Swift.print(#function)
    }
    
    @objc(webView:didCommitNavigation:) func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        Swift.print(#function)
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        Swift.print(#function)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        Swift.print(error)
        Swift.print(#function)
    }
    
    @objc(webView:didFailNavigation:withError:) func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Swift.print(error)
        Swift.print(#function)
    }
    
    // HTTPS
    private func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        Swift.print(#function)
        completionHandler(.useCredential, nil)
        
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        Swift.print(#function)
    }
    
}

extension BrowserWKWebView: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage){
    }
}

