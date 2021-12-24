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
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        contentView.delegate.controller = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AppDataSource.shared.needUpdateNewsList {
            AppDataSource.shared.needUpdateNewsList = false
            if AppDataSource.shared.favApps.isEmpty {
                self.updateTable()
            } else {
                let favoriteApps = AppDataSource.shared.favApps
                favoriteApps.forEach { app in
                    if app.news == nil {
                        getNews(app: app)
                    }
                }
                self.updateTable()
            }
        }
    }
    
    private func setUpNavigation() {
        self.navigationItem.title = Constants.newsTabTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
        
    private let newsCount = 10
    
    private func getNews(app: AppElement) {
        let request = NetworkDataManager.shared.buildRequestForFetchNews(appId: app.appid, count: newsCount)
        let completion: (Result<AppNews, Error>) -> Void = { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let appNews):
                if let newsItem = appNews.appnews?.newsitems {
                    AppDataSource.shared.refreshData(with: newsItem, appId: app.appid)
                    self.updateTable()
                }
            case .failure(let error):
                print("failure \(error)")
            }
        }
        DispatchQueue.global(qos: .utility).async {
            NetworkDataManager.shared.get(request: request, completion: completion)
        }
    }
    
    private func updateTable() {
        contentView.newsListTableView.reloadData()
    }
}
