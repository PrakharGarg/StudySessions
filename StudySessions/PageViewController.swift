//
//  HomeScreenViewController.swift
//  StudySessions
//
//  Created by Prakhar Garg on 10/18/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {

    // Create a variable to hold the page view controller
    private var pageViewController: UIPageViewController?
    // Store all of the image names
    let vcs = ["MyClassesScreen", "HomeScreen", "CreateStudySessionScreen"].map { UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: $0) }
    
    override func viewDidLayoutSubviews() {
        // MARK: Corrects scrollview frame to allow for full-screen view controller pages
        for subview in view.subviews {
            if subview is UIScrollView {
                subview.frame = self.view.bounds
            }
        }
        super.viewDidLayoutSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the data source of the current page
        dataSource = self
        // Set the page indicator buttons
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.backgroundColor = .white
        // Set background color to white
        view.backgroundColor = .white
        
        let firstViewController = vcs[1]
        
        setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // What to do when the user swipes backward
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let index = vcs.index(of: viewController)!
        if index == 0 {
            return nil
        }
        return vcs[ index - 1 ]
    }
    // What to do when the user swipes forward
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let index = vcs.index(of: viewController)!
        if index == 2 {
            return nil
        }
        return vcs[index + 1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return vcs.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first, let firstViewControllerIndex = vcs.index(of: firstViewController) else {
            return 0
        }
        return firstViewControllerIndex

    }
}
