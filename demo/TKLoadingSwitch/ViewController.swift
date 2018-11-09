//
//  ViewController.swift
//  TKLoadingSwitch
//
//  Created by Tungkay on 2018/11/8.
//  Copyright © 2018年 Tungkay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func sucessAction(_ sender: TKLoadingSwitch) {
        sender.startLoading()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            sender.stopLoading()
        }
    }
    
    @IBAction func failedAction(_ sender: TKLoadingSwitch) {
        sender.startLoading()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            sender.stopLoading()
            sender.resumeState()
        }
    }
    
}

