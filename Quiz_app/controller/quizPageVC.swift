//
//  quizPageVC.swift
//  Quiz_app
//
//  Created by Cynoteck6 on 3/25/21.
//  Copyright © 2021 Cynoteck6. All rights reserved.
//

import UIKit
import ACProgressHUD_Swift

class quizPageVC: UIViewController {

    let urlString = "\(APIs.baseUrl)getQuestions"
    let apiString = "getQuestions"
    let urlString2 = "\(APIs.baseUrl)saveAnswer"
    let apiString2 = "saveAnswer"
    let networkingObj = networking()
    
    var quesID:String = ""
    var auID:String = ""
    var playID:String = ""
    var quizID:String = ""
    var endIndexOfQuestions:Int = 0
    var selectedOption:String = ""
    var selectedAnswer:Bool = false
    
    var questions = [String]()
    var questionIDs = [String]()
    var imageURLs = [String]()
    var optionAs = [String]()
    var optionBs = [String]()
    var optionCs = [String]()
    var optionDs = [String]()
    var answerAs = [Bool]()
    var answerBs = [Bool]()
    var answerCs = [Bool]()
    var answerDs = [Bool]()
    
    var submitted = [Bool]()
    
    var i:Int = 0
    var timer: Timer?
    
    @IBOutlet var questionsLabel: UILabel!
    @IBOutlet var imageLabel: UIImageView!
    
    
    @IBOutlet var option1: UIButton!
    @IBOutlet var option2: UIButton!
    @IBOutlet var option3: UIButton!
    @IBOutlet var option4: UIButton!
    @IBOutlet var saveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageLabel.isHidden = true
        loadQuestions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ACProgressHUD.shared.showHUD()
    }
    
    func loadQuestions(){
        let postDict: [String:String] = [ "quiz_id": quizID ]
        networkingObj.post(urlString:urlString, apiString:apiString ,postDict: postDict, completionHandler:{
            data,isError in
            if isError {
                self.showAlert(alertMessage: "Cannot proceed futher due to some issues.")
            } else {
                if let response:getQuestionsResponse = self.networkingObj.parse(json: data) {
                    DispatchQueue.main.async{
                        self.showDataInView(response: response)
                    }
                }
            }
        } )
    }
    
    
    func showDataInView(response:getQuestionsResponse)  {
        self.endIndexOfQuestions = response.data.questions.endIndex
        for index in response.data.questions {
            self.questions.append(index.question!)
            self.questionIDs.append(index.ques_id!)
            self.imageURLs.append(index.imageurl!)
            self.optionAs.append(index.answers[index.answers.startIndex].opt!)
            self.optionBs.append(index.answers[index.answers.startIndex + 1].opt!)
            self.optionCs.append(index.answers[index.answers.startIndex + 2].opt!)
            self.optionDs.append(index.answers[index.answers.startIndex + 3].opt!)
            self.answerAs.append(index.answers[index.answers.startIndex].ans!)
            self.answerBs.append(index.answers[index.answers.startIndex + 1].ans!)
            self.answerCs.append(index.answers[index.answers.startIndex + 2].ans!)
            self.answerDs.append(index.answers[index.answers.startIndex + 3].ans!)
            self.submitted.append(false)
        }
        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(fillTheView), userInfo: nil, repeats: true)
    }
    
    @objc func fillTheView() {
        if self.i != 0 && !self.submitted[self.i - 1] {
            submitBlankAnswers(quesIDToBeSubmittedBlank: self.questionIDs[self.i - 1])
        }
        if self.i == self.endIndexOfQuestions {
            self.showAlert(alertMessage: "Thanks for taking the quiz.")
            timer?.invalidate()
        }
        else {
            self.questionsLabel.text = self.questions[self.i]
            if self.imageURLs[self.i] != "" {
                self.imageLabel.isHidden = false
                let imageUrlString = URL(string: self.imageURLs[self.i])!
                if let data = try? Data(contentsOf: imageUrlString) {
                    self.imageLabel.image = UIImage(data: data)
                }
            }
            else{
                self.imageLabel.isHidden = true
            }
            self.option1.setTitle(self.optionAs[self.i], for: .normal)
            self.option2.setTitle(self.optionBs[self.i], for: .normal)
            self.option3.setTitle(self.optionCs[self.i], for: .normal)
            self.option4.setTitle(self.optionDs[self.i], for: .normal)
            self.saveBtn.isEnabled = false
            self.quesID = self.questionIDs[self.i]
            
        }
        if self.i == 0 {
            ACProgressHUD.shared.hideHUD()
        }
        self.i += 1
    }
    
    func submitBlankAnswers(quesIDToBeSubmittedBlank:String){
        print("*******************")
        print("Blank ***********")
        print("Question \(self.i - 1)")
        print("*******************")
        let postDict: [String:String] = [ "play_id": self.playID , "au_id": self.auID, "ques_id": quesIDToBeSubmittedBlank, "selected_option": "" , "answer": "" , "play_status": "false"]
        networkingObj.post(urlString:urlString2, apiString:apiString2 ,postDict: postDict, completionHandler:{
            data,isError in
            if isError {
                self.showAlert(alertMessage: "Cannot save answer due to some issue.")
            }else {
                if let response:saveAnswerResponse = self.networkingObj.parse(json: data) {
                    if !response.success! {
                        self.showAlert(alertMessage: "Cannot save answer due to some issue.")
                    }
                }
            }
        } )
    }
    
    func submitAnswers(){
        print("*******************")
        print("Question \(self.i)")
        print("submitted")
        print(self.selectedAnswer)
        print(self.selectedOption)
        print("*******************")
        let postDict: [String:String] = [ "play_id": self.playID , "au_id": self.auID, "ques_id": self.quesID, "selected_option": self.selectedOption , "answer": String(self.selectedAnswer) , "play_status": "false"]
        networkingObj.post(urlString:urlString2, apiString:apiString2 ,postDict: postDict, completionHandler:{
            data,isError in
            if isError {
                self.showAlert(alertMessage: "Cannot save answer due to some issue.")
            }else {
                if let response:saveAnswerResponse = self.networkingObj.parse(json: data) {
                    if !response.success! {
                        self.showAlert(alertMessage: "Cannot save answer due to some issue.")
                    }
                }
            }
        } )
        self.submitted[self.i - 1] = true
    }
    
    
    @IBAction func SaveBtn(_ sender: Any) {
        self.submitAnswers()
    }
    
    @IBAction func Option1(_ sender: Any) {
        self.selectedOption = self.optionAs[self.i]
        self.selectedAnswer = self.answerAs[self.i]
        self.saveBtn.isEnabled = true
    }
    
    @IBAction func Option2(_ sender: Any) {
        self.selectedOption = self.optionBs[self.i]
        self.selectedAnswer = self.answerBs[self.i]
        self.saveBtn.isEnabled = true
    }
    
    @IBAction func Option3(_ sender: Any) {
        self.selectedOption = self.optionCs[self.i]
        self.selectedAnswer = self.answerCs[self.i]
        self.saveBtn.isEnabled = true
    }
    
    @IBAction func Option4(_ sender: Any) {
        self.selectedOption = self.optionDs[self.i]
        self.selectedAnswer = self.answerDs[self.i]
        self.saveBtn.isEnabled = true
    }
    
    func showAlert(alertMessage:String){
        let alert = UIAlertController(title: alertMessage, message: "",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { action in self.callToPerformSegue()}))
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is firstVC {
            _ = segue.destination as? firstVC
        }
    }

    func callToPerformSegue(){
        self.performSegue(withIdentifier: "segueToStartPageVC", sender: self)
    }
}
