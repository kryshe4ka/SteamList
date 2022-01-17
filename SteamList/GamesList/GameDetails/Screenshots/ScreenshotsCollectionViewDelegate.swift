//
//  ScreenshotsCollectionViewDelegate.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 17.12.21.
//

import Foundation
import UIKit

final class ScreenshotsCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    private let numberOfScreenshots: Int
    private let screenshotUrls: [String]
    weak var controller: GameDetailsViewController?
    
    init(numberOfScreenshots: Int, screenshotUrls: [String]) {
        self.numberOfScreenshots = numberOfScreenshots
        self.screenshotUrls = screenshotUrls
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// openZoomView
        let cell = collectionView.cellForItem(at: indexPath) as! ScreenshotsCollectionViewCell
        guard let image = cell.screenshotImageView.image else { return }
        let zoomVC = ZoomViewController(image: image)
        guard let controller = controller else { return }
        controller.present(zoomVC, animated: true, completion: nil)
    }
}

extension ScreenshotsCollectionViewDelegate: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfScreenshots
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScreenshotsCollectionViewCell.reuseIdentifier, for: indexPath) as! ScreenshotsCollectionViewCell
        cell.setupCell()
        let urlString = screenshotUrls[indexPath.row]
        /// load image for cell
        let completion: (Result<UIImage, Error>) -> Void = { [weak cell, self] result in
            guard let cell = cell else { return }
            /// update UI on the main queue
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    cell.activityIndicator.stopAnimating()
                    cell.screenshotImageView.image = image
                case .failure(_):
                    cell.activityIndicator.stopAnimating()
                    guard let controller = self.controller else { return }
                    ErrorHandler.showErrorAlert(with: "Failed to load image from internet. Please try again later...", presenter: controller)
                }
            }
        }
        if !urlString.isEmpty {
            cell.activityIndicator.startAnimating()
            DispatchQueue.global(qos: .utility).async {
                NetworkDataManager.shared.loadImage(urlString: urlString, completion: completion)
            }
        }
        return cell
    }
}

extension ScreenshotsCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let height: CGFloat = 200
        return CGSize(width: collectionView.frame.size.width, height: height)
    }
}
