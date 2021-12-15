//
//  GameDetailsViewController.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 14.12.21.
//

import Foundation
import UIKit

class GameDetailsViewController: UIViewController {
    
    let contentView = GameDetailsContentView()
    let appId: Int
    let appName: String
    var isFavorite: Bool
    var detailsState: Details?
    
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
        contentView.backgroundColor = Colors.navBarBackground
        setUpNavigation()
        getAppDetails()
    }
    
    func setUpNavigation() {
        self.navigationItem.title = appName
    }
    
    func loadTitleImage() {
        let completion: (Result<UIImage, Error>) -> Void = { [weak self] result in
            guard let self = self else { return }
            /// update UI on the main queue
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.contentView.headerImage.image = image
                case .failure(let error):
                    print(error)
                }
            }
        }
        if let url = self.detailsState?.headerImageUrl {
            // а тут надо перейти на другую очередь?
            NetworkDataManager.shared.loadImage(urlString: url, completion: completion)
        }
        
    }
    
    func getAppDetails() {    
        let request = NetworkDataManager.shared.buildRequestForFetchAppDetails(appId: appId)
        let completion: (Result<DecodedObject, Error>) -> Void = { [weak self] result in
            guard let self = self else { return }
            // обновляем UI на главной очереди
            DispatchQueue.main.async {
                switch result {
                case .success(let object):
                    
                    if object.decodedObject.success {
                        guard let detailsData = object.decodedObject.data else { return }
                        /// update data source and reload view
                        AppDataSource.shared.refreshData(appId: self.appId, appDetails: detailsData)
                        
                        self.detailsState = Details(headerImageUrl: detailsData.headerImage ?? "", title: detailsData.name ?? "", isFavorite: self.isFavorite, date: detailsData.releaseDate?.date ?? "", price: detailsData.priceOverview?.finalFormatted ?? "", linux: detailsData.platforms?.linux ?? false, windows: detailsData.platforms?.windows ?? false, mac: detailsData.platforms?.mac ?? false, tags: [], screenshotsUrl: [], description: detailsData.shortDescription ?? "")
                        
                        self.contentView.update(details: self.detailsState!)
                        // после получения всех деталей загружаем картинку
                        self.loadTitleImage()
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
        
        /// perform request on another queue
        DispatchQueue.global(qos: .utility).async {
            NetworkDataManager.shared.get(request: request, completion: completion)
        }
    }
}
