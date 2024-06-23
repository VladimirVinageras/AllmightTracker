//
//  CreateCategoryViewController.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 22.05.2024.
//

import Foundation
import UIKit


final class CreateCategoryViewController : UIViewController {
    
    weak var delegate: CreatingCategoryViewControllerProtocol?
    
    private let viewModel : TrackerCateogoriesViewModel
    
    private lazy var viewTitleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = dictionaryUI.createCategoryTitle
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .trackerBlack
        return titleLabel
    }()
    
    private lazy var newCategoryNameTextField : UITextField = {
        var newCategoryTextField = UITextField()
        newCategoryTextField.translatesAutoresizingMaskIntoConstraints = false
        newCategoryTextField.placeholder = dictionaryUI.createCategoryTextFieldHolderText
        newCategoryTextField.backgroundColor = .trackerBackgroundDay
        newCategoryTextField.layer.cornerRadius = 16
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        newCategoryTextField.leftView = leftView
        newCategoryTextField.leftViewMode = .always
        newCategoryTextField.keyboardType = .default
        newCategoryTextField.returnKeyType = .done
        newCategoryTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return newCategoryTextField
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
        newCategoryNameTextField.rightView = rightView
        newCategoryNameTextField.rightViewMode = .whileEditing
        return clearTextButton
    }()
    
    private lazy var createCategoryButton: UIButton = {
        let createButton = UIButton(type: .custom)
        createButton.setTitleColor(.trackerWhite, for: .normal)
        createButton.backgroundColor = .trackerGray
        createButton.layer.cornerRadius = 16
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.setTitle(dictionaryUI.createCategoryBtnReady, for: .normal)
        createButton.addTarget(self, action: #selector(createCategoryButtonTapped), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.isEnabled = false
        return createButton
    }()
    
    @objc func createCategoryButtonTapped(){
        
        guard let name = newCategoryNameTextField.text else {return}
        let newCat = TrackerCategory(title: name, trackers: [])
        viewModel.addCategory(category: newCat)
        dismiss(animated: true)
    }
    
    
    init(viewModel: TrackerCateogoriesViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .trackerWhite
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        addSubviews()
        activateConstraints()
        newCategoryNameTextField.delegate = self
    }
 
    private func addSubviews(){
        view.addSubview(viewTitleLabel)
        view.addSubview(newCategoryNameTextField)
        view.addSubview(createCategoryButton)
    }
    
    @objc func clearTextField(){
        clearTextFieldButton.isHidden = true
        newCategoryNameTextField.text = ""
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {return}
        if !text.isEmpty {
            createCategoryButton.isEnabled = true
            createCategoryButton.backgroundColor = .trackerBlack
        }else{
            createCategoryButton.isEnabled = false
            createCategoryButton.backgroundColor = .trackerGray
        }
        
    }
    private func activateConstraints(){
        NSLayoutConstraint.activate([
        viewTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
        viewTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        viewTitleLabel.heightAnchor.constraint(equalToConstant: 22),
        
        newCategoryNameTextField.topAnchor.constraint(equalTo: viewTitleLabel.bottomAnchor, constant: 38),
        newCategoryNameTextField.centerXAnchor.constraint(equalTo: viewTitleLabel.centerXAnchor),
        newCategoryNameTextField.heightAnchor.constraint(equalToConstant: 75),
        newCategoryNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        newCategoryNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        
        createCategoryButton.heightAnchor.constraint(equalToConstant: 60),
        createCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:  -16),
        createCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        createCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)])
    }
    
    private func canCategoryBeCreated() -> Bool{
        guard let text = newCategoryNameTextField.text else {return false}
        return !text.isEmpty
    }
}



//MARK: - UIGestureRecognizerDelegate Functions

extension CreateCategoryViewController : UIGestureRecognizerDelegate {
    
    func handleTapsOnScreen(){
        let tapTextFieldGestureRecognizer = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tapTextFieldGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapTextFieldGestureRecognizer)
    }

}

//MARK: - TEXTFIELD DELEGATE

extension CreateCategoryViewController :  UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        clearTextFieldButton.isHidden = textField.text?.isEmpty ?? false
    }
    
}
