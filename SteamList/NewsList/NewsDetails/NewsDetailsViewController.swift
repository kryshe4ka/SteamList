//
//  NewsDetailsViewController.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 20.12.21.
//

import UIKit
import WebKit

class NewsDetailsViewController: UIViewController, WKUIDelegate {
    private var webView: WKWebView!
    private let content: String
    private let newsShortDescriptionView = NewsShortDescriptionView()
    private let viewForEmbeddingWebView = UIView()
    private let scrollView = UIScrollView()


    init(content: String) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func loadView() {
//        let webConfiguration = WKWebViewConfiguration()
//        webView = WKWebView(frame: .zero, configuration: webConfiguration)
//        webView.uiDelegate = self
//        view = webView
//        webView.backgroundColor = Colors.navBarBackground
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add newsShortDescriptionView
        view.addSubview(newsShortDescriptionView)
        newsShortDescriptionView.backgroundColor = Colors.gradientTop
        let height: CGFloat = 90
        newsShortDescriptionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(height)
            make.top.equalToSuperview()
        }
        
        // add viewForEmbeddingWebView
        view.addSubview(viewForEmbeddingWebView)
        viewForEmbeddingWebView.backgroundColor = .red
        viewForEmbeddingWebView.snp.makeConstraints { make in
            make.top.equalTo(newsShortDescriptionView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        // add and configure webview
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: viewForEmbeddingWebView.frame, configuration: webConfiguration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.uiDelegate = self
        webView.backgroundColor = Colors.navBarBackground
        viewForEmbeddingWebView.addSubview(webView)
    
        
        loadContentWithString()
        injectToPage()
    }
    
    func loadContentWithString() {
        webView.loadHTMLString(content, baseURL: URL(string: "https://api.steampowered.com"))
    }
    
    // MARK: - Reading contents of files
    private func readFileBy(name: String, type: String) -> String {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            return "Failed to find path"
        }
        
        do {
            return try String(contentsOfFile: path, encoding: .utf8)
        } catch {
            return "Unkown Error"
        }
    }
        
    // MARK: - Inject to web page
    func injectToPage() {
        let cssFile = readFileBy(name: "NewsDetailsStyle", type: "css")
        
        let cssStyle = """
                    javascript:(function() {
                    var parent = document.getElementsByTagName('head').item(0);
                    var style = document.createElement('style');
                    style.type = 'text/css';
                    style.innerHTML = window.atob('\(encodeStringTo64(fromString: cssFile)!)');
                    parent.appendChild(style)})()
                """
        
        let cssScript = WKUserScript(source: cssStyle, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        webView.configuration.userContentController.addUserScript(cssScript)
    }
    
    // MARK: - Encode string to base 64
    private func encodeStringTo64(fromString: String) -> String? {
        let plainData = fromString.data(using: .utf8)
        return plainData?.base64EncodedString(options: [])
    }
}
