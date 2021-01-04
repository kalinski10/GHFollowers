//
//  GFTextField.swift
//  GHFollowers
//
//  Created by Kalin Balabanov on 23/11/2020.
//

import UIKit

class GFTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius          = 10
        layer.borderWidth           = 2
        layer.borderColor           = UIColor.systemGray4.cgColor
            
        textColor                   = .label
        tintColor                   = .label // tintColor is the blinkerColor
        textAlignment               = .center
        font                        = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth   = true // allows to adjust font size if the text is too long
        minimumFontSize             = 12 // the smallest it can go to is 12
        
        clearButtonMode             = .whileEditing // adds а nice little x on the right of the field
        placeholder                 = "Enter a Username"
        backgroundColor             = .tertiarySystemBackground
        autocorrectionType          = .no
        keyboardType                = .default // this way you can add the different types of keyboard
        returnKeyType               = .go // this is what the return key would say
    }
}
