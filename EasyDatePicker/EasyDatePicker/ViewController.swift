//
//  ViewController.swift
//  EasyDatePicker
//
//  Created by 李杰 on 2019/3/11.
//  Copyright © 2019 李杰. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let rect = CGRect(x: 40, y: 100, width: 200, height: 180)
        let datePicker = EasyDatePicker(frame: rect)
        view.addSubview(datePicker)
    }
}

