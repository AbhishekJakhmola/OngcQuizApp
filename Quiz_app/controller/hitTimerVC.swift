//
//  hitTimerVC.swift
//  Quiz_app
//
//  Created by Cynoteck6 on 4/1/21.
//  Copyright © 2021 Cynoteck6. All rights reserved.
//

import UIKit
import ACProgressHUD_Swift

class hitTimerVC: UIViewController {
    
    @IBOutlet var hitTimerLabel: UILabel!
    @IBOutlet var hitTimerLabel2: UILabel!
    @IBOutlet var startQuizBtn: UIButton!
    
    let urlString:String = "\(APIs.baseUrl)connectedUser"
    let apiString = "connectedUser"
    let urlString2:String = "\(APIs.baseUrl)startQuiz"
    let apiString2 = "startQuiz"
    var quizID:String = ""
    var playID:String = ""
    var auID:String = ""
    var name:String = ""
    let networkingObj = networking()

    override func viewDidLoad() {
        super.viewDidLoad()
        startQuizBtn.isHidden = true
        hitTimerLabel.text = "\(name) is connected."
        hitTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ACProgressHUD.shared.showHUD()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ACProgressHUD.shared.hideHUD()
    }
    
    func startQuiz(){
        let body: [String:String] = [ "play_id": self.playID, "is_quiz_start": "true"]
        self.networkingObj.post(urlString: self.urlString2, apiString: self.apiString2, postDict: body, completionHandler: {
            data ,isError  in
            DispatchQueue.main.async{
                if isError {
                    self.showAlert(alertMessage: "Cannot proceed futher due to some issues.")
                } else {
                    let response:startQuizResponse = self.networkingObj.parse(json: data)
                    if response.success! {
                        self.performSegue(withIdentifier: "segueOfQuizPageVC", sender: self)
                    }
                    else {
                        self.showAlert(alertMessage: "Cannot start quiz due to some issues.")
                    }
                }
            }
        })
    }
    
    
    func hitTimer(){
        let body: [String:String] = [ "play_id": String(self.playID) ]
        self.networkingObj.post(urlString: self.urlString, apiString: self.apiString, postDict: body, completionHandler: {
            data ,isError  in
            DispatchQueue.main.async{
                if isError {
                    self.showAlert(alertMessage: "Cannot proceed futher due to some issues.")
                } else {
                    let response:connectedUserResponse = self.networkingObj.parse(json: data)
                    let joined = (response.data.joined! as NSString).integerValue
                    let min_user = (response.data.min_user! as NSString).integerValue
                    if joined >=  min_user {
                        ACProgressHUD.shared.hideHUD()
                        self.hitTimerLabel2.text = "Total number of user joined the quiz is greater than or equal to the minimum requirement."
                        self.startQuizBtn.isHidden = false
                    }
                    else {
                        self.hitTimerLabel2.text = "Total number of user joined the quiz is not greater than or equal to the minimum requirement."
                        sleep(3)
                        self.hitTimer()
                    }
                }
            }
        })
    }
    
    func showAlert(alertMessage:String){
        let alert = UIAlertController(title: "Warning!", message: alertMessage ,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func startQuizBtn(_ sender: Any) {
        ACProgressHUD.shared.showHUD()
        self.startQuiz()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is quizPageVC {
        let quizPageVCObj = segue.destination as? quizPageVC
            quizPageVCObj?.quizID = quizID
            quizPageVCObj?.playID = playID
            quizPageVCObj?.auID = auID
        }
    }
}
