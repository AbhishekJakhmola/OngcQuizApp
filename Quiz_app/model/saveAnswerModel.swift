//
//  saveAnswerModel.swift
//  Quiz_app
//
//  Created by Cynoteck6 on 3/25/21.
//  Copyright © 2021 Cynoteck6. All rights reserved.
//

import Foundation

struct saveAnswerResponse:Codable {
    let success: Bool?
    let data: data
    
    struct data:Codable {
        let answe_id: Int?
        let msg:      String?
    }
}
