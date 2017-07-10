//
//  ListViewController.swift
//  NetworkAddressCalculator
//
//  Created by  on 10/25/16.
//  Copyright © 2016 UHCL. All rights reserved.
//

import UIKit

class AddressTableViewController: UITableViewController {
    
    var firstAdd = Array<Int>()
    var lastAdd = Array<UInt8>()
    
    var addClass = AddressListModel()
    var addresses = Array<String>()
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1 //one section
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "IP Addresses In the Network"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let addIdentifier = "AddressCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(addIdentifier, forIndexPath: indexPath)
        let address = addresses[indexPath.row]   //at(indexPath.row)
        
        cell.textLabel!.text = address
        cell.textLabel!.textColor = UIColor.brownColor()
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier{
            switch id{
            case "AddressDetail":
                if let addressDVC = segue.destinationViewController as? AddressDetailViewController { // refering to the new controller named AddressDetailViewController
                    let selectedRow = self.tableView.indexPathForSelectedRow?.row
                    let add = addresses[selectedRow!]
                    addressDVC.address = add
                    addressDVC.addClass = addClass.findClass(add)
                }
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        addresses = addClass.addressList(firstAdd, lastAd: lastAdd)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
