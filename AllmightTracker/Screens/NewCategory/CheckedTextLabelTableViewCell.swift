//
//  NewCategoryTableViewCell.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 24.05.2024.
//

import Foundation
import UIKit

final class CheckedTextLabelTableViewCell : UITableViewCell {
    
    private var cellTitleTextLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = ""
        titleLabel.textColor = .trackerBlack
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return titleLabel
    }()
    
    private var navigationRightImageView : UIImageView = {
        let navigationRightImage = UIImageView()
        navigationRightImage.image = UIImage(named: "checkedBlue")
        navigationRightImage.tintColor = .trackerGray
        navigationRightImage.translatesAutoresizingMaskIntoConstraints = false
        navigationRightImage.isHidden = true
        return navigationRightImage
        
    }()
    
    private func activateConstraints(){
        
        NSLayoutConstraint.activate([
            
            cellTitleTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellTitleTextLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellTitleTextLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            cellTitleTextLabel.heightAnchor.constraint(equalToConstant: 22),
            
            navigationRightImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            navigationRightImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            navigationRightImageView.widthAnchor.constraint(equalToConstant: 24),
            navigationRightImageView.heightAnchor.constraint(equalToConstant: 24),
            
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        clipsToBounds = true
        backgroundColor = .trackerBackgroundDay
        
        contentView.addSubview(cellTitleTextLabel)
        contentView.addSubview(navigationRightImageView)
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTitleCellLabel(with newTitle: String){
        cellTitleTextLabel.text = newTitle
    }
    
    func toggleImageViewVisibility(){
        navigationRightImageView.isHidden.toggle()
    }
}
