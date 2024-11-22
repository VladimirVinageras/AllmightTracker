//
//  TabBarController.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 05.05.2024.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        let trackerViewController = UINavigationController(rootViewController: TrackersViewController.shared)
        trackerViewController.tabBarItem = UITabBarItem(title: dictionaryUI.tabBarTrackers, image: UIImage(named: "tabBarTrackersIcon"), selectedImage: nil)
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(title: dictionaryUI.tabBarStatistics, image: UIImage(named: "tabBarStatisticsIcon"), selectedImage: nil)
        
        self.viewControllers = [trackerViewController, statisticsViewController]
        
        prepareSeparator()
    }
    
    private func prepareSeparator(){
        tabBar.layer.borderWidth = 0.5
        tabBar.clipsToBounds = true
    }
    
    
}
