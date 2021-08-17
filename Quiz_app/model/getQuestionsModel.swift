//
//  getQuestionsModel.swift
//  Quiz_app
//
//  Created by Cynoteck6 on 3/25/21.
//  Copyright © 2021 Cynoteck6. All rights reserved.
//

import Foundation

struct getQuestionsResponse:Codable {
    let success: Bool?
    let data: data
    
    struct data:Codable {
        let quiz:      String?
        let quiz_id:   String?
        let questions: [questions]
        
        struct questions:Codable {
            let ques_id: String?
            let question:String?
            let imageurl:String?
            let timer:   String?
            let answers: [answers]
            
            struct answers:Codable {
                let opt: String?
                let ans: Bool?
            }
        }

    }
}




    
