//
//  SecondViewController.swift
//  ChartView
//
//  Created by 赛峰 施 on 2016/11/1.
//  Copyright © 2016年 赛峰 施. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBAction func btnPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showViewController", sender: self)

    }
}
