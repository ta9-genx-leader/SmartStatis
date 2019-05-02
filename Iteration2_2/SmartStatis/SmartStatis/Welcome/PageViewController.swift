
//
//  PageViewController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/28.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
/*
    This class is to manage the views for the leading pages
 */
class PageViewController: UIPageViewController ,UIPageViewControllerDataSource,UIPageViewControllerDelegate{
    
    @IBOutlet weak var pageControl: UIPageControl!
    /*
        This method is to count the number of views needed for the leading pages.
     */
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }
    
    /*
        This method is to initiate the default index of view controller for the leading pages.
     */
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    /*
        This method is to determine what will be the view before the current view.
     */
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = subViewControllers.index(of: viewController) ?? 0
        if (currentIndex <= 0) {
            return nil
        }
         return subViewControllers[currentIndex - 1]
    }
    
    /*
        This method is to determine what will be the view after the current view.
     */
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = subViewControllers.index(of: viewController) ?? 0
        if currentIndex >= subViewControllers.count - 1 {
            return nil
        }
        return subViewControllers[currentIndex + 1]
    }
    
    // Determine the controller included in the leading pages.
    lazy var subViewControllers: [UIViewController] = {
        return [
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstPageController") as! FirstPageController,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondPageController") as! SecondPageController,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThirdPageController") as! ThirdPageController,UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForthPageController") as! ForthPageController
        ]
    }()
    
    /*
        This method is to mode of navigation for leading pages.
     */
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    /*
        This method is to initiate this view.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        setViewControllers([subViewControllers[0]], direction: .forward, animated: true, completion: nil)
    }
}
