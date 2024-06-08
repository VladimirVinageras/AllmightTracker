//
//  CreateHabitTableViewCell.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 14.05.2024.
//

import Foundation
import UIKit

final class CreateHabitTableViewCell : UITableViewCell {
    private var isEmptySelectedElementsLabel = true
    private var selectedElement = ""
    private var tableViewCellConstraints : [NSLayoutConstraint?] = []
    
    var cellTitleTextLabel : UILabel = {
        let  titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = ""
        titleLabel.textColor = .trackerBlack
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return titleLabel
    }()
    
    
    private var selectedElementsLabel : UILabel = {
        let selectedElements = UILabel()
        selectedElements.translatesAutoresizingMaskIntoConstraints = false
        selectedElements.text = ""
        selectedElements.textColor = .trackerGray
        selectedElements.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return selectedElements
    }()
    
    private var elementsVStack : UIStackView = {
        let vstack = UIStackView()
        vstack.axis = .vertical
        vstack.translatesAutoresizingMaskIntoConstraints = false
        vstack.spacing = 2
    
        return vstack
        
    }()
    
    private var navigationRightImageView : UIImageView = {
        let navigationRightImage = UIImageView()
        navigationRightImage.image = UIImage(named: "navigationRight")
        navigationRightImage.tintColor = .trackerGray
        navigationRightImage.translatesAutoresizingMaskIntoConstraints = false
        return navigationRightImage
    }()
    
    private func activateConstraints(){
        
        NSLayoutConstraint.activate([
            
            elementsVStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            elementsVStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            elementsVStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -56),
            elementsVStack.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            elementsVStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
        
            navigationRightImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            navigationRightImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            navigationRightImageView.widthAnchor.constraint(equalToConstant: 24),
            navigationRightImageView.heightAnchor.constraint(equalToConstant: 24),
            
        ])
    }
    
    private func setupStacks(){
        addSubview(cellTitleTextLabel)
        addSubview(selectedElementsLabel)
        addSubview(elementsVStack)
        addSubview(navigationRightImageView)
    
        elementsVStack.addArrangedSubview(cellTitleTextLabel)
        elementsVStack.addArrangedSubview(selectedElementsLabel)

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .trackerBackgroundDay
        setupStacks()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSelectedElementsLabel(with newElements: String) {
        selectedElementsLabel.text = newElements
    }
    
    func updateTitleCellLabel(with newTitle: String){
        cellTitleTextLabel.text = newTitle
    }
}
