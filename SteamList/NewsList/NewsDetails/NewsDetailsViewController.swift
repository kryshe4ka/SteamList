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
    private let state: NewsCellState
    private let separateLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = Colors.content
        return lineView
    }()
    private let contentView = UIView()

    init(content: String, state: NewsCellState) {
        self.content = content
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        view.addSubview(newsShortDescriptionView)
        contentView.addSubview(separateLineView)
        contentView.addSubview(viewForEmbeddingWebView)
        newsShortDescriptionView.update(state: state)
        newsShortDescriptionView.backgroundColor = Colors.gradientTop
        let height: CGFloat = 90
        newsShortDescriptionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(height)
            make.top.equalToSuperview()
        }
        let separateLineViewHeight: CGFloat = 1
        separateLineView.snp.makeConstraints { make in
            make.top.equalTo(newsShortDescriptionView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(separateLineViewHeight)
        }
        viewForEmbeddingWebView.snp.makeConstraints { make in
            make.top.equalTo(separateLineView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        /// add and configure webview
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: viewForEmbeddingWebView.frame, configuration: webConfiguration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.uiDelegate = self
        viewForEmbeddingWebView.addSubview(webView)
    
        contentView.backgroundColor = Colors.gradientTop
        webView.backgroundColor = Colors.gradientTop
        
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
