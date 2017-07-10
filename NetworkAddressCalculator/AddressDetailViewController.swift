//
//  AddressDetailViewController.swift
//  NetworkAddressCalculator
//
//  Created by  on 10/29/16.
//  Copyright © 2016 UHCL. All rights reserved.
//

import UIKit

class AddressDetailViewController: UIViewController {

    
    @IBOutlet weak var usableIpAddress: UILabel!
    
    @IBOutlet weak var classOfAddress: UILabel!
    
    
    var address = ""
    var addClass = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usableIpAddress.text = address
        classOfAddress.text = addClass
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
