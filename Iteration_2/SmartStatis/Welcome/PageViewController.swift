
//
//  PageViewController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/28.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController ,UIPageViewControllerDataSource,UIPageViewControllerDelegate{
    
    @IBOutlet weak var pageControl: UIPageControl!
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = subViewControllers.index(of: viewController) ?? 0
        if (currentIndex <= 0) {
            return nil
        }
         return subViewControllers[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = subViewControllers.index(of: viewController) ?? 0
        if currentIndex >= subViewControllers.count - 1 {
            return nil
        }
        return subViewControllers[currentIndex + 1]
    }
    
    lazy var subViewControllers: [UIViewController] = {
        return [
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstPageController") as! FirstPageController,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondPageController") as! SecondPageController,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThirdPageController") as! ThirdPageController,UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForthPageController") as! ForthPageController
        ]
    }()
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        setViewControllers([subViewControllers[0]], direction: .forward, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }
 

}
