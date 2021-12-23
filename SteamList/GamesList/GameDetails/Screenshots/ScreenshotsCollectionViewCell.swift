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
        imageView.image = UIImage(named: "loadInd")
        return imageView
    }()
    
    func setupCell() {
        backgroundColor = .clear
        addSubview(screenshotImageView)
        screenshotImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
