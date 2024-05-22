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
    var onButtonTap: (() -> Void)?
    
    var cellTitleTextButton : UIButton = {
        let  titleButton = UIButton(type: .system)
        titleButton.translatesAutoresizingMaskIntoConstraints = false
        titleButton.setTitle("", for: .normal)
        titleButton.tintColor = .trackerBlack
        titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleButton.titleLabel?.leadingAnchor.constraint(equalTo: titleButton.leadingAnchor).isActive = true
        titleButton.addTarget(self, action: #selector(titleButtonTaped), for:.touchUpInside)
        return titleButton
    }()
    
    private var selectedElementsLabel : UILabel = {
        let selectedElements = UILabel()
        selectedElements.text =  ""
        selectedElements.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        selectedElements.textColor = .trackerGray
        selectedElements.translatesAutoresizingMaskIntoConstraints = false
        return selectedElements
    }()
    
    private var navigationRightImageView : UIImageView = {
        let navigationRightImage = UIImageView()
        navigationRightImage.image = UIImage(named: "navigationRight")
        navigationRightImage.tintColor = .trackerGray
        navigationRightImage.translatesAutoresizingMaskIntoConstraints = false
        return navigationRightImage
    }()
    
    @objc
    private func titleButtonTaped(){
        onButtonTap?()
    }
    
    
    
    private func activateConstraints(){
        
        if let selectedElementsLabelText = selectedElementsLabel.text{
            isEmptySelectedElementsLabel = selectedElementsLabelText.isEmpty
        } else{
            isEmptySelectedElementsLabel = true
        }
        NSLayoutConstraint.activate([
            
            cellTitleTextButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellTitleTextButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: isEmptySelectedElementsLabel ? 27 : 15),
            cellTitleTextButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            cellTitleTextButton.heightAnchor.constraint(equalToConstant: 22),
        
            selectedElementsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            selectedElementsLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            selectedElementsLabel.heightAnchor.constraint(equalToConstant: isEmptySelectedElementsLabel ? 0 : 22),
            selectedElementsLabel.topAnchor.constraint(equalTo: cellTitleTextButton.bottomAnchor, constant: isEmptySelectedElementsLabel ? 26 : 2),
            selectedElementsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: isEmptySelectedElementsLabel ? 0 : -14),
            
            navigationRightImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            navigationRightImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            navigationRightImageView.widthAnchor.constraint(equalToConstant: 24),
            navigationRightImageView.heightAnchor.constraint(equalToConstant: 24),
            
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        clipsToBounds = true
        backgroundColor = .trackerLightGray
        
        contentView.addSubview(cellTitleTextButton)
        addSubview(selectedElementsLabel)
        addSubview(navigationRightImageView)
        activateConstraints()
 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSelectedElementsLabel(with newElements: String) {
        
         selectedElementsLabel.text = newElements
        isEmptySelectedElementsLabel = newElements.isEmpty ? true : false
    
    }
    
    func updateTitleCellLabel(with newTitle: String){
        cellTitleTextButton.setTitle(newTitle, for: .normal)
    }
}
