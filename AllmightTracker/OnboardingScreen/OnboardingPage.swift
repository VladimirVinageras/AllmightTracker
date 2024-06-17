//
//  OnboardingPage.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 09.06.2024.
//

import Foundation
import UIKit



final class OnboardingPage : UIViewController {
    var textLabel = UILabel()
    var imageView = UIImageView()
    var button = UIButton()
    
    
    init(with image : UIImage){
    super.init(nibName: nil, bundle: nil)
        imageView.image = image
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
     super.viewDidLoad()
        setupUI()
        addSubviews()
        activateConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: Notification.Name("ReloadOnboardingPage"), object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ReloadOnboardingPage"), object: nil)
    }
    
   @objc private func reloadView(){
        setupUI()
    }
    
   private func addSubviews(){
       view.addSubview(imageView)
       view.addSubview(textLabel)
       view.addSubview(button)
    }
    
    private func setupUI(){
        textLabel.font = UIFont.systemFont(ofSize: 31.8, weight: .bold)
        textLabel.textAlignment = .center
        textLabel.textColor = .trackerBlack
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 2
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
    
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Вот это технологии!", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.backgroundColor = .trackerBlack
        button.tintColor = .trackerWhite
        button.addTarget(self, action: #selector(buttonTaped), for: .touchUpInside)
    }
    @objc func buttonTaped(){
        UserDefaults.standard.set(true, forKey: OnboardingViewController.isNotMyFirstTime)
        goToMainScreen()
    }
    
    func goToMainScreen(){
        let tabBarController = TabBarController()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = tabBarController
        } else if let sceneDelegate = UIApplication.shared.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = tabBarController
        }
    }
    
    private func activateConstraints(){
        NSLayoutConstraint.activate([
        imageView.topAnchor.constraint(equalTo: view.topAnchor),
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        
        button.heightAnchor.constraint(equalToConstant: 60),
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
        
        textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        textLabel.heightAnchor.constraint(equalToConstant: 76),
        textLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 432)
        
        ])
    }
}
