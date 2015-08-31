//
//  ViewController.swift
//  iwf-test
//
//  Created by Centny on 8/25/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

import UIKit
import iwf

class ViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        L().D("debug info->%@", "ssxx");
//        var root=NavRootVCtl.new();
//        var nav=UINavigationController(rootViewController: root)
//        nav.view.frame=CGRectMake(0, 0, 320, 460);
//        self.view .addSubview(nav.view)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
//        InitDocWriter()
        // Dispose of any resources that can be recreated.
    }


}

