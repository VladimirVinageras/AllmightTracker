//
//  OnboardingViewController.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 08.06.2024.
//

import UIKit

final class OnboardingViewController: UIPageViewController  {
    
    static let isNotMyFirstTime = "isNotMyFirstTime"
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .onboardingViewBlack
        pageControl.pageIndicatorTintColor = .onboardingViewGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var pages: [OnboardingPage] = {
        let page1 = OnboardingPage(with: UIImage(resource: .onboardingBackgroundPage1))
        page1.configureText(dictionaryUI.onboardingViewTextPage1, textColor: .black)
     
        let page2 = OnboardingPage(with: UIImage(resource: .onboardingBackgroundPage2))
        page2.configureText(dictionaryUI.onboardingViewTextPage2, textColor: .black)
        return [page1, page2]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        NotificationCenter.default.post(name: Notification.Name("ReloadOnboardingPage"), object: nil)
        
        
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -168),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension OnboardingViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let onboardingPage = viewController as? OnboardingPage,
              let viewControllerIndex = pages.firstIndex(of: onboardingPage) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return pages.last
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let onboardingPage = viewController as? OnboardingPage,
              let viewControllerIndex = pages.firstIndex(of: onboardingPage) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return pages.first
        }
        return pages[nextIndex]
    }
}

extension OnboardingViewController : UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
              let currentViewController = pageViewController.viewControllers?.first else {
            return
        }
        
        if let onboardingPage = currentViewController as? OnboardingPage,
           let currentIndex = pages.firstIndex(of: onboardingPage) {
            pageControl.currentPage = currentIndex
        }
    }
}
