//
//  GFFollowItemVC.swift
//  GHFollowers
//
//  Created by Kalin Balabanov on 07/12/2020.
//

import Foundation

protocol GFFollowerItemVCDelegate: AnyObject {
    func getFollowersTapped(user: User)
}

class GFFollowerItemVC: GFItemInfoVC {
    
    weak var delegate: GFFollowerItemVCDelegate!
    
    
    init(user: User, delegate: GFFollowerItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItem()
    }
    
    
    func configureItem() {
        itemViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    
    override func actionButtonTapped() {
        delegate.getFollowersTapped(user: user)
        
    }
}
