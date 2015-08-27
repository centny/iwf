//
//  ViewController.swift
//  iwf-test
//
//  Created by Centny on 8/25/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

import UIKit
import iwf

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        L().D("debug info->%@", "ssxx");
        FPis.new();
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
//        InitDocWriter()
        // Dispose of any resources that can be recreated.
    }


}

