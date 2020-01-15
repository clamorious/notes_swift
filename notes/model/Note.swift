//
//  Note.swift
//  notes
//
//  Created by Douglas Gelsleichter on 14/01/20.
//  Copyright © 2020 Douglas Gelsleichter. All rights reserved.
//

import Foundation

class Note {
    lazy var id: Int = 0
    lazy var text: String? = ""
    lazy var datetime: String? = ""
    
    required init?(_ json: [String : Any]?) {
        guard let id = json?["id"] as? Int else {
            return nil
        }
        
        self.id = id
        
        guard let text = json?["text"] as? String else {
            return nil
        }
        
        self.text = text
        self.datetime = json?["datetime"] as? String
    }
}

