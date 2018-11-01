//
//  WebViewController.swift
//  WebView
//
//  Created by Németh Bendegúz on 2017. 10. 06..
//  Copyright © 2017. Németh Bendegúz. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var cameraButton: UIButton!
    private var requestGoogle: URLRequest!
    private var requestWiki: URLRequest!
    
    var isCameraButtonHidden: Bool = true
    
    var textOfLabel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestGoogle = URLRequest(url: URL(string: "http://www.google.com/search?q=" +
            textOfLabel.replacingOccurrences(of: " ", with: "+"))!)
        requestWiki = URLRequest(url: URL(string: "https://en.m.wikipedia.org/wiki/" +
            textOfLabel.replacingOccurrences(of: " ", with: "_"))!)
        cameraButton.isHidden = isCameraButtonHidden
        if Reachability.isConnectedToNetwork() {
            webView.uiDelegate = self
            webView.navigationDelegate = self
            webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
            webView.load(requestGoogle)
        }
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !Reachability.isConnectedToNetwork() {
            showError("No internet connection.")
        }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else {return}
        switch keyPath {
        case "estimatedProgress":
            if let newValue = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                progressChanged(newValue as! Float)
            }
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // MARK: Actions
    
    @IBAction func cancel(_ sender: UIButton) {
        let presentingPhotoViewController = self.presentingViewController as? PhotoViewController
        if presentingPhotoViewController != nil {
            presentingPhotoViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func toCamera(_ sender: UIButton) {
        let presentingPhotoViewController = self.presentingViewController as? PhotoViewController
        if presentingPhotoViewController != nil {
            presentingPhotoViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        } else {
            presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func loadWiki(_ sender: UIButton) {
        progressView.isHidden = false
        webView.load(requestWiki)
    }
    
    @IBAction func loadGoogle(_ sender: UIButton) {
        progressView.isHidden = false
        webView.load(requestGoogle)
    }
    
    // MARK: Some Private Methods
    
    private func showError(_ errorString: String?) {
        let alertView = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    private func progressChanged(_ newValue: Float) {
        progressView.setProgress(newValue, animated: true)
        if progressView.progress == 1 {
            progressView.isHidden = true
            progressView.progress = 0
        }
    }
    
    // MARK: WKNavigationDelegate Methods
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressChanged(1)
        if error._code == NSURLErrorCancelled {
            return
        }
        showError(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        progressChanged(1)
        if error._code == NSURLErrorCancelled {
            return
        }
        showError(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
    }
    
    // MARK: WKUIDelegate Methods
    
    open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alertController: UIAlertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(action: UIAlertAction) -> Void in
            completionHandler()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

