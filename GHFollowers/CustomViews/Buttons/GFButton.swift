//
//  GFButton.swift
//  GHFollowers
//
//  Created by Kalin Balabanov on 23/11/2020.
//

import UIKit

class GFButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) { // this is only for storyboard init but its required
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(backgroundColor: UIColor, title: String) {
        self.init(frame: .zero) // required // .zero becouse we alrady initialised the frame above adn we will place it in its correct place later in the VCs
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
    }
    
    
    private func configure() { // private so that no one can override it in the VCs
        layer.cornerRadius  = 10
        titleLabel?.font    = UIFont.preferredFont(forTextStyle: .headline) // the font we're gonna be using is system and can be adjusted based on phone settings
        setTitleColor(.white, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false // enables AutoLayout
    }

    
    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
    }
}
