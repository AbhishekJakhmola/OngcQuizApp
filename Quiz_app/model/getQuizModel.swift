//
//  getQuizModel.swift
//  Quiz_app
//
//  Created by Cynoteck6 on 3/16/21.
//  Copyright © 2021 Cynoteck6. All rights reserved.
//

import Foundation

struct getQuiz:Codable {
    struct data:Codable {
        let quiz    :String?
        let quiz_id :String?
    }

    let success :Bool?
    let data    :data
}


