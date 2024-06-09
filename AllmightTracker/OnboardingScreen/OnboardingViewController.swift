//
//  OnboardingViewController.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 08.06.2024.
//

import UIKit

class OnboardingViewController: UIPageViewController {

     init() {
         super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
     
     }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var pageControl: UIPageControl = {
            let pageControl = UIPageControl()
            pageControl.numberOfPages = pages.count
            pageControl.currentPage = 0
            pageControl.currentPageIndicatorTintColor = .brown
            pageControl.pageIndicatorTintColor = .orange
            pageControl.translatesAutoresizingMaskIntoConstraints = false
            return pageControl
        }()
    
    lazy var pages: [OnboardingPage] = {
        let page1 = OnboardingPage(with: UIImage(resource: .onboardingBackgroundPage1))
        page1.textLabel.text = "Отслеживайте только \n то, что хотите"
    
        let page2 = OnboardingPage(with: UIImage(resource: .onboardingBackgroundPage2))
        page2.textLabel.text = "Даже если это \n не литры воды и йога"
        
        return [page1, page2]
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        guard let viewControllerIndex = pages.firstIndex(of: viewController as! OnboardingPage) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return pages.last
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController as! OnboardingPage) else {
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
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController as! OnboardingPage) {
            pageControl.currentPage = currentIndex
        }
    }
}
