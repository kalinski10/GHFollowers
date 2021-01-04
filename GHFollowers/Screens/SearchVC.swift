//
//  SearchVCViewController.swift
//  GHFollowers
//
//  Created by Kalin Balabanov on 22/11/2020.
//

import UIKit

class SearchVC: UIViewController {
    
    let logoImageView       = UIImageView()
    let usernameTextField   = GFTextField()
    let callToActionButton  = GFButton(backgroundColor: .systemGreen, title: "Get Followers")
    
    
    var isUserNameEntered: Bool { return !usernameTextField.text!.isEmpty }  // computed property used to for gurad statemmets, can do it multiline
    
    // MARK: - Overrides
    
    override func viewDidLoad() { // this funcion is every time the view loads
        super.viewDidLoad()
        configure()
    }

    
    override func viewDidAppear(_ animated: Bool) { // this happens everytime the view appears
        super.viewDidAppear(animated)
        usernameTextField.text = ""
//        navigationController?.isNavigationBarHidden = true // rmoves the top bar away
        navigationController?.setNavigationBarHidden(true, animated: true) // doing this so that when you half way transition through screen its less snappy and looks better
    }
    
    // MARK: - @objc Functions
    
    @objc func pushFollowerListVC() {
        
        guard isUserNameEntered else {
            presentGFAlertOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know who to look for 😀.", buttonTitle: "OK")
            return
        } // if the statement returns true then do the following lines of code
        
        usernameTextField.resignFirstResponder() // removes keyboard when pushing forward
        let followersListVC = FollowersListVC(username: usernameTextField.text!)
        navigationController?.pushViewController(followersListVC, animated: true)
    }
    
    // MARK: - Private functions
    
    private func configure() {
        view.backgroundColor = .systemBackground
        view.addSubviews(logoImageView, usernameTextField, callToActionButton)
        configureLogoImageView()
        ConfigureUserNameTextField()
        configureCallToActionButton()
        keyeboardDissmiser()
    }
    
    
    private func keyeboardDissmiser() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(view.endEditing)) // don't forget to add view.self otherwise it wouldnt work
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - layouts and configurations
    
    private func configureLogoImageView() {
        logoImageView.image = Images.ghLogo
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80 // endGame tweaks
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    private func ConfigureUserNameTextField() {
        usernameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48)
        ])
    }
    
    
    private func configureCallToActionButton() {
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50),
            callToActionButton.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            callToActionButton.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor)
        ])
    }
}

// MARK: - Extensions

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
