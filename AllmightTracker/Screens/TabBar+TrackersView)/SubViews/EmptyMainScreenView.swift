//
//  EmptyMainScreenView.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 05.07.2024.
//

import Foundation
import UIKit

final class EmptyMainScreenView : UIView{
    private let starImageView = UIImageView()
    private let starLabel = UILabel()
    private var imageToShow : UIImage?
    private var textToShow  : String?
    init(imageToShow: UIImage?, textToShow: String?){
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.imageToShow = imageToShow
        self.textToShow = textToShow
        prepareStarMainScreen()
        addSubview(starImageView)
        addSubview(starLabel)
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareStarMainScreen(){
        
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.image = imageToShow
        starImageView.frame.size = CGSize(width: 80, height: 80)
        
        starLabel.translatesAutoresizingMaskIntoConstraints = false
        starLabel.text = textToShow
        starLabel.textColor = .trackerBlack
        starLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    
    func activateConstraints(){
        NSLayoutConstraint.activate([
            starImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            starImageView.topAnchor.constraint(equalTo: topAnchor, constant: 246),
            starImageView.heightAnchor.constraint(equalToConstant: 80),
            starImageView.widthAnchor.constraint(equalToConstant: 80),
            starLabel.centerXAnchor.constraint(equalTo: starImageView.centerXAnchor),
            starLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 8)
        ])
    }
    
    func updateImageToShow(with newImage: UIImage?){
        imageToShow = newImage
    }
    func updateTextToShow(with newText : String?){
        textToShow = newText
    }
}
