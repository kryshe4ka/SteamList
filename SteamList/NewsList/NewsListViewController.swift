//
//  NewsListViewController.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation
import UIKit

class NewsListViewController: UIViewController {
    let contentView = NewsListContentView()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        contentView.delegate.controller = self
//        getNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AppDataSource.shared.isFavoritesWasChanged {
            getNews()
        }
    }
    
    func setUpNavigation() {
        self.navigationItem.title = Constants.newsTabTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
        
    let newsCount = 10
    
    func getNews() {
        let appIdArray = AppDataSource.shared.favApps.compactMap { app in app.appid }  ///  create app id array
        
        appIdArray.forEach { appId in
            let request = NetworkDataManager.shared.buildRequestForFetchNews(appId: appId, count: newsCount)
            let completion: (Result<AppNews, Error>) -> Void = { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let appNews):
                    
                    if let newsItem =  appNews.appnews?.newsitems {
                        AppDataSource.shared.updateNews(with: newsItem)
                        // наверное нужно обновить таблицу уже после того как все запросы выполнятся
                        self.updateTable()
                        AppDataSource.shared.setChangesDone()
                    }
                    print("success")
                    
                case .failure(let error):
                    print("failure \(error)")
                }
            }
            // выполняем запрос на др.очереди
            DispatchQueue.global(qos: .utility).async {
                NetworkDataManager.shared.get(request: request, completion: completion)
            }
        }
    }
    
    func updateTable() {
        contentView.newsListTableView.reloadData()
        print("update table")
    }
}
