//
//  networking.swift
//  Quiz_app
//
//  Created by Cynoteck6 on 3/16/21.
//  Copyright © 2021 Cynoteck6. All rights reserved.
//

import Foundation
class networking {
    
    
    func get(urlString: String,completionHandler: @escaping (Data,Bool) -> Void){
        if let url = URL(string: urlString) {
            do{
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "GET"
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                let task = URLSession.shared.dataTask(with: urlRequest) { (data , response , error) -> Void in
                    if error != nil {
                        completionHandler(data!,true)
                    }
                    else if error == nil {
                        completionHandler(data!,false)
                    }
                }
                task.resume()
            }
        }
    }
    
    
    func post(urlString: String,apiString: String ,postDict:[String:String],completionHandler: @escaping (Data,Bool) -> Void){
        let jsonDataToPost = try! JSONSerialization.data(withJSONObject: postDict)
        if let url = URL(string: urlString) {
            do{
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "POST"
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = jsonDataToPost
                let task = URLSession.shared.dataTask(with: urlRequest) { (data , response , error) -> Void in
                    switch apiString {
                    case "join":
                        if error != nil {
                            completionHandler(data!,true)
                        }
                        else if error == nil {
                            completionHandler(data!,false)
                        }
                    case "connectedUser":
                        if error != nil {
                            completionHandler(data!,true)
                        }
                        else if error == nil {
                            completionHandler(data!,false)
                        }
                    case "getQuestions":
                        if error != nil {
                            completionHandler(data!,true)
                        }
                        else if error == nil {
                            completionHandler(data!,false)
                        }
                    case "startQuiz":
                        if error != nil {
                            completionHandler(data!,true)
                        }
                        else if error == nil {
                            completionHandler(data!,false)
                        }
                    case "saveAnswer":
                        if error != nil {
                            completionHandler(data!,true)
                        }
                        else if error == nil {
                            completionHandler(data!,false)
                        }
                    default:
                        print("No such api exists.")
                    }
                }
                task.resume()
            }
        }
    }
    
    
    func parse<T:Decodable>(json: Data) -> T {
        let decoder = JSONDecoder()
        guard let jsonResponse = try? decoder.decode(T.self, from: json) else {
            fatalError("Something went wrong.")
        }

        return jsonResponse
    }
}
