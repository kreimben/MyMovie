//
//  MainTabBarViewController.swift
//  MyMovie
//
//  Created by Aksidion Kreimben on 2023/06/13.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let movieDetailVC = MovieDetailViewController()
        
        if var VCs = self.viewControllers {
            VCs.append(movieDetailVC)
            self.setViewControllers(VCs, animated: true)
        } else {
            self.setViewControllers([movieDetailVC], animated: true)
        }
        
        guard let items = self.tabBar.items else { return }
        items[items.count - 1].title = "Detail"
        items[items.count - 1].image = UIImage(systemName: "circle.fill")
    }

}
