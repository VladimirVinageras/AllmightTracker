//
//  CreateHabitViewController.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 13.05.2024.
//

import Foundation
import UIKit

final class CreateHabitViewController : UIViewController {
    
    
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
    let colorsCellIdentifier = "colorCell"
    let emojisCellIdentifier = "emojisCell"
    let headerSectionIdentifier = "header"
    private let interItemSpacing : CGFloat = 5
    private let interLinesSpacing : CGFloat = .zero
    var collectionViewDelegate : UICollectionViewDelegateFlowLayout?
    
    //MARK: TableView related Variables
    
    private let parametersTableViewCellIdentifier = "viewTableCell"
    var tableViewDelegate: UITableViewDelegate?
    
    
    //MARK: UI Elements
    private var colorsCollectionView : UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
        layout.itemSize = CGSize(width: 52, height: 52)
        
        let collectionView = UICollectionView(frame: .zero , collectionViewLayout: layout)
        return collectionView
    }()
    
    private var emojisCollectionView : UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
        layout.itemSize = CGSize(width: 52, height: 52)
        
        let collectionView = UICollectionView(frame: .zero , collectionViewLayout: layout)
        return collectionView
    }()
    

    
    func setupCollectionViews(){

        colorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        colorsCollectionView.allowsMultipleSelection = false
        colorsCollectionView.register(ColorsCollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
        colorsCollectionView.register(HeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        view.addSubview(colorsCollectionView)
        colorsCollectionView.delegate = collectionViewDelegate
        colorsCollectionView.dataSource = self
        
        emojisCollectionView.translatesAutoresizingMaskIntoConstraints = false
        emojisCollectionView.allowsMultipleSelection = false
        emojisCollectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "emojisCell")
        emojisCollectionView.register(HeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        emojisCollectionView.dataSource = self
        emojisCollectionView.delegate = collectionViewDelegate
     
        view.addSubview(emojisCollectionView)
    }
    
    
    
    private lazy var viewTitleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Новая Привычка"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .trackerBlack
        return titleLabel
    }()

    private lazy var newHabitNameTextField : UITextField = {
        
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
    
    private lazy var cancelButton: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setTitleColor(.trackerRed, for: .normal)
        cancelBtn.layer.borderWidth = 1.0
        cancelBtn.layer.borderColor = UIColor.trackerRed.cgColor
        cancelBtn.layer.cornerRadius = 16
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelBtn.setTitle("Отменить", for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelBtnTaped), for: .touchUpInside)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        return cancelBtn
    }()
    private lazy var createEventButton: UIButton = {
        let createButton = UIButton(type: .custom)
        createButton.setTitleColor(.trackerWhite, for: .normal)
        createButton.backgroundColor = .trackerGray
        createButton.layer.cornerRadius = 16
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.setTitle("Создать", for: .normal)
        createButton.addTarget(self, action: #selector(createEventButtonTapped), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.isEnabled = false
        return createButton
    }()
    
    @objc
    private func cancelBtnTaped(){
    }
    
    @objc func createEventButtonTapped(){
        
    }
    
    private lazy var trackerParametersTableView: UITableView = {
        var parametersTableView = UITableView()
        parametersTableView.translatesAutoresizingMaskIntoConstraints = false
        return parametersTableView
    }()
    
    
    
    //MARK: Functions
    init(){
        super.init(nibName: nil, bundle: nil)
        collectionViewDelegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .trackerWhite
       
        setupCollectionViews()
        setupTableView()
        newHabitNameTextField.delegate = self
        
        addingSubviews()
        activateConstraints()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
    }
    
    func setupTableView(){
        trackerParametersTableView.delegate = self
        trackerParametersTableView.dataSource = self
        trackerParametersTableView.register(CreateHabitTableViewCell.self, forCellReuseIdentifier: parametersTableViewCellIdentifier)
        trackerParametersTableView.layer.cornerRadius = 16
        trackerParametersTableView.separatorStyle = .none
    }

    
    
    
    func addingSubviews(){
        view.addSubview(viewTitleLabel)
        view.addSubview(newHabitNameTextField)
        view.addSubview(trackerParametersTableView)
     
        view.addSubview(cancelButton)
        view.addSubview(createEventButton)
       
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
            
            emojisCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            emojisCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emojisCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            colorsCollectionView.topAnchor.constraint(equalTo: emojisCollectionView.bottomAnchor, constant: 16),
            colorsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colorsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.topAnchor.constraint(equalTo: colorsCollectionView.bottomAnchor, constant: 16),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: colorsCollectionView.centerXAnchor, constant: -4),
            createEventButton.heightAnchor.constraint(equalToConstant: 60),
            createEventButton.topAnchor.constraint(equalTo: colorsCollectionView.bottomAnchor, constant: 16),
            createEventButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:  -16),
            createEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createEventButton.trailingAnchor.constraint(equalTo: colorsCollectionView.centerXAnchor, constant: 4)
            
        ])
        
    }
    
}

//MARK: DATA SOURCE FUNCTIONS
extension CreateHabitViewController : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == emojisCollectionView ? emojis.count : colorsName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojisCollectionView{
            guard let cell = emojisCollectionView.dequeueReusableCell(withReuseIdentifier: "emojisCell", for: indexPath) as? EmojiCollectionViewCell else {return EmojiCollectionViewCell()}
            cell.titleLabel.text = emojis[indexPath.item]
            return cell
        }
        else{
            guard let cell = colorsCollectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? ColorsCollectionViewCell else {return ColorsCollectionViewCell()}
            let colorView = UIView()
            colorView.backgroundColor = UIColor(named: colorsName[indexPath.item])
            cell.colorView = colorView
            return cell
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard  let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? HeaderCollectionView else { return HeaderCollectionView()}
//        header.titleLabel.text = collectionView == emojisCollectionView ? "Emojis" : "Colors"
//        return header
//    }
}

//MARK: DELEGATE FLOW LAYOUT FUNCTIONS

extension CreateHabitViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interLinesSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 460)
    }
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
        if indexPath.row == 0 {
            
            print("Yesh!!")
            //            let scheduleViewController = ScheduleViewController()
            //            scheduleViewController.createTrackerViewController = self
            //            present(scheduleViewController, animated: true, completion: nil)
        }
        else{
            print("расписание!!!!!!")
            
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
            createEventButton.isEnabled = false
            createEventButton.backgroundColor = .trackerGray
        } else {
            createEventButton.isEnabled = true
            createEventButton.backgroundColor = .trackerBlack
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
