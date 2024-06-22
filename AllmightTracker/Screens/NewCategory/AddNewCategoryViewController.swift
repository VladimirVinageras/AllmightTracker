//
//  AddNewCategoryViewController.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 22.05.2024.
//

import Foundation
import UIKit


final class AddNewCategoryViewController : UIViewController{

  
    private var trackerCategoriesViewModel : TrackerCateogoriesViewModel

    let categoryCellReuseIdentifier = "categoryCell"
    
    private var newCategoryButton : UIButton = {
        let categoryButton = UIButton(type: .custom)
        categoryButton.setTitle("Добавить категорию", for: .normal)
        categoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        categoryButton.setTitleColor(.trackerWhite, for: .normal)
        categoryButton.backgroundColor = .trackerBlack
        categoryButton.contentEdgeInsets = UIEdgeInsets(top: 19, left: 32, bottom: 19, right: 32)
        categoryButton.layer.cornerRadius = 16
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.addTarget(self, action: #selector(newCategoryButtonTapped), for: .touchUpInside)
        return categoryButton
    }()
    
    @objc private func newCategoryButtonTapped(){
        let createCategoryViewController = CreateCategoryViewController(viewModel: trackerCategoriesViewModel)
        present(createCategoryViewController, animated: true)
    }
    
    private var viewTitleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Категория"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .trackerBlack
        return titleLabel
    }()
    
    private var containerViewHolder : UIView = {
        var container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .trackerWhite
        container.clipsToBounds = true
        return container
    }()
    
    private let categoriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        return tableView
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
    
    
    init(viewModel: TrackerCateogoriesViewModel){
        self.trackerCategoriesViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .trackerWhite
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        addSubviews()
        activateConstraints()
        self.setupContainerView()
        self.categoriesTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        binding()
    }
    
   private func binding(){
       trackerCategoriesViewModel.categoriesBinding = { [weak self] _ in
               guard let self = self else  {return}
              self.prepareCategoriesTableView()
               self.categoriesTableView.reloadData()
           self.setupContainerView()
           self.categoriesTableView.reloadData()
           }
    }
    
    
    func updateCategoriesTableViewHeight(){
        let numberOfCells = categoriesTableView.numberOfRows(inSection: 0)
        let cellHeight: CGFloat = 75
        let totalHeight = CGFloat(numberOfCells) * cellHeight
        categoriesTableView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
        
    }
    func setupContainerView(){
        for view in containerViewHolder.subviews {
            view.removeFromSuperview()
        }
        containerViewHolder.removeConstraints(containerViewHolder.constraints)
        
        if self.trackerCategoriesViewModel.trackerCategories.isEmpty {
            starLabel.isHidden = false
            starImageView.isHidden = false
            containerViewHolder.addSubview(starImageView)
            containerViewHolder.addSubview(starLabel)
            NSLayoutConstraint.activate([
                starImageView.centerXAnchor.constraint(equalTo: containerViewHolder.centerXAnchor),
                starImageView.topAnchor.constraint(equalTo: containerViewHolder.topAnchor, constant: 246),
                starImageView.heightAnchor.constraint(equalToConstant: 80),
                starImageView.widthAnchor.constraint(equalToConstant: 80),
                starLabel.centerXAnchor.constraint(equalTo: starImageView.centerXAnchor),
                starLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 8),
            ])
        }
        else
        {
            prepareCategoriesTableView()
            containerViewHolder.addSubview(categoriesTableView)
            starLabel.isHidden = true
            starImageView.isHidden = true
            let numberOfCells = categoriesTableView.numberOfRows(inSection: 0)
            let cellHeight: CGFloat = 75
            let totalHeight = CGFloat(numberOfCells) * cellHeight
            
            NSLayoutConstraint.activate([
                categoriesTableView.topAnchor.constraint(equalTo: containerViewHolder.topAnchor),
                categoriesTableView.leadingAnchor.constraint(equalTo: containerViewHolder.leadingAnchor),
                categoriesTableView.trailingAnchor.constraint(equalTo: containerViewHolder.trailingAnchor),
                categoriesTableView.bottomAnchor.constraint(equalTo: containerViewHolder.topAnchor, constant: totalHeight)
            ])
        }
    }
    func prepareCategoriesTableView(){
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.register(NewCategoryTableViewCell.self, forCellReuseIdentifier: categoryCellReuseIdentifier)
    }
    func addSubviews(){
        view.addSubview(viewTitleLabel)
        view.addSubview(containerViewHolder)
        view.addSubview(newCategoryButton)
    }
    func activateConstraints(){
        NSLayoutConstraint.activate([
            viewTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            viewTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerViewHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerViewHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerViewHolder.topAnchor.constraint(equalTo: viewTitleLabel.bottomAnchor, constant: 24),
            containerViewHolder.bottomAnchor.constraint(equalTo: newCategoryButton.topAnchor, constant: -8),
            newCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            newCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            newCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension AddNewCategoryViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trackerCategoriesViewModel.trackerCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellReuseIdentifier,
                                                       for: indexPath) as? NewCategoryTableViewCell else {return NewCategoryTableViewCell()}
        let newTitle = self.trackerCategoriesViewModel.trackerCategories[indexPath.row].title
        cell.updateTitleCellLabel(with: newTitle)
        return cell
    }
    
    
}
extension AddNewCategoryViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellReuseIdentifier,
                                                       for: indexPath) as? NewCategoryTableViewCell else {return}
        cell.toggleImageViewVisibility()
    
        self.trackerCategoriesViewModel.didSelect(at: indexPath.row)
    
        categoriesTableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 75 }
}






