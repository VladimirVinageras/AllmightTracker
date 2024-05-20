//
//  CreateEventViewController.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 13.05.2024.
//

import Foundation
import UIKit

final class CreateEventViewController : UIViewController {
    
    
    //MARK: Data
    
    private let colorsName = {
        var colors = [String]()
        for index in 0...17{
            colors.append(".colorSelection\(index + 1)")
        }
        return colors
    }()
    
    private let emojis : [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶",
                          "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    //MARK: CollectionView related Variables
    private let colorsCellIdentifier = "colorCell"
    private let emojisCellIdentifier = "emojisCell"
    private let interItemSpacing : CGFloat = 5
    private let interLinesSpacing : CGFloat = .zero
    var collectionViewDelegate : UICollectionViewDelegateFlowLayout?
    
    //MARK: TableView related Variables
    
    private let parametersTableViewCellIdentifier = "viewTableCell"
    var tableViewDelegate: UITableViewDelegate?
    
    
    //MARK: UI Elements
    private var viewTitleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Новая Привычка"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .trackerBlack
        return titleLabel
    }()
//    private var emojiCollectionViewTitleLabel : UILabel = {
//        var emojiCollectionTitleLabel = UILabel()
//        emojiCollectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        emojiCollectionTitleLabel.text = "Emoji"
//        emojiCollectionTitleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
//        emojiCollectionTitleLabel.textColor = .trackerBlack
//        return emojiCollectionTitleLabel
//    }()
//    private var colorsCollectionViewTitleLabel : UILabel = {
//        var colorsCollectionTitleLabel = UILabel()
//        colorsCollectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        colorsCollectionTitleLabel.text = "Emoji"
//        colorsCollectionTitleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
//        colorsCollectionTitleLabel.textColor = .trackerBlack
//        return colorsCollectionTitleLabel
//    }()
    
    
    private var newHabitNameTextField : UITextField = {
        
        var newHabitTextField = UITextField()
        newHabitTextField.translatesAutoresizingMaskIntoConstraints = false
        newHabitTextField.placeholder = "Введите название трекера"
        newHabitTextField.backgroundColor = .trackerLightGray
        newHabitTextField.layer.cornerRadius = 16
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        newHabitTextField.leftView = leftView
        newHabitTextField.leftViewMode = .always
        newHabitTextField.keyboardType = .default
        newHabitTextField.returnKeyType = .done
        newHabitTextField.becomeFirstResponder()
        return newHabitTextField
    }()
    
    private lazy var clearTextFieldButton : UIButton  = {
        let clearTextButton = UIButton(type: .custom)
        clearTextButton.setImage(UIImage(named: "xmark.circle"), for: .normal)
        clearTextButton.frame = CGRect(x: 0, y: 0, width: 17, height: 17)
        clearTextButton.contentMode = .scaleAspectFit
        clearTextButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        clearTextButton.isHidden = true
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 29, height: 17))
        rightView.addSubview(clearTextButton)
        newHabitNameTextField.rightView = rightView
        newHabitNameTextField.rightViewMode = .whileEditing
        return clearTextButton
    }()
    private var trackerParametersTableView: UITableView = {
        var parametersTableView = UITableView()
        parametersTableView.translatesAutoresizingMaskIntoConstraints = false
        return parametersTableView
    }()
    private var colorsNEmojisCollectionView = {
        let emojisColorsCollectionView = UICollectionView(frame: .zero , collectionViewLayout: UICollectionViewFlowLayout())
        return emojisColorsCollectionView
    }()
    
    //MARK: Functions
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trackerWhite
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        
        
        setupNewHabitNameTextField()
        
        colorsNEmojisCollectionView.delegate = self
        colorsNEmojisCollectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: colorsCellIdentifier)
        colorsNEmojisCollectionView.register(ColorsCollectionViewCell.self, forCellWithReuseIdentifier: emojisCellIdentifier)
        
        trackerParametersTableView.delegate = self
        trackerParametersTableView.dataSource = self
        trackerParametersTableView.register(CreateHabitTableViewCell.self, forCellReuseIdentifier: parametersTableViewCellIdentifier)
        trackerParametersTableView.layer.cornerRadius = 16
        trackerParametersTableView.separatorStyle = .none

        colorsNEmojisCollectionView.dataSource = self
        addingSubviews()
        activateConstraints()
    }
    
    func addingSubviews(){
        view.addSubview(viewTitleLabel)
        view.addSubview(newHabitNameTextField)
        view.addSubview(trackerParametersTableView)
        view.addSubview(colorsNEmojisCollectionView)
       
    }
    
    
    private func setupNewHabitNameTextField() {
        newHabitNameTextField.delegate = self
    }
    
    @objc func clearTextField(){
        clearTextFieldButton.isHidden = true
        newHabitNameTextField.text = ""
    }
    
    
    private func activateConstraints(){
        
        NSLayoutConstraint.activate([
            viewTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            viewTitleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            viewTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            newHabitNameTextField.topAnchor.constraint(equalTo: viewTitleLabel.bottomAnchor, constant: 38),
            newHabitNameTextField.centerXAnchor.constraint(equalTo: viewTitleLabel.centerXAnchor),
            newHabitNameTextField.heightAnchor.constraint(equalToConstant: 75),
            newHabitNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newHabitNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerParametersTableView.topAnchor.constraint(equalTo: newHabitNameTextField.bottomAnchor, constant: 24),
            trackerParametersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerParametersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerParametersTableView.heightAnchor.constraint(equalToConstant: 149),
            
          //  colorsNEmojisCollectionView.topAnchor.constraint(equalTo: trackerParametersTableView.bottomAnchor, constant: 24),
//            colorsNEmojisCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            colorsNEmojisCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            colorsNEmojisCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
        
    }
    
}

//MARK: DATA SOURCE FUNCTIONS
extension CreateHabitViewController :
    UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return emojis.count
        }
        else {
            return colorsName.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = colorsNEmojisCollectionView.dequeueReusableCell(withReuseIdentifier: emojisCellIdentifier, for: indexPath) as? EmojiCollectionViewCell
            guard let cell = cell else {return EmojiCollectionViewCell()}
            return cell
        }
        else{
            let cell = colorsNEmojisCollectionView.dequeueReusableCell(withReuseIdentifier: colorsCellIdentifier, for: indexPath) as? ColorsCollectionViewCell
            guard let cell = cell else {return ColorsCollectionViewCell()}
            return cell
        }
    }
}

//MARK: DELEGATE FLOW LAYOUT FUNCTIONS

extension CreateHabitViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return interLinesSpacing
//    }
}

//MARK: -  DELEGATE AND DATASOURCE TABLEVIEW FUNCTIONS

extension CreateHabitViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: parametersTableViewCellIdentifier, for: indexPath) as? CreateHabitTableViewCell else { return UITableViewCell() }
        
        
        if indexPath.row == 0 {
            cell.updateTitleCellLabel(with: "Категория")
        }
        else{
            cell.updateTitleCellLabel(with: "Расписание")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            
            print("Yesh!!")
            //            let scheduleViewController = ScheduleViewController()
            //            scheduleViewController.createTrackerViewController = self
            //            present(scheduleViewController, animated: true, completion: nil)
        }
        //        trackersTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let horizontalBarInset: CGFloat = 16
        let horizontalBarWidth = tableView.bounds.width - horizontalBarInset * 2
        let horizontalBarHeight: CGFloat = 1.0
        let horizontalBarX = horizontalBarInset
        let horizontalBarY = cell.frame.height - horizontalBarHeight
        let horizontalBarView = UIView(frame: CGRect(x: horizontalBarX, y: horizontalBarY, width: horizontalBarWidth, height: horizontalBarHeight))
        horizontalBarView.backgroundColor = .trackerGray
        cell.addSubview(horizontalBarView)
    }
}

//MARK: - TEXTFIELD DELEGATE

extension CreateHabitViewController :  UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        clearTextFieldButton.isHidden = textField.text?.isEmpty ?? false
        if textField.text?.isEmpty ?? false {
         //   createButton.isEnabled = false
         //   createButton.backgroundColor = .ypGray
        } else {
        //createButton.isEnabled = true
        //  createButton.backgroundColor = .ypBlackDay
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
