//
//  NavigationViewController.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 23/10/2563 BE.
//

import UIKit

class NavigationViewController: UINavigationController {

    let button = UIBarButtonItem(title: "tet", style: .done, target: nil, action: nil)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "UITraitCollection"
        self.navigationBar.prefersLargeTitles = true
        self.setToolbarHidden(false, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
