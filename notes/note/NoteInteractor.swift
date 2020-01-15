//
//  NoteInteractor.swift
//  notes
//
//  Created by Douglas Gelsleichter on 08/01/20.
//  Copyright © 2020 Douglas Gelsleichter. All rights reserved.
//

import Foundation


class NoteInteractor {
    
    static func fetchNotes (completationHandler: @escaping ([Note]?) -> Void){
        if let token = AppDelegate.token {
        let urlStr = Const.mainUrl + "/notes?token=" + token
            
            let Url = String(format: urlStr)
            guard let serviceUrl = URL(string: Url) else { return }
            
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "GET"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
           
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let response = response {
                    print(response)
                }
                if let data = data {
                    do {
                        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                        let notes = jsonArray?.compactMap { Note($0) }
                        completationHandler(notes)
                        print(jsonArray ?? "")
                    } catch {
                        print(error)
                        completationHandler(nil)
                    }
                }
                }.resume()
        }
    }
    
    static func update(_ id:Int, _ text:String?, completationHandler: @escaping (String?) -> Void) {
         if let token = AppDelegate.token {
             let urlStr = Const.mainUrl + "/notes/\(id)"
               
             let Url = String(format: urlStr)
             guard let serviceUrl = URL(string: Url) else { return }
             
             let parameterDictionary = ["token": token, "text": text ?? ""] as [String : Any]
             
             var request = URLRequest(url: serviceUrl)
             request.httpMethod = "PUT"
             request.setValue("Application/json", forHTTPHeaderField: "Content-Type")

             guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
                 return
             }
             
             request.httpBody = httpBody

             let session = URLSession.shared
             session.dataTask(with: request) { (data, response, error) in
             if let response = response {
                 print(response, "asda")
             }
                 
             if let response = response as? HTTPURLResponse, response.isResponseOK() {
                 
                 completationHandler("ok")
             } else {
                 completationHandler(nil)
             }
    
         }.resume()
             
         }
    }
    
    static func delete(_ id:Int, completationHandler: @escaping (String?) -> Void) {
         if let token = AppDelegate.token {
             let urlStr = Const.mainUrl + "/notes/\(id)?token=\(token)"
               
             let Url = String(format: urlStr)
             guard let serviceUrl = URL(string: Url) else { return }
             
                        
             var request = URLRequest(url: serviceUrl)
             request.httpMethod = "DELETE"
             request.setValue("Application/json", forHTTPHeaderField: "Content-Type")


             let session = URLSession.shared
             session.dataTask(with: request) { (data, response, error) in
             if let response = response {
                 print(response, "asda")
             }
                 
             if let response = response as? HTTPURLResponse, response.isResponseOK() {
                 
                 completationHandler("ok")
             } else {
                 completationHandler(nil)
             }
    
         }.resume()
             
         }
    }
    
    static func save(_ text:String?, completationHandler: @escaping (String?) -> Void) {
        if let token = AppDelegate.token {
            let urlStr = Const.mainUrl + "/notes"
              
            let Url = String(format: urlStr)
            guard let serviceUrl = URL(string: Url) else { return }
            let date = Date()
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

            let str = dateFormatterGet.string(from: date)
            let parameterDictionary = ["token": token, "datetime" : str, "text": text ?? ""] as [String : Any]
            
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
                print(response, "asda")
            }
                
            if let response = response as? HTTPURLResponse, response.isResponseOK() {
                
                completationHandler("ok")
            } else {
                completationHandler(nil)
            }
   
        }.resume()
            
        }
    }
}

extension HTTPURLResponse {
     func isResponseOK() -> Bool {
      return (200...299).contains(self.statusCode)
     }
}
