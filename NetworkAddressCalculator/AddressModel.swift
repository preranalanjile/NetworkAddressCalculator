//
//  AddressModel.swift
//  NetworkAddressCalculator
//
//  Created by  on 10/25/16.
//  Copyright © 2016 UHCL. All rights reserved.
//

import Foundation

class AddressModel {
    
    var ipAddress : String
    
    init(){
        ipAddress = ""
    }
    
    init(ipAddress : String){
        self.ipAddress = ipAddress
    }
    
    func IPAddressID() -> String{
        return ipAddress
    }
    
    
}