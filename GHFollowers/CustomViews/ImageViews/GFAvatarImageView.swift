//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Kalin Balabanov on 26/11/2020.
//

import UIKit

class GFAvatarImageView: UIImageView {

    let cache            = NetworkManager.shared.cache
    let placeholderImage = Images.placeHolder
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        layer.cornerRadius  = 10
        clipsToBounds       = true // to fill in the image view so that the image can have the corner radius
        image               = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func downloadImage(fromURL url: String) {
        
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.image = image }
        }
    }
}
