//
//  joinModel.swift
//  Quiz_app
//
//  Created by Cynoteck6 on 3/19/21.
//  Copyright © 2021 Cynoteck6. All rights reserved.
//

import Foundation

struct joinResponse: Codable {
    let success: Bool?
    let data: data
    
    struct data: Codable {
        let au_id: Int?
        let play_id: Int?
        let starter: Bool?

    }
}

class validateWidgets {
    func checkName(name:String) -> Bool{
        if((name.range(of: "^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$", options: .regularExpression, range: nil, locale: nil)) != nil){
            return true
        }
        else {
            return false
        }
    }

    func checkEmail(email:String) -> Bool{
        if((email.range(of: "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}", options: .regularExpression, range: nil, locale: nil)) != nil){
            return true
        }
        else {
            return false
        }
    }
}

