//
//  GHSubscriptionCollectionCell.swift
//  FundsIndiaSystemTask
//
//  Created by Pradeep's Macbook on 13/03/21.
//  Copyright © 2021 Motiv Ate Fitness. All rights reserved.
//

import UIKit

class GHSubscriptionCollectionCell: BaseCollectionCell {
    
    //MARK: - Properties
    
    //MARK: - Views
    
    private lazy var avatarImageView: CachedImageView = {
        let v = CachedImageView()
        v.backgroundColor = .clear
        v.contentMode = .scaleAspectFill
        v.layer.cornerRadius = 6
        v.layer.masksToBounds = true
        return v
    }()
    
    private lazy var subscriptionLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 17, weight: .medium)
        v.textAlignment = .center
        return v
    }()
    
    //MARK: - Overrides
    
    override func configureViewComponents() {
        self.setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        self.addSubviewsToParent(avatarImageView,
                                 subscriptionLabel)
        avatarImageView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 25, right: 0), size: .init())
        subscriptionLabel.anchor(top: avatarImageView.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 4, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 21))
    }
    
    func setData(with item: GHSubscriptionModel) {
        if let strAvatar = item.owner?.avatar_url {
            self.avatarImageView.loadImage(urlString: strAvatar)
        }
        self.subscriptionLabel.text = item.name?.capitalizingFirstLetter()
    }
    
    //MARK: - Helper Functions
}
