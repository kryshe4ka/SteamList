//
//  NewsListViewController.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation
import UIKit

class NewsListViewController: UIViewController {
    private let contentView = NewsListContentView()
    var filteredTableData: [Newsitem] = []
//    var isFiltering: Bool = false
    private let newsCount = 10
    private var blurAnimator: UIViewPropertyAnimator!
    private var isBlurAnimatorActive = false
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        contentView.delegate.controller = self
        contentView.saveButton.addTarget(self, action: #selector(applyFilter), for: .touchUpInside)
        if !AppDataSource.shared.favApps.isEmpty {
            getNewsFromStorage()
            getNews()
        }
    }
    
    private func getNewsFromStorage() {
        let favApps = AppDataSource.shared.favApps
        favApps.forEach { app in
            CoreDataManager.shared.fetchAppNews(app: app, count: newsCount) { result in
                switch result {
                case .success(let news):
                    self.updateDataAndUI(newsItems: news, appId: app.appid)
//                    AppDataSource.shared.refreshData(with: news, appId: app.appid)
//                    self.updateTable()
                    print("UI обновился From Storage")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func getNews() {
        print("getNews")
        let apps = AppDataSource.shared.favApps
        apps.forEach { app in
            getNews(app: app)
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
                    self.updateDataAndUI(newsItems: newsItems, appId: app.appid)
                }
            case .failure(let error):
                print("failure \(error)")
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
    
    private func updateDataAndUI(newsItems: [Newsitem], appId: Int) {
        DispatchQueue.main.async {
            AppDataSource.shared.refreshData(with: newsItems, appId: appId)
            self.updateTable()
            print("UI обновился - updateDataAndUI")
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
    
    @objc private func applyFilter() {
        closeFilterView()
        updateTable()
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
