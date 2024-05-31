//
//  AddNewTrackerViewController.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 13.05.2024.
//

import Foundation
import UIKit


class AddNewTrackerViewController : UIViewController {
    
    private var newHabitButton : UIButton?
    private var newSingleEventButton : UIButton?
    private var viewTitlelLabel : UILabel?
    
    init(){
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .trackerWhite
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
super.viewDidLoad()
        prepareButtons()
        prepareViewTitle()
        activateConstraints()
    }
    func prepareButtons(){
        newHabitButton = UIButton(type: .custom)
        guard let newHabitButton = newHabitButton else {return}

        newHabitButton.setTitle("Прывичка", for: .normal)
        newHabitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        newHabitButton.setTitleColor(.trackerWhite, for: .normal)
        newHabitButton.backgroundColor = .trackerBlack
        newHabitButton.contentEdgeInsets = UIEdgeInsets(top: 19, left: 32, bottom: 19, right: 32)
        newHabitButton.layer.cornerRadius = 16
        newHabitButton.translatesAutoresizingMaskIntoConstraints = false
        newHabitButton.addTarget(self, action: #selector(callCreateHabitViewController), for: .touchUpInside)
        
        view.addSubview(newHabitButton)
    
        
        newSingleEventButton = UIButton(type: .custom)
        guard let newSingleEventButton = newSingleEventButton else {return}
        newSingleEventButton.setTitle("Нерегулярное событие", for: .normal)
        newSingleEventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        newSingleEventButton.setTitleColor(.trackerWhite, for: .normal)
        newSingleEventButton.backgroundColor = .trackerBlack
        newSingleEventButton.contentEdgeInsets = UIEdgeInsets(top: 19, left: 32, bottom: 19, right: 32)

        newSingleEventButton.layer.cornerRadius = 16
        newSingleEventButton.translatesAutoresizingMaskIntoConstraints = false
        newSingleEventButton.addTarget(self, action: #selector(callCreateSingleEventViewController), for: .touchUpInside)
        view.addSubview(newSingleEventButton)
        
    }
    
    func prepareViewTitle(){
        viewTitlelLabel = UILabel()
        guard let viewTitleLabel = viewTitlelLabel else {return}
        view.addSubview(viewTitleLabel)
        viewTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        viewTitleLabel.text = "Создание трекера"
        viewTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        viewTitleLabel.textColor = .trackerBlack
    }
    
    func activateConstraints(){
        guard let newSingleEventButton = self.newSingleEventButton else {return}
        guard let newHabitButton = self.newHabitButton else {return}
        guard let viewTitleLabel = self.viewTitlelLabel else {return}
        
        NSLayoutConstraint.activate([
            viewTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            viewTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            newHabitButton.topAnchor.constraint(equalTo: viewTitleLabel.bottomAnchor, constant: 295),
            newHabitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            newHabitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            newSingleEventButton.topAnchor.constraint(equalTo: newHabitButton.bottomAnchor, constant: 16),
            newSingleEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            newSingleEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)

        ])
    }
    
    @objc func callCreateHabitViewController(){
        let createHabitViewController = CreateHabitViewController(isAnHabit: true)
        present(createHabitViewController, animated: true)
    }
    
    @objc func callCreateSingleEventViewController(){
        
        let createHabitViewController = CreateHabitViewController(isAnHabit: false)
        present(createHabitViewController, animated: true)
    }
}

