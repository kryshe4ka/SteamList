//
//  ScreenshotsCollectionViewCell.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 17.12.21.
//
import UIKit
import SnapKit

class ScreenshotsCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: ScreenshotsCollectionViewCell.self)
    
    lazy var screenshotImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    var activityIndicator = UIActivityIndicatorView()

    func setupCell() {
        backgroundColor = .clear
        addSubview(screenshotImageView)
        screenshotImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        self.activityIndicator = UIActivityIndicatorView(style: .white)
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 56, height: 56)
        self.activityIndicator.hidesWhenStopped = true
        screenshotImageView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
