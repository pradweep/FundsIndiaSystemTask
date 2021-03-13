//
//  BaseTableViewCell.swift
//  FundsIndiaSystemTask
//
//  Created by Pradeep's Macbook on 12/03/21.
//  Copyright © 2021 Motiv Ate Fitness. All rights reserved.
//
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    //MARK: - LifeCycle Methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureViewComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Handler Functions
    
    func configureViewComponents() {
        backgroundColor = .systemGroupedBackground
    }
    
    //MARK: - Selectors
    
}
