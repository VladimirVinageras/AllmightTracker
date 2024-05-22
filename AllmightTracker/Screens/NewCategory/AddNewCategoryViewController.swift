//
//  AddNewCategoryViewController.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 22.05.2024.
//

import Foundation
import UIKit
 

final class AddNewCategoryViewController : UIViewController {
    private var newCategoryButton : UIButton = {
       let categoryButton = UIButton(type: .custom)
        categoryButton.setTitle("Добавить категорию", for: .normal)
        categoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        categoryButton.setTitleColor(.trackerWhite, for: .normal)
        categoryButton.backgroundColor = .trackerBlack
        categoryButton.contentEdgeInsets = UIEdgeInsets(top: 19, left: 32, bottom: 19, right: 32)
        categoryButton.layer.cornerRadius = 16
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.addTarget(AddNewCategoryViewController.self, action: #selector(newCategoryButtonTapped), for: .touchUpInside)
        return categoryButton
    }()
    
    private var viewTitleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Категория"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .trackerBlack
        return titleLabel
    }()
    
    
    
    private let starImageView :  UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "StarMainScreen")
        imageView.frame.size = CGSize(width: 80, height: 80)
        return imageView
    }()
    
    private let starLabel : UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Привычки и события можно \n объединить по смыслу"
        label.textAlignment = .center
        label.textColor = .trackerBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    
    init(){
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .trackerWhite
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
super.viewDidLoad()
        addSubviews()
        activateConstraints()
    }
    
    func addSubviews(){
        view.addSubview(newCategoryButton)
        view.addSubview(viewTitleLabel)
        view.addSubview(starImageView)
        view.addSubview(starLabel)
    }
    
    func activateConstraints(){
        NSLayoutConstraint.activate([
            viewTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            viewTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            starImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starImageView.topAnchor.constraint(equalTo: viewTitleLabel.bottomAnchor, constant: 246),
            starImageView.heightAnchor.constraint(equalToConstant: 80),
            starImageView.widthAnchor.constraint(equalToConstant: 80),
            starLabel.centerXAnchor.constraint(equalTo: starImageView.centerXAnchor),
            starLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 8),

            newCategoryButton.topAnchor.constraint(equalTo: starLabel.bottomAnchor, constant: 232),
            newCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            newCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
    @objc func newCategoryButtonTapped(){
        present(CreateCategoryViewController(), animated: true)
    }
}
    


    

