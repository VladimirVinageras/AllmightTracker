//
//  StatisticsViewCell.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 07.07.2024.
//

import Foundation
import UIKit

final class StatisticsViewCell : UITableViewCell {
    private let countStatsLabel = UILabel()
    private let titleParameterLabel = UILabel()
    private let borderGradientLayer = CAGradientLayer()
    private let borderShapeLayer = CAShapeLayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUIElements()
        addSubviews()
        activateConstraints()
        selectionStyle = .none
        self.layer.cornerRadius = 16
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderGradientLayer.frame = contentView.bounds
        borderShapeLayer.path = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 16).cgPath
    }
    
    func setupUIElements(){
        countStatsLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        countStatsLabel.translatesAutoresizingMaskIntoConstraints = false
        countStatsLabel.textAlignment = .left
        countStatsLabel.textColor = .trackerBlack
        countStatsLabel.text = ""
        
        titleParameterLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleParameterLabel.translatesAutoresizingMaskIntoConstraints = false
        titleParameterLabel.textAlignment = .left
        titleParameterLabel.textColor = .trackerBlack
        titleParameterLabel.text = ""
        
        borderGradientLayer.colors = [
            UIColor.gradientColor1.cgColor,
            UIColor.gradientColor2.cgColor,
            UIColor.gradientColor3.cgColor
            ]
        borderGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        borderGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        borderGradientLayer.cornerRadius = 16
        
        borderShapeLayer.lineWidth = 2
        borderShapeLayer.strokeColor = UIColor.trackerBlack.cgColor
        borderShapeLayer.fillColor = UIColor.clear.cgColor
        borderShapeLayer.path = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 16).cgPath
        
        borderGradientLayer.mask = borderShapeLayer
        contentView.layer.addSublayer(borderGradientLayer)
        contentView.layer.masksToBounds = true
        }
    private func addSubviews(){
        contentView.addSubview(countStatsLabel)
        contentView.addSubview(titleParameterLabel)

    }
    private func activateConstraints(){
        NSLayoutConstraint.activate([
            countStatsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            countStatsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            countStatsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            countStatsLabel.bottomAnchor.constraint(equalTo: titleParameterLabel.topAnchor, constant: -7),
            
            titleParameterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleParameterLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            titleParameterLabel.topAnchor.constraint(equalTo: countStatsLabel.bottomAnchor, constant: 7),
            titleParameterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }
    func updateParameterTitle(with newTitle : String?){
        titleParameterLabel.text = newTitle
    }
    func updateCountLabelText(with newValue: Int){
        countStatsLabel.text = String(newValue)
    }
    
}
