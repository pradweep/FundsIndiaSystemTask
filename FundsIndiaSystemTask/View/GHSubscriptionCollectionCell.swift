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
    
    lazy var avatarImageView: CachedImageView = {
        let v = CachedImageView()
        v.backgroundColor = .clear
        v.contentMode = .scaleAspectFill
        v.layer.cornerRadius = 6
        v.layer.masksToBounds = true
        return v
    }()
    
    //MARK: - Overrides
    
    override func configureViewComponents() {
        self.setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        self.addSubview(avatarImageView)
        avatarImageView.fillSuperview()
    }
    
    func setData(with item: GHSubscriptionModel) {
        if let strAvatar = item.owner?.avatar_url {
            self.avatarImageView.loadImage(urlString: strAvatar)
        }
    }
    
    //MARK: - Helper Functions
}
