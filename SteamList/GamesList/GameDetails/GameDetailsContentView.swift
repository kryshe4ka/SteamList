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
    let headerImageUrl: String
    let title: String
    let isFavorite: Bool
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
    private var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            Colors.gradientTop.cgColor,
            Colors.gradientBottom.cgColor
        ]
        gradient.locations = [0.5, 1];
        return gradient
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LaunchImage")
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.boldTitleFont
        label.textColor = Colors.content
        label.text = "TEST"
        return label
    }()
    
    lazy var favoriteButton: UIButton = {
        let favoriteButton = UIButton(frame: .zero)
        favoriteButton.setImage(Icons.favUnchecked, for: .normal)
        favoriteButton.setImage(Icons.favChecked, for: .highlighted)
        favoriteButton.imageView?.isUserInteractionEnabled = false
//        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        return favoriteButton
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.content
        label.text = "DATE TEST"
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.content
        label.text = "PRICE TEST"
        return label
    }()
    
    lazy var windowsPlatformImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    lazy var linuxPlatformImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    lazy var macPlatformImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var tagsLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.content
        label.text = "TAGS TEST"
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
        label.text = "descript ionLabel TESTdes criptionLabel TESTd escriptionLabel TESTdescriptionLabel TESTdescription Label TESTdescription Label TESTdescriptionLabel TEST descriptionLabel TEST TESTdescription Label TESTdescriptionLabel TEST des TESTdescription Label TESTdescriptionLabel TEST des TESTdescription Label TESTdescriptionLabel TEST desTESTdescription Label TESTdescriptionLabel TEST desTESTdescription Label TESTdescriptionLabel TEST desTESTdescription Label TESTdescriptionLabel TEST desTESTdescription Label TESTdescriptionLabel TEST desTESTdescription Label TESTdescriptionLabel TEST desTESTdescription Label TESTdescriptionLabel TEST desTESTdescription Label TESTdescriptionLabel TEST desTESTdescription Label TESTdescriptionLabel TEST desTESTdescription Label TESTdescriptionLabel TEST desTESTdescription Label TESTdescriptionLabel TEST desTESTdescription Label TESTdescriptionLabel TEST desTESTdescription Label TESTdescriptionLabel TEST desTESTdescription Label TESTdescriptionLabel TEST desTESTdescription Label TESTdescriptionLabel TEST desTESTdescription Label TESTdescriptionLabel TEST desTESTdescription Label TESTdescriptionLabel TEST desTESTdescription Label TESTdescriptionLabel TEST desTESTdescription Label TESTdescriptionLabel TEST desTESTdescription Label TESTdescriptionLabel TEST desTESTdescription Label TESTdescriptionLabel TEST desTESTdescription Label TESTdescriptionLabel TEST desTESTdescription Label TESTdescriptionLabel TEST desTESTdescription Label TESTdescriptionLabel TEST des"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var container: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = Colors.navBarBackground
        addSubview(container)
        container.layer.insertSublayer(self.gradientLayer, at: 0)
        container.addSubview(scrollView)
        [headerImage, titleLabel, favoriteButton, tagsLabel, dateLabel, priceLabel, separateLineView, descriptionLabel].forEach { view in
            scrollView.addSubview(view)
        }
        addConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = container.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints() {
        let headerImageHeight: CGFloat = 200
        let separateLineViewHeight: CGFloat = 1
        let screenWidth = UIScreen.main.bounds.width
        
        container.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        headerImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(headerImageHeight)
            make.width.equalTo(screenWidth)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerImage.snp.bottom).offset(16)
            make.center.equalToSuperview()
        }
        
        tagsLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.equalTo(tagsLabel.snp.bottom).offset(24)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(priceLabel.snp.centerY)
            make.leading.equalToSuperview().offset(10)
        }
        
        separateLineView.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(separateLineViewHeight)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(separateLineView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(scrollView.snp.bottom) // !!! поискать другое решение
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
    }
    
    func update(details: Details) {
        titleLabel.text = details.title
//        tagsLabel.text = details.tags.joined(separator: " ")
        dateLabel.text = details.date
//        priceLabel.text = details.price
//        descriptionLabel.text = details.description
//        layoutIfNeeded()
    }
}
