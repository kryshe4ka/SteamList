//
//  GameDetailsContentView.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 14.12.21.
//

import Foundation
import UIKit
import SnapKit

struct Details {
    let appId: Int
    let headerImageUrl: String
    let title: String
    let isFavorite: Bool
    let isFree: Bool
    let date: String
    let price: String
    let linux: Bool
    let windows: Bool
    let mac: Bool
    let tags: [String]
    let screenshotsUrl: [String]
    let description: String
}

class GameDetailsContentView: UIView {
    var isFavorite: Bool = false
    var appId: Int = 0
    var numberOfScreenshots: Int = 0
    var delegate: ScreenshotsCollectionViewDelegate?
    var controller: GameDetailsViewController?
    
    lazy var screenshotsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ScreenshotsCollectionViewCell.self, forCellWithReuseIdentifier: ScreenshotsCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            Colors.gradientTop.cgColor,
            Colors.gradientBottom.cgColor
        ]
        gradient.locations = [0.5, 1];
        return gradient
    }()
    
    private let scrollView = UIScrollView()
    
    lazy var headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "loadInd")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.boldTitleFont
        label.textColor = Colors.content
        label.allowsDefaultTighteningForTruncation = true
        return label
    }()
    
    lazy var favoriteButton: UIButton = {
        let favoriteButton = UIButton(frame: .zero)
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        return favoriteButton
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.content
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.green
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var windowsPlatformView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    lazy var windowsPlatformImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "windows")
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var linuxPlatformView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    lazy var linuxPlatformImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "linux")
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var macPlatformView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    lazy var macPlatformImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "apple")
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var tagsLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.content
        return label
    }()
    
    lazy var separateLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = Colors.content
        return lineView
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.content
        label.numberOfLines = 0
        return label
    }()
    
    lazy var container: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    lazy var platformsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 16.0
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = Colors.navBarBackground
        addSubview(container)
        container.layer.insertSublayer(self.gradientLayer, at: 0)
        container.addSubview(scrollView)
        
        linuxPlatformView.addSubview(linuxPlatformImage)
        windowsPlatformView.addSubview(windowsPlatformImage)
        macPlatformView.addSubview(macPlatformImage)
        
        platformsStackView.addArrangedSubview(macPlatformView)
        platformsStackView.addArrangedSubview(linuxPlatformView)
        platformsStackView.addArrangedSubview(windowsPlatformView)
        
        [headerImage, titleLabel, favoriteButton, tagsLabel, dateLabel, priceLabel, separateLineView, descriptionLabel, platformsStackView, screenshotsCollection].forEach { view in
            scrollView.addSubview(view)
        }
        addConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = container.bounds
        
        let height: CGFloat = CGFloat(200 * numberOfScreenshots + 10 * numberOfScreenshots - 1)
        screenshotsCollection.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.greaterThanOrEqualToSuperview()
            make.height.equalTo(height).priority(.high)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints() {
        let headerImageHeight: CGFloat = 200
        let separateLineViewHeight: CGFloat = 1
        let buttonWidth: CGFloat = 30
        let platformsWidth: CGFloat = 20
        
        container.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        headerImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(headerImageHeight)
            make.width.equalTo(container.snp.width)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(headerImage.snp.bottom).offset(16)
            make.trailing.equalToSuperview().offset(-10).priority(.required)
            make.width.equalTo(buttonWidth).priority(.required)
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).priority(.required)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerImage.snp.bottom).offset(16)
            make.centerX.equalToSuperview().priority(.high)
            make.leading.greaterThanOrEqualToSuperview().offset(10).priority(.required)
        }
        
        tagsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tagsLabel.snp.bottom).offset(24)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(priceLabel.snp.centerY)
            make.leading.equalToSuperview().offset(10)
        }
        
        platformsStackView.snp.makeConstraints{ make in
            make.centerY.equalTo(priceLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-10)
        }
        macPlatformView.snp.makeConstraints{ make in
            make.height.width.equalTo(platformsWidth)
        }
        linuxPlatformView.snp.makeConstraints{ make in
            make.height.width.equalTo(platformsWidth)
        }
        windowsPlatformView.snp.makeConstraints{ make in
            make.height.width.equalTo(platformsWidth)
        }
        separateLineView.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(separateLineViewHeight)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(separateLineView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        linuxPlatformImage.snp.makeConstraints { make in
            make.height.width.equalTo(platformsWidth)
        }
        macPlatformImage.snp.makeConstraints { make in
            make.height.width.equalTo(platformsWidth)
        }
        windowsPlatformImage.snp.makeConstraints { make in
            make.height.width.equalTo(platformsWidth)
        }
    }
}

extension GameDetailsContentView {
    func update(details: Details) {
        numberOfScreenshots = details.screenshotsUrl.count
        delegate = ScreenshotsCollectionViewDelegate(numberOfScreenshots: numberOfScreenshots, screenshotUrls: details.screenshotsUrl)
        screenshotsCollection.delegate = delegate
        screenshotsCollection.dataSource = delegate
        delegate?.controller = self.controller
        titleLabel.text = details.title
        tagsLabel.text = details.tags.joined(separator: " ")
        dateLabel.text = details.date
        descriptionLabel.text = details.description
        setFavoriteButtonState(isFavorite: details.isFavorite)
        
        if details.isFree {
            priceLabel.text = "Free to Play"
        } else {
            priceLabel.text = details.price
        }
        
        self.isFavorite = details.isFavorite
        self.appId = details.appId

        if details.linux {
            linuxPlatformView.isHidden = false
            linuxPlatformImage.isHidden = false
        }
        if details.mac {
            macPlatformView.isHidden = false
            macPlatformImage.isHidden = false
        }
        if details.windows {
            windowsPlatformView.isHidden = false
            windowsPlatformImage.isHidden = false
        }
    }
    
    func setFavoriteButtonState(isFavorite: Bool) {
        isFavorite ? favoriteButton.setImage(Icons.favChecked, for: .normal) : favoriteButton.setImage(Icons.favUnchecked, for: .normal)
        isFavorite ? favoriteButton.setImage(Icons.favUnchecked, for: .highlighted) : favoriteButton.setImage(Icons.favChecked, for: .highlighted)
    }
    
    @objc func toggleFavorite(sender: UIButton) {
        self.isFavorite = !self.isFavorite
        setFavoriteButtonState(isFavorite: isFavorite)
        /// save favorite state in the data source
        if let index = AppDataSource.shared.apps.firstIndex(where: { [weak self] app in
            guard let self = self else { return false }
            return app.appid == self.appId
        }) {
            AppDataSource.shared.toggleFavorite(index: index, favoriteState: isFavorite)
            // а еще нужно обновить таблицу (значение уже установлено)
        }
    }
}
