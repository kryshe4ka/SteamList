//
//  NewsListViewController.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation
import UIKit

class NewsListViewController: UIViewController, Delegate {
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
        newsArray.sort { $0.date! > $1.date! }
        return newsArray
    }
    
    let networkDataManager: NetworkDataManager
    let dataManager: CoreDataManager
    let appDataSource: AppDataSource
    
    init(networkDataManager: NetworkDataManager, dataManager: CoreDataManager, appDataSource: AppDataSource) {
        self.networkDataManager = networkDataManager
        self.dataManager = dataManager
        self.appDataSource = appDataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isBlurAnimatorActive {
            closeFilterView()
        }
        contentView.filterTableView.reloadData()
        getNewsFromStorage()
        getNews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.filterDelegate.controller = self
        setUpNavigation()
        contentView.delegate.controller = self
        contentView.saveButton.addTarget(self, action: #selector(applyFilter), for: .touchUpInside)
        filteredFavApps = self.appDataSource.favApps /// add all favorites to filtered list by default
    }
        
    private func getNewsFromStorage() {
        self.dataManager.fetchNews { result in
            switch result {
            case .success(let news):
                self.updateDataAndUI(news: news)
            case .failure(_):
                ErrorHandler.showErrorAlert(with: "Failed to update data from local storage", presenter: self)
            }
        }
    }
    
    private func updateDataAndUI(news: [Newsitem]) {
        for i in 0..<self.appDataSource.favApps.count {
            let newsArray = news.filter { newsitem in
                newsitem.appid == self.appDataSource.favApps[i].appid
            }
            self.appDataSource.favApps[i].news = newsArray
        }
        filteredFavApps = self.appDataSource.favApps

        DispatchQueue.main.async {
            self.updateTable()
        }
    }
        
    private func getNews() {
        let apps = self.appDataSource.favApps
        apps.forEach { app in
            group.enter()
            getNews(app: app, group: group)
        }
        group.notify(queue: .global()) {
            let news = self.appDataSource.news
            self.deleteNewsFromStorage()
            self.saveNewsToStorage(news: news)
        }
        group.notify(queue: .main) {
            self.updateTable()
        }
    }
    
    private func getNews(app: AppElement, group: DispatchGroup) {
        let request = self.networkDataManager.buildRequestForFetchNews(appId: app.appid, count: newsCount)
        let completion: (Result<AppNews, Error>) -> Void = { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let appNews):
                if let newsItems = appNews.appnews?.newsitems {
                    self.updateData(newsItems: newsItems, appId: app.appid)
                }
                group.leave()
            case .failure(_):
                ErrorHandler.showErrorAlert(with: "Failed to update data from internet. Please try again later...", presenter: self)
                group.leave()
            }
        }
        DispatchQueue.global(qos: .utility).async {
            self.networkDataManager.get(request: request, completion: completion)
        }
    }

    private func saveNewsToStorage(news: [Newsitem]) {
        self.dataManager.saveNews(news) { result in
            switch result {
            case .failure(_):
                ErrorHandler.showErrorAlert(with: "Failed to save data to local storage", presenter: self)
            case .success(_):
                print("SaveNewsToStorage: success")
            }
        }
    }
    
    private func deleteNewsFromStorage() {
        self.dataManager.deleteNews { result in
            switch result {
            case .failure(_):
                ErrorHandler.showErrorAlert(with: "Failed to delete data from local storage", presenter: self)
            case .success(_):
                print("DeleteNewsFromStorage: success")
            }
        }
    }
    
    private func updateData(newsItems: [Newsitem], appId: Int) {
        self.appDataSource.refreshData(with: newsItems, appId: appId)
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
            let tap = UITapGestureRecognizer(target: self, action: #selector(applyFilter))
            blurEffectView.addGestureRecognizer(tap)
            view.addSubview(blurEffectView)
            blurAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
                blurEffectView.effect = UIBlurEffect(style: .light)
            })
            blurAnimator.fractionComplete = 0.15
            isBlurAnimatorActive = true
            contentView.addSubview(contentView.filterView)
            contentView.addConstraintsToFilterView()
        } else {
            applyFilter()
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
    
    /// press "Save" button or tap around or press "Filter" bar button
    @objc private func applyFilter() {
        updateTable()
        closeFilterView()
    }
}
