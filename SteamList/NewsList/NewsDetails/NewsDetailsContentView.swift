//
//  NewsDetailsContentView.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 20.12.21.
//

import Foundation
import UIKit
import WebKit

class NewsDetailsContentView: UIView {
    var webView: WKWebView!
    private let state: NewsCellState
    private let contentView = UIView()
    private let newsShortDescriptionView = NewsShortDescriptionView()
    private let viewForEmbeddingWebView = UIView()
    private let separateLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = Colors.content
        return lineView
    }()
    
    init(state: NewsCellState) {
        self.state = state
        super.init(frame: .zero)
        initSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubviews() {
        addSubview(contentView)
        addSubview(newsShortDescriptionView)
        contentView.addSubview(separateLineView)
        contentView.addSubview(viewForEmbeddingWebView)
        newsShortDescriptionView.update(state: state)
        /// add and configure webview
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: viewForEmbeddingWebView.frame, configuration: webConfiguration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewForEmbeddingWebView.addSubview(webView)
        /// set background color
        webView.backgroundColor = Colors.gradientTop
        contentView.backgroundColor = Colors.gradientTop
        newsShortDescriptionView.backgroundColor = Colors.gradientTop

    }
    
    func addConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
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
    }
}
