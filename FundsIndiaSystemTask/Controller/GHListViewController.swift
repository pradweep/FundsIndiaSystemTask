//
//  GHListViewController.swift
//  FundsIndiaSystemTask
//
//  Created by Pradeep's Macbook on 12/03/21.
//  Copyright © 2021 Motiv Ate Fitness. All rights reserved.
//

import UIKit
import SwiftUI

class GHListViewController: UIViewController {
    
    //MARK: - Properties
    
    private var ghReposModel = [GHRepoModel]()
    
    //MARK: - Views
    
    private lazy var ghListTableView: GenericTableView<GHRepoModel,GHListTableViewCell> = {
        let tv = GenericTableView<GHRepoModel,GHListTableViewCell>.init(data:  self.ghReposModel, canEditRow: true, config: { (cell, model) in
            cell.ghRepoList = model
        }, selectionHandler: { (model) in
            self.routeToGHDetailVC(model: model)
        }) { _,_,_ in }
        return tv
    }()
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewComponents()
        self.fetchGithubRepos()
    }
    
    //MARK: - ConfigureViewComponents
    
    fileprivate func configureViewComponents(){
        self.view.backgroundColor = .white
        self.setupConstraints()
        self.configureNavBar()
    }
    
    fileprivate func configureNavBar() {
        self.title = "Public Repositories"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    fileprivate func setupConstraints() {
        self.view.addSubview(ghListTableView)
        ghListTableView.fillSuperview()
    }
    
    fileprivate func routeToGHDetailVC(model: GHRepoModel) {
        let ghDetailVC = GHDetailViewController(ghRepoModel: model)
        self.navigationController?.pushViewController(ghDetailVC, animated: true)
    }
    
    //MARK: - API Call
    
    private func executeGHListService(completion: @escaping (Result<[GHRepoModel], APIError>) -> Void) {
        NetworkService.sharedInstance.fetchData(endPoint: EndPoint.getPublicRepos(with: 10), completionHandler: completion)
    }
    
    private func fetchGithubRepos() {
        OverlayView.sharedInstance.showOverlay(self.view)
        self.executeGHListService { result in
            switch result {
            case .success(let repoModel):
                print("Accessing the username : \(repoModel[0].full_name!) Accessing the userdid: \(repoModel.last!.id!)")
                self.ghReposModel = repoModel
                self.ghListTableView.reloadOnMainThread(self.ghReposModel)
                OverlayView.sharedInstance.hideOverlay()
            case .failure(let error):
                print("Error while retreving the repos: \(error)")
                OverlayView.sharedInstance.hideOverlay()
                AlertController.showError(message: "\(error)")
            }
        }
    }
    

    //MARK:  - Selectors
    
}

/**
 
 Preview
 
 */

struct GHListPreviewVC: PreviewProvider, UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UINavigationController
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let vc = GHListViewController()
        return UINavigationController.init(rootViewController: vc)
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        //TODO
    }
    
    static var previews: some View {
        GHListPreviewVC()
            .previewDevice("iPhone 11")
    }
}
