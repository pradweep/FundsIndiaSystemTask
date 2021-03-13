//
//  GHListTableViewCell.swift
//  FundsIndiaSystemTask
//
//  Created by Pradeep's Macbook on 12/03/21.
//  Copyright © 2021 Motiv Ate Fitness. All rights reserved.
//

import UIKit
import Combine

class GHListTableViewCell: BaseTableViewCell {
    
    //MARK: - Property Observers

    
    var ghRepoList: GHRepoModel? {
        didSet {
            guard let ghRepoModel = ghRepoList else { return }
            self.updateUI(ghRepoModel)
        }
    }
    
    //MARK: - Views
    
    lazy var avatarImageView: CachedImageView = {
        let v = CachedImageView()
        v.backgroundColor = .clear
        v.contentMode = .scaleAspectFit
        v.constrainWidth(constant: 75)
        v.constrainHeight(constant: 75)
        v.layer.cornerRadius = 75 / 2
        v.layer.masksToBounds = true
        return v
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = String("Pradeep Kumar".prefix(1))
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var textComponentsStackView: UIStackView = {
        let sv = UIStackView.init(arrangedSubviews: [
            nameLabel,
            descriptionLabel
        ])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .leading
        sv.isLayoutMarginsRelativeArrangement = true
        sv.spacing = 4
        sv.layoutMargins = .init(top: 12, left: 24, bottom: 12, right: 16)
        return sv
    }()
    
    private lazy var rootVStackView: UIStackView = {
        let sv = UIStackView.init(arrangedSubviews: [
            avatarImageView,
            textComponentsStackView
        ])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .center
        sv.isLayoutMarginsRelativeArrangement = true
        sv.layoutMargins = .init(top: 8, left: 24, bottom: 8, right: 16)
        return sv
    }()
    
    //MARK: - Overrides
    
    override func configureViewComponents() {
        self.setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        self.addSubviewsToParent(rootVStackView)
        rootVStackView.fillSuperview()
    }
    
    //MARK: - Helper Functions
    
    private func updateUI(_ item: GHRepoModel) {
        if let strAvatar = item.owner?.avatar_url {
            self.avatarImageView.loadImage(urlString: strAvatar)
        }
        self.nameLabel.text = item.name?.capitalizingFirstLetter()
        self.descriptionLabel.text = item.description
    }
    
    private func fetchAvatarImage(iconURL: URL) {
        AsyncImageDownloader.downloadImage(with: iconURL) { (result) in
            switch result {
            case .success(let image):
                self.avatarImageView.image = image
            case .failure(let error):
                OverlayView.sharedInstance.hideOverlay()
                print("error: \(error)")
            }
        }
    }
}
