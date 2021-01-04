//
//  UserinfoVC.swift
//  GHFollowers
//
//  Created by Kalin Balabanov on 04/12/2020.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject {
    func requestFollowers(for username: String)
}


class UserInfoVC: GFDataLoadingVC {
    
    let scrollView      = UIScrollView()
    let contentView     = UIView()

    let headerView      = UIView()
    let itemViewOne     = UIView()
    let itemViewTwo     = UIView()
    let dateLabel       = GFBodyLabel(textAlignment: .center)
    
    var itemViews       = [UIView]()
    var username:       String!
    
    weak var delegate:  UserInfoVCDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        layoutUI()
        getFollowers()
        configureScrollView()
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    
    func getFollowers() {
        NetworkManager.shared.getUserInfo(username: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                DispatchQueue.main.async { self.setupChildElements(user: user) }
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went Wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    func add(childVC: UIViewController, to containerView: UIView) { // this is how we add the child vc to a container
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    
    func setupChildElements(user: User) {
        add(childVC: GFUserinfoHeaderVC(user: user), to: headerView)
        add(childVC: GFRepoItemVC(user: user, delegate: self), to: itemViewOne)
        add(childVC: GFFollowerItemVC(user: user, delegate: self), to: itemViewTwo)
        dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
    }
    
    
    func configure() {
        view.backgroundColor                = .systemBackground
        navigationItem.rightBarButtonItem   = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
    }
    
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive    = true
        contentView.heightAnchor.constraint(equalToConstant: 600).isActive              = true
    }
    
    
    func layoutUI() {
        let padding:    CGFloat = 20
        let itemHeight: CGFloat = 140
        
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        for itemView in itemViews {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}


extension UserInfoVC: GFRepoItemVCDelegate {
    
    func getProfileTapped(user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "the url attached to this user is invalid.", buttonTitle: "Ok")
            return
        }
        self.presentSafariVC(url: url)
    }
}


extension UserInfoVC: GFFollowerItemVCDelegate {
    
    func getFollowersTapped(user: User) {
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "No followers", message: "This use has no followers, what a shame.", buttonTitle: "So sad")
            return
        }
        delegate.requestFollowers(for: user.login)
        dismissVC()
    }
}
