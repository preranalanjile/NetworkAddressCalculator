//
//  ViewController.swift
//  NetworkAddressCalculator
//
//  Created by  on 10/25/16.
//  Copyright © 2016 UHCL. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var myAddress: UITextField!
    
    @IBOutlet weak var netmask: UITextField!
    
    var addresses = AddressListModel()
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        let inverseSet : NSCharacterSet
        if textField.tag == 1{
            inverseSet = NSCharacterSet(charactersInString:"0123456789.").invertedSet
        }else{
            inverseSet = NSCharacterSet(charactersInString:"0123456789").invertedSet
        }
        let components = string.componentsSeparatedByCharactersInSet(inverseSet)
        let filtered = components.joinWithSeparator("")
        return string == filtered
    }
    
    
    //Display IP addresses
    @IBAction func getAddressList(sender: UIButton) {
        myAddress.resignFirstResponder()
        netmask.resignFirstResponder()
        
        let myAdd = myAddress.text!
        if !netmask.text!.isEmpty{
            let elementsOfAddress = myAdd.componentsSeparatedByString(".")
            var invalidele = [String]()
            for i in elementsOfAddress{
                if i == ""{
                    invalidele.append(i)
                }
            }
            let maskInt = Int(netmask.text!)!

            if !myAdd.isEmpty && maskInt > 15 && maskInt < 33 && myAdd.rangeOfString(".") != nil && myAdd.componentsSeparatedByString(".").count == 4 && invalidele.isEmpty {
                let elements = myAdd.componentsSeparatedByString(".")
                var invalidElements = [Int]()
                if !elements.isEmpty{
                    for i in elements {
                        if Int(i) > 255 {
                            invalidElements.append(Int(i)!)
                        }
                    }
                }
                //logic
                if !elements.isEmpty && invalidElements.isEmpty {
                    let firstLastAdds = addresses.getFirstLastIPAddress(elements, maskInt)
                    
                    // Button "Calculate" action
                    if sender.tag == 1 {
                        // Display address in string format to make a join of integers in array
                        let stringFirstAdd = firstLastAdds.firstAddress.map
                            { String($0) }
                        let stringLastAdd = firstLastAdds.lastAddress.map
                            { String($0) }
                        let stringMaskAdd = firstLastAdds.maskEightBitElementsInInteger.map
                            { String($0) }
                        
                        let alertMsg = "First IP Address : \(stringFirstAdd.joinWithSeparator(".")), Last IP Address: \(stringLastAdd.joinWithSeparator(".")), Subnet Mask: \(stringMaskAdd.joinWithSeparator("."))"
                        
                        let alert = UIAlertController(title: "Result", message: alertMsg, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                        
                    // Button "Display List" action
                    else{
                        performSegueWithIdentifier("AddressListSegue", sender: self)
                    }

                }else{
                    let alert = UIAlertController(title: "Alert", message: "Please Enter valid IP Address and Netmask", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }else{
                let alert = UIAlertController(title: "Alert", message: "Please Enter valid IP Address and Netmask", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }else{
            let alert = UIAlertController(title: "Alert", message: "Please Enter valid IP Address and Netmask", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // To send first and last address to the function for calculating all addresses in the network
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let myAdd = myAddress.text!
        let maskInt = Int(netmask.text!)!
        let elements = myAdd.componentsSeparatedByString(".")
        let firstLastAdds = addresses.getFirstLastIPAddress(elements, maskInt)
        
        if let addressDVC = segue.destinationViewController as? AddressTableViewController {
            addressDVC.firstAdd = firstLastAdds.firstAddress
            addressDVC.lastAdd = firstLastAdds.lastAddress
        }
    }
    
    // From 3rd MVC
    @IBAction func modify(segue: UIStoryboardSegue){
        myAddress.becomeFirstResponder()
    }
    
    // From 3rd MVC
    @IBAction func enterNew(segue: UIStoryboardSegue){
        dismissViewControllerAnimated(true, completion: nil)
        myAddress.text = ""
        netmask.text = ""
        myAddress.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myAddress.becomeFirstResponder()
        
        myAddress.delegate = self
        netmask.delegate = self
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        myAddress.resignFirstResponder()
        netmask.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

