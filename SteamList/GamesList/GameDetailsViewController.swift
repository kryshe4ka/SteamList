//
//  GameDetailsViewController.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 14.12.21.
//

import Foundation
import UIKit

class GameDetailsViewController: UIViewController {
    
    let contentView = UIView()
    let appId: Int
    let appName: String
    var isFavorite: Bool
    
    init(appId: Int, appName: String, isFavorite: Bool) {
        self.appId = appId
        self.appName = appName
        self.isFavorite = isFavorite
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.navBarBackground
        setUpNavigation()
        getAppDetails()
    }
    
    func setUpNavigation() {
        self.navigationItem.title = appName
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.content]
    }
    
    func getAppDetails() {
        print("appId = \(appId), может сохранять и индекс?")
    
        let request = NetworkDataManager.shared.buildRequestForFetchAppDetails(appId: appId)
        let completion: (Result<DecodedObject, Error>) -> Void = { [weak self] result in
            guard let self = self else {return}
            // обновляем UI на главной очереди
            DispatchQueue.main.async {
                switch result {
                case .success(let object):
                    
                    if object.decodedObject.success {
                        guard let data = object.decodedObject.data else { return }
                        /// update data source and reload table
                        AppDataSource.shared.refreshData(appId: self.appId, appDetails: data)
                    } else {
                        print("Bad success = \(object.decodedObject.success)")
                    }
                    
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
}
