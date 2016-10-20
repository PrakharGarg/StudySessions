//
//  HomeScreenViewController.swift
//  StudySessions
//
//  Created by Prakhar Garg on 10/18/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    // Toggle to determine whether to see all sessions or just the ones you've joined
    // On = view ones you've joined
    @IBOutlet weak var toggleSessions: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Study Sessions"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Home"
        navigationItem.backBarButtonItem = backItem
    }
}
