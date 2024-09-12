//
//  FilterListViewController.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 03.07.2024.
//

import Foundation
import UIKit

final class FilterListViewController : UIViewController{
    
    let сellIdentifier = "cellIdentifier"
    
    var delegate: FilterListViewControllerDelegate?
    private var areFiltersEnable : [Bool] = []
    private var isCustomFilterActive : Bool
    private var activeFilter : Filters?
    
    private let filtersName = [
        dictionaryUI.filterListViewFiltersAllTrackers,
        dictionaryUI.filterListViewFiltersTodayTrackers,
        dictionaryUI.filterListViewFiltersCompletedTrackers,
        dictionaryUI.filterListViewFiltersNotCompletedTrackers]
    
    private lazy var viewTitleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .trackerBlack
        titleLabel.textAlignment = .center
        titleLabel.text = dictionaryUI.filterListViewTitle
        return titleLabel
    }()
    
    private var filtersTableView: UITableView = {
        var parametersTableView = UITableView()
        parametersTableView.translatesAutoresizingMaskIntoConstraints = false
        return parametersTableView
    }()
    
    init(areFiltersEnabled: [Bool], isCustomFilterActive: (isFilterActivated:Bool,filter: Filters?)) {
        self.areFiltersEnable = areFiltersEnabled
        self.isCustomFilterActive = isCustomFilterActive.isFilterActivated
        self.activeFilter = isCustomFilterActive.filter
        super.init(nibName: nil, bundle: nil)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trackerWhite
        filtersTableView.delegate = self
        setupTableView()
        addingSubviews()
        activateConstraints()
    }
    
    func setupTableView(){

        filtersTableView.delegate = self
        filtersTableView.dataSource = self
        filtersTableView.register(CheckedTextLabelTableViewCell.self, forCellReuseIdentifier: сellIdentifier)
        filtersTableView.layer.cornerRadius = 16
        filtersTableView.separatorStyle = .none
        filtersTableView.isScrollEnabled = false
    }
    
    func addingSubviews(){
        view.addSubview(viewTitleLabel)
        view.addSubview(filtersTableView)
    }
    
    private func activateConstraints(){
        
        NSLayoutConstraint.activate([
            viewTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            viewTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            filtersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filtersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filtersTableView.topAnchor.constraint(equalTo: viewTitleLabel.bottomAnchor, constant: 24),
            filtersTableView.heightAnchor.constraint(equalToConstant: CGFloat(filtersTableView.numberOfRows(inSection: 0)*75))
        ])
        
    }
}

extension FilterListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 75 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return filtersName.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: сellIdentifier, for: indexPath) as? CheckedTextLabelTableViewCell
        else { return UITableViewCell() }
        guard let filter = Filters(rawValue: indexPath.row) else { return UITableViewCell() }
        if activeFilter == filter{
            cell.toggleImageViewVisibility()
        }
        cell.updateTitleCellLabel(with: filtersName[indexPath.row].self)
        cell.isMultipleTouchEnabled = false
        if areFiltersEnable[indexPath.row] == false {
            cell.isUserInteractionEnabled = false
            cell.disabledCellStyle()
        }else{
            cell.isUserInteractionEnabled = true
            cell.enabledCellStyle()
        }
        cell.isUserInteractionEnabled =  areFiltersEnable[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: сellIdentifier, for: indexPath) as? CheckedTextLabelTableViewCell else {return}
        guard let filter = Filters.init(rawValue: indexPath.row) else {return}
        handleSelection(for: filter)
        cell.toggleImageViewVisibility()
        cell.selectionStyle = . none
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: сellIdentifier, for: indexPath) as? CheckedTextLabelTableViewCell else {return}
        cell.isSelected = false
    }


    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row < (filtersName.count - 1) {
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
}


extension FilterListViewController {
    private func handleSelection(for filter: Filters) {
        NotificationCenter.default.post(name: Notification.Name("ControlButtonColor"), object: nil)
        delegate?.customFilterDidSelect(withFilter: filter)
       
        }
}


extension CheckedTextLabelTableViewCell {
    func disabledCellStyle(){
        cellTitleTextLabel.textColor = .trackerLightGray
    }
    
    func enabledCellStyle(){
        cellTitleTextLabel.textColor = .trackerBlack
    }
}
