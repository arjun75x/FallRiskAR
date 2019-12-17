//
//  StartViewController.swift
//  FallRiskAR
//
//  Created by Arjun Arun on 12/1/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func scanButton(_ sender: Any) {
        performSegue(withIdentifier: "segueOne", sender: self)
    }
    @IBAction func listButton(_ sender: Any) {
        performSegue(withIdentifier: "segueTwo", sender: self)
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
