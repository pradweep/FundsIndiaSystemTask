//
//  GHSubscriptionHeader.swift
//  FundsIndiaSystemTask
//
//  Created by Pradeep's Macbook on 13/03/21.
//  Copyright © 2021 Motiv Ate Fitness. All rights reserved.
//

import UIKit

class GHSubscriptionHeader: UICollectionReusableView {
    
    //MARK: - Properties
    
    lazy var sectionHeaderLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.sizeToFit()
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure Layout
    
    fileprivate func configureLayoutUI() {
        self.addSubviewsToParent(sectionHeaderLabel)
        sectionHeaderLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 16), size: .init())
    }
    
}
