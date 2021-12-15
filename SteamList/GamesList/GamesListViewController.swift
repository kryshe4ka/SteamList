//
//  GamesListViewController.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation
import UIKit

class GamesListViewController: UIViewController {
    let contentView = GamesListContentView()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.backgroundColor = Colors.navBarBackground
        setUpNavigation()
        contentView.delegate.controller = self /// pass GamesListViewController to GamesListTableViewDelegate
        getApps()
    }
    
    func setUpNavigation() {
        self.navigationItem.title = Constants.gamesTabTitle
        /// customize back bar button
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    func getApps() {
        let request = NetworkDataManager.shared.buildRequestForFetchApps()
        let completion: (Result<App, Error>) -> Void = { [weak self] result in
            guard let self = self else {return}
            // обновляем UI на главной очереди
            DispatchQueue.main.async {
                switch result {
                case .success(let app):
                    /// update data source and reload table
                    AppDataSource.shared.refreshData(apps: app.applist.apps)
                    self.updateTable()
                    // спрятать индикатор загрузки
                    // тут -> ...
                case .failure(let error):
                    // спрятать индикатор загрузки
                    // тут -> ...
                    // повторить попытку загрузки, текущее значение попытки увеличить
                    // если кол-во попыток исчерпано, то отобразить error alert
                    // тут -> ...
                    print(error)
                }
            }
        }
        // отобразить индикатор загрузки
        // тут -> ...
        
        // выполняем запрос на др.очереди
        DispatchQueue.global(qos: .utility).async {
            NetworkDataManager.shared.get(request: request, completion: completion)
        }
    }
    
    func updateTable() {
        contentView.gamesListTableView.reloadData()
    }
}
