//
//  NewsDetailsViewController.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 20.12.21.
//

import UIKit
import WebKit

class NewsDetailsViewController: UIViewController, WKUIDelegate {
    let contentView: NewsDetailsContentView!
    private let content: String

    override func loadView() {
        view = contentView
    }

    init(content: String, state: NewsCellState) {
        self.content = content
        contentView = NewsDetailsContentView(state: state)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.webView.uiDelegate = self
        loadContentWithString()
        injectToPage()
    }
    
    func loadContentWithString() {
        contentView.webView.loadHTMLString(content, baseURL: URL(string: "https://api.steampowered.com"))
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
        contentView.webView.configuration.userContentController.addUserScript(cssScript)
    }
    
    // MARK: - Encode string to base 64
    private func encodeStringTo64(fromString: String) -> String? {
        let plainData = fromString.data(using: .utf8)
        return plainData?.base64EncodedString(options: [])
    }
}
