//
//  ZoomViewController.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 17.12.21.
//

import Foundation
import UIKit
import SnapKit

class ZoomViewController: UIViewController {
    private var image: UIImage
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            Colors.gradientTop.cgColor,
            Colors.gradientBottom.cgColor
        ]
        gradient.locations = [0.5, 1];
        return gradient
    }()
    
    let closeButton: CloseButton = {
        let closeButton = CloseButton.init()
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        return closeButton
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.navBarBackground
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(self.gradientLayer, at: 0)
        scrollView.delegate = self
        imageView.image = self.image
        view.addSubview(scrollView)
        view.addSubview(closeButton)
        scrollView.addSubview(imageView)
        addConstraints()
    }
    
    func addConstraints() {
        /// constrain scrollview
        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        scrollView.frameLayoutGuide.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        scrollView.contentLayoutGuide.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(scrollView.frameLayoutGuide)
        }
        /// constrain imageView
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(scrollView.contentLayoutGuide)
        }
        /// constrain close button
        let closeButtonSize: CGFloat = 40
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.width.height.equalTo(closeButtonSize)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-25)
        }
    }
    
    /// close button
    @objc func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ZoomViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return self.imageView
    }
}
