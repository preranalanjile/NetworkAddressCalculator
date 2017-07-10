//
//  AddressListModel.swift
//  NetworkAddressCalculator
//
//  Created by  on 10/25/16.
//  Copyright © 2016 UHCL. All rights reserved.
//

import Foundation

class AddressListModel {
    
    var addresses: Array<String>
    
    init(){
        addresses = Array<String>()
    }
    
    func getFirstLastIPAddress(elements : Array<String>, _ maskInt : Int) -> (firstAddress : Array<Int>, lastAddress : Array<UInt8>, maskEightBitElementsInInteger : Array<Int>) {
        var validAddressElements = [Int]()
        
        //Net Mask start
        var maskEightBitElements = [String]()
        let onesInMask = String(count: maskInt, repeatedValue: Character("1"))
        let onesInMaskComp = pad(onesInMask, toSize: 32)
        //let onesInMaskComp = String(format: "%032d", Int(onesInMask)!)
        let maskCharInArray = onesInMaskComp.characters.map { String($0) }
        
        maskEightBitElements.append(maskCharInArray[0...7].joinWithSeparator(""))
        maskEightBitElements.append(maskCharInArray[8...15].joinWithSeparator(""))
        maskEightBitElements.append(maskCharInArray[16...23].joinWithSeparator(""))
        maskEightBitElements.append(maskCharInArray[24...31].joinWithSeparator(""))
        
        var maskEightBitElementsInInteger = [Int]()
        
        //Convert Mask into decimal
        for ele in maskEightBitElements {
            maskEightBitElementsInInteger.append(Int(ele, radix: 2)!)
        }
        //Complement of mask start
        var compOfEleArray = [UInt8]()
        for i in maskEightBitElementsInInteger{
            compOfEleArray.append(~(UInt8(i)))
            
        }
        // complement of mask end
        
        //Net Mask End
        
        // MY address start
        var addEleArray = [UInt8]()
        for i in elements{
            validAddressElements.append(Int(i)!)
            addEleArray.append(UInt8(i)!)
        }
        //My address end
        
        
        var firstAddress = [Int]()
        var lastAddress = [UInt8]()
        
        //AND operation start, itererate 2 arrays
        for (eAdd, eMask) in zip(validAddressElements, maskEightBitElementsInInteger) {
            firstAddress.append(eAdd & eMask)
        }
        
        //OR operation start
        for (eAdd, eMask) in zip(addEleArray, compOfEleArray) {
            lastAddress.append(eAdd | eMask)
        }
        
        return(firstAddress, lastAddress, maskEightBitElementsInInteger)

    }
    
    //Get all addresses in array to display in table view
    func addressList(firstAd: Array<Int>, lastAd: Array<UInt8>) -> Array<String> {
        
        var addressList = [String]()
        var firstadr = firstAd
        let stringFirstAdd = firstAd.map
            { String($0) }
        addressList.append(stringFirstAdd.joinWithSeparator("."))
        
        let stringLastAdd = lastAd.map
            { Int($0) }
        var lastadr = stringLastAdd
        
        for _ in 0...lastadr[2]-firstadr[2]{
            if firstadr[2] != lastadr[2]{
                for _ in firstadr[3]..<255{
                    let newX = firstadr[3] + 1
                    firstadr.removeAtIndex(3)
                    firstadr.insert(newX, atIndex: 3)
                    let stringNew = firstadr.map
                        { String($0) }
                    let str = stringNew.joinWithSeparator(".")
                    addressList.append(str)
                }
                let new2 = firstadr[2] + 1
                firstadr.removeAtIndex(2)
                firstadr.insert(new2, atIndex: 2)
                firstadr.removeAtIndex(3)
                firstadr.insert(-1, atIndex: 3)
                
            }else{
                for _ in firstadr[3]..<lastadr[3]{
                    let newX = firstadr[3] + 1
                    firstadr.removeAtIndex(3)
                    firstadr.insert(newX, atIndex: 3)
                    let stringNew = firstadr.map
                        { String($0) }
                    let str = stringNew.joinWithSeparator(".")
                    addressList.append(str)
                }
            }
        }
        return addressList

    }
    
    // prepend 0 to subnet mask
    func pad(string: String, toSize: Int) -> String {
        var padded = string
        for _ in 0..<toSize - string.characters.count {
            padded =  padded + "0"
        }
        return padded
    }

    // Get the class of IP address
    func findClass(address : String) -> String {
        let fElement = Int(address.componentsSeparatedByString(".").first!)!
        var classOfAdd = ""
        switch fElement {
        case 1...127:
            classOfAdd = "A"
        case 128...191:
            classOfAdd = "B"
        case 192...223:
            classOfAdd = "C"
        case 224...239:
            classOfAdd = "D"
        case 240...255:
            classOfAdd = "E"
        default:
            break;
        }
        return classOfAdd
    }
    

}