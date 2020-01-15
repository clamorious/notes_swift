//
//  LoginInteractor.swift
//  notes
//
//  Created by Douglas Gelsleichter on 10/11/19.
//  Copyright © 2019 Douglas Gelsleichter. All rights reserved.
//

import Foundation

class LoginInteractor {
    
    
    static func login(with username:String?, and password:String?, completationHandler: @escaping (String?) -> Void) {
          
        let Url = String(format: Const.mainUrl + "/login")
        guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary = ["username" : username, "password" : password]
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let token = json?["token"] as? String {
                        completationHandler(token)
                    }
                } catch {
                    print(error)
                    completationHandler(nil)
                }
            }
            }.resume()
    }
}
