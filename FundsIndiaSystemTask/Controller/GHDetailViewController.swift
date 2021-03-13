//
//  GHDetailViewController.swift
//  FundsIndiaSystemTask
//
//  Created by Pradeep's Macbook on 12/03/21.
//  Copyright © 2021 Motiv Ate Fitness. All rights reserved.
//

import UIKit


struct GHFollowersModel: Decodable {
    var login: String?
}

struct GHFollowingModel: Decodable {
    var login: String?
}

struct GHUserModel: Decodable {
    var location: String?
}

struct GHUserRepos: Decodable {
    var name: String?
}

class GHDetailViewController: UIViewController {
    
    //MARK: - Private Properties
    
    private var ghRepoModel: GHRepoModel!
    private var followers: Int?
    private var following: Int?
    private var userLocation: String?
    private var userRepos: Int?
    private let dispatchGroup = DispatchGroup()
    
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
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 0
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.attributedText = self.setAttributedText("---", subtitle: "Following")
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 0
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    private lazy var userPostsLabel: UILabel = {
        let label = UILabel()
        label.attributedText = self.setAttributedText("---", subtitle: "Posts")
        label.font = .systemFont(ofSize: 17, weight: .bold)
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
        v.text = "San Fransisco"
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
        self.setupConstraints()
        self.configureNavBar()
        self.updateUI()
    }
    
    fileprivate func setupConstraints() {
        self.view.addSubview(rootStackView)
        self.view.addSubview(locationStackView)
        locationStackView.anchor(top: avatarImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init())
        locationStackView.centerXAnchor.constraint(equalTo: self.avatarImageView.centerXAnchor).isActive = true
        rootStackView.fillSuperview()
    }
    
    fileprivate func configureNavBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back"), style: .plain, target: self, action: #selector(handleBackAction))
    }
    
    fileprivate func updateUI() {
        self.title = self.ghRepoModel.name?.capitalizingFirstLetter()
        if let strAvatar = self.ghRepoModel.owner?.avatar_url {
            self.avatarImageView.loadImage(urlString: strAvatar) {
                self.avatarImageView.isHidden = false
            }
        }
    }
    
    fileprivate func setAttributedText(_ title: String, subtitle: String) -> NSAttributedString {
        let attributedLabel = NSMutableAttributedString(string: "\(title)\n", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)])
        attributedLabel.append(NSAttributedString.init(string: subtitle, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)]))
        return attributedLabel
    }
    
    private func executeConcurrentCalls() {
        
        dispatchGroup.enter()
        self.fetchFollowers { flag in
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        self.fetchFollowing { flag in
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        self.fetchUserLocation { flag in
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        self.fetchUserRepos { flag in
            self.dispatchGroup.leave()
        }
    
        dispatchGroup.notify(queue: .main) {
            OverlayView.sharedInstance.hideOverlay()
            print("*** Both apis are executed concurrently ***")
            self.updateLabelComponents()
        }
    }
    
    //MARK: - API Call
    
    private func executeFollowersService(completion: @escaping (Result<[GHFollowersModel], APIError>) -> ()) {
        NetworkService.sharedInstance.fetchData(endPoint: .getFollowers(by: self.ghRepoModel.owner?.login ?? ""), completionHandler: completion)
    }
    
    private func fetchFollowers(completion: @escaping (Bool) -> Void) {
        self.executeFollowersService { result in
            switch result {
            case .success(let followers):
                print("Followers count: \(followers.count)")
                self.followers = followers.count
                completion(true)
            case .failure(let error):
                completion(false)
                print("Error while retreving the followers: \(error)")
            }
        }
    }
    
    private func executeFollowingService(completion: @escaping (Result<[GHFollowingModel], APIError>) -> ()) {
        NetworkService.sharedInstance.fetchData(endPoint: .getFollowing(by: self.ghRepoModel.owner?.login ?? ""), completionHandler: completion)
    }
    
    private func fetchFollowing(completion:@escaping (Bool) -> Void) {
        self.executeFollowingService { result in
            switch result {
            case .success(let followings):
                self.following = followings.count
                completion(true)
            case .failure(let error):
                completion(false)
                print("Error while retreving the following: \(error)")
            }
        }
    }
    
    private func executeUserLocationService(completion: @escaping (Result<GHUserModel, APIError>) -> ()) {
        NetworkService.sharedInstance.fetchData(endPoint: .getUserLocation(by: self.ghRepoModel.owner?.login ?? ""), completionHandler: completion)
    }
    
    private func fetchUserLocation(completion:@escaping (Bool) -> Void) {
        self.executeUserLocationService { result in
            switch result {
            case .success(let userModel):
                self.userLocation = userModel.location
                completion(true)
            case .failure(let error):
                completion(false)
                print("Error while retreving the user location: \(error)")
            }
        }
    }
    
    private func executeUserReposService(completion: @escaping (Result<[GHUserRepos], APIError>) -> ()) {
        NetworkService.sharedInstance.fetchData(endPoint: .getUserRepos(by: self.ghRepoModel.owner?.login ?? ""), completionHandler: completion)
    }
    
    private func fetchUserRepos(completion:@escaping (Bool) -> Void) {
        self.executeUserReposService { result in
            switch result {
            case .success(let userPosts):
                self.userRepos = userPosts.count
                completion(true)
            case .failure(let error):
                completion(false)
                print("Error while retreving the user location: \(error)")
            }
        }
    }
    
    private func updateLabelComponents() {
        
        if let followers = self.followers {
            self.followersLabel.isHidden = false
            self.followersLabel.attributedText = self.setAttributedText("\(followers)", subtitle: "Followers")
        }
        
        if let following = self.following {
            self.followingLabel.isHidden = false
            self.followingLabel.attributedText = self.setAttributedText("\(following)", subtitle: "Following")
        }
        
        if let location = self.userLocation {
            self.locationStackView.isHidden = false
            self.locationLabel.text = location
        }
        
        if let userRepos = self.userRepos {
            self.userPostsLabel.isHidden = false
            self.userPostsLabel.attributedText = self.setAttributedText("\(userRepos)", subtitle: "Posts")
        }
    }
    
    //MARK:  - Selectors
    
    @objc fileprivate func handleBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
