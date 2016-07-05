//
//  WebService.swift
//  NoughtsAndCrosses
//
//  Created by Julian Hulme on 2016/06/04.
//  Copyright © 2016 Julian Hulme. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class WebService {
    
    // Just like the postman app!
    
    //MARK:- Utility request creation methods
    func createMutableRequest(url:NSURL!,method:String!, parameters: [String: String]? = nil) -> Request  {
        
        // build request
        let headers = ["access-Token":UserController.sharedInstance.currentUser!.token, "client": UserController.sharedInstance.currentUser!.client, "uid":UserController.sharedInstance.currentUser!.email, "token-type":"bearer"]
        let request = Alamofire.request(Method(rawValue:method)!, url, parameters: parameters, encoding: .URL, headers: headers)
        
        return request
    }
    
    func createMutableAnonRequest(url:NSURL!,method:String!,parameters:Dictionary<String, String>?) -> Request  {
        
        
        // build request
        let request = Alamofire.request(.POST, url, parameters: parameters, encoding: .URL)
        
        return request
    }
    
    func executeRequest (urlRequest:Request, requestCompletionFunction:(Int,JSON) -> ())  {
        
        //add a loading overlay over the presenting view controller, as we are about to wait for a web request
        //presentingViewController?.addLoadingOverlay()
        
        urlRequest.responseJSON { returnedData -> Void in  //execute the request and give us JSON response data
            
            //the web service is now done. Remove the loading overlay
            //presentingViewController?.removeLoadingOverlay()
            
            //Handle the response from the web service
            let success = returnedData.result.isSuccess
            if (success) {
                
                var json = JSON(returnedData.result.value!)
                let serverResponseCode = returnedData.response!.statusCode //since the web service was a success, we know there is a .response value, so we can request the value gets unwrapped with .response!
                
                //                let headerData = returnedData.response?.allHeaderFields
                //                print ("token data \(headerData)")
                
                
                // Adding token and client to the JSON data, before we send it to the user controller
                if let validToken = returnedData.response!.allHeaderFields["Access-Token"] {
                    let tokenJson:JSON = JSON(validToken)
                    json["data"]["token"] = tokenJson
                }
                if let validClient = returnedData.response!.allHeaderFields["Client"] as? String    {
                    let clientJson:JSON = JSON(validClient)
                    json["data"]["client"] = clientJson
                }
                
                //execute the completion function specified by the class that called this executeRequest function
                //the
                requestCompletionFunction(serverResponseCode,json)
                
            }   else    {
                
                // if request could not be made
                requestCompletionFunction(0, JSON(""))
            }
        }
    }
    
    
    //used by the executeRequest function to show that the app experienced a connection error
    func connectionErrorAlert() -> UIAlertController {
        let alert = UIAlertController(title:"Connection Error", message:"Not connected", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        return alert
    }
    
    //used by the executeRequest function to show that the app experienced a backend server error
    func server500Alert() -> UIAlertController {
        let alert = UIAlertController(title:"Oh Dear", message:"There was an problem handling your request", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        return alert
    }
    
    //used by the executeRequest function to check if the app should show any common network errors in an alert
    //returns true if an error and the corresponding alert was activated, or false if no errors were found
    func handleCommonResponses(responseCode:Int, presentingViewController:UIViewController?) -> Bool {
        //handle session expiry
        if (responseCode == 302)   {
            
            //we are not going to experience this response, yet. This code will never execute
            return true
            
            
        }   else if (responseCode == 500)  {
            
            if let vc = presentingViewController   {
                
                let alert = server500Alert()
                vc.presentViewController(alert, animated: true, completion: nil)
                return true
            }
            
            
        }
        
        return false //returning false indicates that no errors were detected
    }
    
}