//
//  NewsListViewController.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation
import UIKit

class NewsListViewController: UIViewController {
    private let group = DispatchGroup()
    private let contentView = NewsListContentView()
    private let newsCount = 10
    private var blurAnimator: UIViewPropertyAnimator!
    private var isBlurAnimatorActive = false
    var filteredFavApps: [AppElement] = []
    var filteredNews: [Newsitem] {
        var newsArray: [Newsitem] = []
        filteredFavApps.forEach {
            if let news = $0.news, !news.isEmpty {
                newsArray += news
            }
        }
        return newsArray
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filteredFavApps = AppDataSource.shared.favApps
        contentView.filterTableView.reloadData()
        getNews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.filterDelegate.controller = self
        setUpNavigation()
        contentView.delegate.controller = self
        contentView.saveButton.addTarget(self, action: #selector(applyFilter), for: .touchUpInside)
        if !AppDataSource.shared.favApps.isEmpty {
            filteredFavApps = AppDataSource.shared.favApps /// add all favorites to filtered list by default
//            getNewsFromStorage()
            getNews()
        }
    }
    
    private func getNewsFromStorage() {
        let favApps = AppDataSource.shared.favApps
        favApps.forEach { app in
            CoreDataManager.shared.fetchAppNews(app: app, count: newsCount) { result in
                switch result {
                case .success(let news):
                    self.updateData(newsItems: news, appId: app.appid)
                    self.updateTable()
                    print("UI обновился From Storage")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
        
    private func getNews() {
        let apps = AppDataSource.shared.favApps
        apps.forEach { app in
            group.enter()
            getNews(app: app)
        }
        group.notify(queue: .main) {
            self.updateTable()
        }
    }
    
    private func getNews(app: AppElement) {
        let request = NetworkDataManager.shared.buildRequestForFetchNews(appId: app.appid, count: newsCount)
        let completion: (Result<AppNews, Error>) -> Void = { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let appNews):
                if let newsItems = appNews.appnews?.newsitems {
                    self.deleteAppsFromStorage()
                    self.saveNewsToStorage(news: newsItems)
                    self.updateData(newsItems: newsItems, appId: app.appid)
                }
                self.group.leave()
            case .failure(let error):
                print("failure \(error)")
                self.group.leave()
            }
        }
        DispatchQueue.global(qos: .utility).async {
            NetworkDataManager.shared.get(request: request, completion: completion)
        }
    }
    
    private func deleteAppsFromStorage() {
        print("deleteAppsFromStorage")
    }
    
    private func saveNewsToStorage(news: [Newsitem]) {
        news.forEach { newsItem in
            CoreDataManager.shared.addToNews(news: newsItem)
        }
    }
    
    private func updateData(newsItems: [Newsitem], appId: Int) {
        AppDataSource.shared.refreshData(with: newsItems, appId: appId)
        updateFilteredList(newsItems: newsItems, appId: appId)
    }
    
    private func updateFilteredList(newsItems: [Newsitem], appId: Int) {
        if let index = filteredFavApps.firstIndex(where: { $0.appid == appId }) {
            self.filteredFavApps[index].news = newsItems
        }
    }
    
    private func updateTable() {
        contentView.newsListTableView.reloadData()
    }
    
    private func setUpNavigation() {
        self.navigationItem.title = Constants.newsTabTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(self.showFilterOptions(_:)))
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
}

extension NewsListViewController {
    @objc private func showFilterOptions(_ sender: UIBarButtonItem) {
        if !isBlurAnimatorActive {
            let blurEffectView = UIVisualEffectView()
            blurEffectView.backgroundColor = .clear
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            /// add tap to close filter window
            let tap = UITapGestureRecognizer(target: self, action: #selector(closeFilterView))
            blurEffectView.addGestureRecognizer(tap)
            view.addSubview(blurEffectView)
            blurAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: { [blurEffectView] in
                blurEffectView.effect = UIBlurEffect(style: .light)
            })
            blurAnimator.fractionComplete = 0.15
            isBlurAnimatorActive = true
            contentView.addSubview(contentView.filterView)
            contentView.addConstraintsToFilterView()
        } else {
            closeFilterView()
        }
    }
    
    @objc func closeFilterView() {
        isBlurAnimatorActive = false
        for subview in view.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview() /// to remove blur
            }
        }
        contentView.filterView.removeFromSuperview()
    }
    
    /// press save button
    @objc private func applyFilter() {
        updateTable()
        closeFilterView()
    }
}



//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if AppDataSource.shared.needUpdateNewsList {
//            AppDataSource.shared.needUpdateNewsList = false
//            if AppDataSource.shared.favApps.isEmpty {
//                self.updateTable()
//            } else {
//                let favoriteApps = AppDataSource.shared.favApps
//                favoriteApps.forEach { app in
//                    if app.news == nil {
//                        getNews(app: app)
//                    }
//                }
//                self.updateTable()
//            }
//        }
//    }
