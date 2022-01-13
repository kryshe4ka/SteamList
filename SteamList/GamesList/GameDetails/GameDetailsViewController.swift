//
//  GameDetailsViewController.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 14.12.21.
//

import Foundation
import UIKit

final class GameDetailsViewController: UIViewController {
    private let contentView = GameDetailsContentView()
    private var app: AppElement
    weak var delegate: GamesListViewController?
    
    init(app: AppElement) {
        self.app = app
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
        contentView.controller = self
        setUpNavigation()
        
        getAppDetailsFromStorage(for: app)
        getAppDetails()
    }
    
    private func getAppDetailsFromStorage(for app: AppElement) {
        CoreDataManager.shared.fetchAppDetails(appId: app.appid) { result in
            switch result {
            case .success(let appDetails):
                if let appDetails = appDetails {
                    self.app.appDetails = appDetails
                    self.updateContentViewWith(appDetails: appDetails)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateContentViewWith(appDetails: AppDetails) {
        var tagsArray: [String]?
        tagsArray = appDetails.genres?.compactMap({ genre in
            genre.genreDescription
        })
        
        var screenshotsArray: [String]?
        screenshotsArray = appDetails.screenshots?.compactMap({ screenshot in
            screenshot.pathFull
        })
        
        let detailsState = Details(appId: appDetails.steamAppid ?? 0, headerImageUrl: appDetails.headerImage ?? "", title: appDetails.name ?? "Unknown", isFavorite: app.isFavorite!, isFree: appDetails.isFree ?? false, date: appDetails.releaseDate?.date ?? "-", price: appDetails.priceOverview?.finalFormatted ?? "Unknown", linux: appDetails.platforms?.linux ?? false, windows: appDetails.platforms?.windows ?? false, mac: appDetails.platforms?.mac ?? false, tags: tagsArray ?? ["Other"], screenshotsUrl: screenshotsArray ?? [], description: appDetails.shortDescription ?? "Unknown")

        self.contentView.update(details: detailsState)
        /// load header image if url exist
        if let url = appDetails.headerImage {
            self.loadTitleImage(url: url)
        }
    }
    
    private func setUpNavigation() {
        self.navigationItem.title = app.name
    }
    
    private func loadTitleImage(url: String) {
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
        NetworkDataManager.shared.loadImage(urlString: url, completion: completion)
    }
    
    private func getAppDetails() {    
        let request = NetworkDataManager.shared.buildRequestForFetchAppDetails(appId: app.appid)
        let completion: (Result<DecodedObject, Error>) -> Void = { [weak self] result in
            guard let self = self else { return }
            // обновляем UI на главной очереди
            DispatchQueue.main.async {
                switch result {
                case .success(let object):
                    
                    if object.decodedObject.success {
                        guard let detailsData = object.decodedObject.data else { return }
                        /// update data source and reload view
                        AppDataSource.shared.refreshData(appId: self.app.appid, appDetails: detailsData)
                        
                        // тут обновить price и дискаунт
                        // и наверное вызвать обновление данных у фаворитов
                        AppDataSource.shared.updateFavAppsData()
                        self.deleteAppDetailsFromStorage(appId: self.app.appid)
                        self.saveAppDetailsToStorage(appDetails: detailsData)
                        self.updateContentViewWith(appDetails: detailsData)
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
    
    private func saveAppDetailsToStorage(appDetails: AppDetails) {
        CoreDataManager.shared.saveAppDetails(appDetails) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(_):
                print("сохранили детали")
            }
        }
    }
    
    private func deleteAppDetailsFromStorage(appId: Int) {
        CoreDataManager.shared.deleteAppDetails(appId: appId) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(_):
                print("удалили детали")
            }
        }
    }

}
