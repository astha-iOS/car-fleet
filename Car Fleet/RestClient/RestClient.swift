//
//  RestClient.swift
//  Car Fleet
//
//  Created by Astha yadav on 23/01/21.
//

import UIKit
import os
import SystemConfiguration

protocol ServicesDelegate {
    func success(result: Any ,withID: String)
    func error(result: Any,withID: String)
}

class RestClient {
    static let instance = RestClient()
    
    private init() {
        os_log("Creating Singlton object. Should be called once", log: .default, type: .debug)
        
    }
    
    class func shared() -> RestClient{
        return instance
    }
    
    //MARK:- getManufacturerList
    func getManufacturerList(pageNo:Int,pageSize:Int, delegate:ServicesDelegate){
        
        let url = String(format: "%@/v1/car-types/manufacturer?page=%d&pageSize=%d&wa_key=%@",AppConstants.BASE_URL,pageNo,pageSize,AppConstants.WAY_KEY)
        os_log("Calling api to get manufacturers : %@", log: .default, type: .debug, url)
        getResponseAndCallbackServiceDelegate(url,"manufacturer", delegate: delegate)
    }
  
    //MARK:- getModelList
    func getModelList(pageNo:Int,pageSize:Int,manufacturer:String, delegate:ServicesDelegate){
        
        let url = String(format: "%@/v1/car-types/main-types?manufacturer=%@&page=%d&pageSize=%d&wa_key=%@",AppConstants.BASE_URL,manufacturer,pageNo,pageSize,AppConstants.WAY_KEY)
        os_log("Calling api to get model : %@", log: .default, type: .debug, url)
        getResponseAndCallbackServiceDelegate(url,"carModel", delegate: delegate)
    }
    
    //MARK:- getManufacturerList
    fileprivate func getResponseAndCallbackServiceDelegate(_ url: String, _ withId:String, delegate:ServicesDelegate) {
        
        if !Reachability.isConnectedToNetwork(){
            os_log("Internet Connection not Available!", log: .default, type: .debug)
            delegate.error(result: "Internet Connection not Available!", withID: withId)
        }else{
            let nsUrl = NSURL(string: url)
            URLSession.shared.dataTask(with: nsUrl! as URL, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    os_log("Failed to get response from api: %@ \nCause by: %@ ", log: .default, type: .error, url, String(describing: error))
                    return
                }
                do{
                    let response = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    
                    delegate.success(result: response as NSDictionary, withID: withId)
                    
                }catch let error as NSError{
                    os_log("Failed to parse response from api: %@ \n Cause by: %@ ", log: .default, type: .error, url, String(describing: error))
                    delegate.error(result: error.localizedDescription, withID: withId)
                }
                
            }).resume()
        }
        
        
    }
    
}

public class Reachability {

    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret

    }
}
