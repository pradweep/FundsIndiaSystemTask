//
//  GHDetailViewController.swift
//  FundsIndiaSystemTask
//
//  Created by Pradeep's Macbook on 12/03/21.
//  Copyright © 2021 Motiv Ate Fitness. All rights reserved.
//

import UIKit

class GHDetailViewController: UIViewController {
    
    //MARK: - Private Properties
    
    private var ghRepoModel: GHRepoModel!
    private var ghUserModel: GHUserModel?
    private var ghSubscriptionModel: [GHSubscriptionModel]?
    private let dispatchGroup = DispatchGroup()
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    //MARK: - Views
    
    private lazy var avatarImageView: CachedImageView = {
        let v = CachedImageView()
        v.backgroundColor = .clear
        v.contentMode = .scaleAspectFit
        v.constrainWidth(constant: 100)
        v.constrainHeight(constant: 100)
        v.layer.cornerRadius = 100 / 2
        v.layer.masksToBounds = true
        v.isHidden = true
        return v
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.attributedText = self.setAttributedText("---", subtitle: "Followers")
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 0
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.attributedText = self.setAttributedText("---", subtitle: "Following")
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 0
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    private lazy var userPostsLabel: UILabel = {
        let label = UILabel()
        label.attributedText = self.setAttributedText("---", subtitle: "Posts")
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 0
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    private lazy var hStackView: UIStackView = {
        let sv = UIStackView.init(arrangedSubviews: [
            avatarImageView,
            userPostsLabel,
            followersLabel,
            followingLabel,
            UIView()
        ])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .center
        sv.isLayoutMarginsRelativeArrangement = true
        sv.spacing = 12
        sv.layoutMargins = .init(top: 8, left: 24, bottom: 8, right: 12)
        return sv
    }()
    
    private lazy var pinImageView: UIImageView = {
        let v = UIImageView()
        v.image = #imageLiteral(resourceName: "ic_location").withRenderingMode(.alwaysTemplate)
        v.tintColor = .systemBlue
        v.constrainWidth(constant: 20)
        v.constrainHeight(constant: 20)
        return v
    }()
    
    private lazy var locationLabel: UILabel = {
        let v = UILabel()
        v.text = "---"
        v.sizeToFit()
        return v
    }()
    
    private lazy var locationStackView: UIStackView = {
        let sv = UIStackView.init(arrangedSubviews: [
            pinImageView,
            locationLabel
        ])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 8
        sv.isHidden = true
        return sv
    }()
    
    private lazy var subscriptionCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: self.generateFlowLayout())
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private lazy var rootStackView: UIStackView = {
        let sv = UIStackView.init(arrangedSubviews: [
            hStackView,
            UIView()
        ])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.isLayoutMarginsRelativeArrangement = true
        sv.spacing = 12
        sv.layoutMargins = .init(top: 24, left: 0, bottom: 12, right: 0)
        return sv
    }()
    
    //MARK: - LifeCycle
    
    init(ghRepoModel: GHRepoModel) {
        self.ghRepoModel = ghRepoModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewComponents()
        OverlayView.sharedInstance.showOverlay(self.view)
        self.executeConcurrentCalls()
    }
    
    //MARK: - ConfigureViewComponents
    
    fileprivate func configureViewComponents(){
        self.view.backgroundColor = .white
        self.configureCollectionView()
        self.setupConstraints()
        self.configureNavBar()
        self.updateUI()
    }
    
    fileprivate func setupConstraints() {
        self.view.addSubviewsToParent(rootStackView,
                                      locationStackView,
                                      subscriptionCollectionView)
        locationStackView.anchor(top: avatarImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init())
        locationStackView.centerXAnchor.constraint(equalTo: self.avatarImageView.centerXAnchor).isActive = true
        rootStackView.fillSuperview()
        subscriptionCollectionView.anchor(top: self.locationStackView.bottomAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init())
    }
    
    fileprivate func configureNavBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back"), style: .plain, target: self, action: #selector(handleBackAction))
    }
    
    fileprivate func updateUI() {
        self.title = self.ghRepoModel.name?.capitalizingFirstLetter()
    }
    
    fileprivate func setAttributedText(_ title: String, subtitle: String) -> NSAttributedString {
        let attributedLabel = NSMutableAttributedString(string: "\(title)\n", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)])
        attributedLabel.append(NSAttributedString.init(string: subtitle, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)]))
        return attributedLabel
    }
    
    private func executeConcurrentCalls() {
        dispatchGroup.enter()
        self.fetchUserData { flag in
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        self.fetchSubscriptionData { flag in
            self.subscriptionCollectionView.reloadData()
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            OverlayView.sharedInstance.hideOverlay()
        }
    }
    
    //MARK: - API Call
    
    private func executeUserDataService(completion: @escaping (Result<GHUserModel, APIError>) -> ()) {
        NetworkService.sharedInstance.fetchData(endPoint: .getUserData(by: self.ghRepoModel.owner?.login ?? ""), completionHandler: completion)
    }
    
    private func fetchUserData(completion:@escaping (Bool) -> Void) {
        self.executeUserDataService { result in
            switch result {
            case .success(let userModel):
                self.ghUserModel = userModel
                self.updateLabelComponents(with: self.ghUserModel)
                completion(true)
                OverlayView.sharedInstance.hideOverlay()
            case .failure(let error):
                completion(false)
                print("Error while retreving the user location: \(error)")
                OverlayView.sharedInstance.hideOverlay()
            }
        }
    }
    
    private func executeSubscriptionService(completion: @escaping (Result<[GHSubscriptionModel], APIError>) -> ()) {
        NetworkService.sharedInstance.fetchData(endPoint: .getUserSubscriptions(by: self.ghRepoModel.owner?.login ?? ""), completionHandler: completion)
    }
    
    private func fetchSubscriptionData(completion:@escaping (Bool) -> Void) {
        self.executeSubscriptionService { result in
            switch result {
            case .success(let subscriptionModel):
                self.ghSubscriptionModel = subscriptionModel
                completion(true)
            case .failure(let error):
                completion(false)
                print("Error while retreving the user location: \(error)")
            }
        }
    }
    
    private func updateLabelComponents(with userModel: GHUserModel?) {
        
        if let strAvatar = userModel?.avatar_url {
            self.avatarImageView.loadImage(urlString: strAvatar) {
                self.avatarImageView.isHidden = false
            }
        }
        
        if let followers = userModel?.followers {
            self.followersLabel.isHidden = false
            self.followersLabel.attributedText = self.setAttributedText("\(followers)", subtitle: "Followers")
        }
        
        if let following = userModel?.following {
            self.followingLabel.isHidden = false
            self.followingLabel.attributedText = self.setAttributedText("\(following)", subtitle: "Following")
        }
        
        if let location = userModel?.location {
            self.locationStackView.isHidden = false
            self.locationLabel.text = location
        }
        
        if let userRepos = userModel?.public_repos {
            self.userPostsLabel.isHidden = false
            self.userPostsLabel.attributedText = self.setAttributedText("\(userRepos)", subtitle: "Posts")
        }
    }
    
    //MARK:  - Selectors
    
    @objc fileprivate func handleBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - CollectionView Interface

extension GHDetailViewController {
    
    private func configureCollectionView() {
        self.subscriptionCollectionView.showsVerticalScrollIndicator = false
        self.subscriptionCollectionView.backgroundColor = .white
        self.subscriptionCollectionView.register(GHSubscriptionCollectionCell.self)
        self.subscriptionCollectionView.registerHeader(GHSubscriptionHeader.self, kind: GHDetailViewController.sectionHeaderElementKind)
    }
    
    private func generateFlowLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout.init { (section, env) -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                return self.generateGridLayout()
            default:
                break
            }
            return nil
        }
        return layout
    }
    
    private func generateGridLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize.init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.33))
        let item = NSCollectionLayoutItem.init(layoutSize: itemSize)
        item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize.init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.33))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        let section = NSCollectionLayoutSection.init(group: group)
        let headerSize = NSCollectionLayoutSize.init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: GHDetailViewController.sectionHeaderElementKind, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
}

//MARK: - UICollectionView Delegate and DataSource

extension GHDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ghSubscriptionModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GHSubscriptionCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setData(with: self.ghSubscriptionModel?[indexPath.row] ?? GHSubscriptionModel())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header: GHSubscriptionHeader = collectionView.dequeueSuplementaryView(of: kind, at: indexPath)
        header.sectionHeaderLabel.text = "Subscriptions"
        return header
    }
}
