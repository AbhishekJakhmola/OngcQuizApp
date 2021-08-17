//
//  connectedUserModel.swift
//  Quiz_app
//
//  Created by Cynoteck6 on 3/25/21.
//  Copyright © 2021 Cynoteck6. All rights reserved.
//

import Foundation


struct connectedUserResponse:Codable {
    let success: Bool?
    let data : data
    
    struct data:Codable {
        let joined: String?
        let min_user: String?
        let max_user: String?
        let timer: String?
    }
}
