//
//  ViewController.swift
//  Quiz_app
//
//  Created by Cynoteck6 on 3/15/21.
//  Copyright © 2021 Cynoteck6. All rights reserved.
//

import UIKit
import ACProgressHUD_Swift

class firstVC: UIViewController {
    
    let urlString = "\(APIs.baseUrl)getQuiz"
    let apiString = "getQuiz"
    var quizID:String = ""
    let networkingObj = networking()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true , animated: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        ACProgressHUD.shared.hideHUD()
    }
    
    @IBAction func start(_ sender: Any) {
        ACProgressHUD.shared.showHUD()
        networkingObj.get(urlString:urlString,completionHandler:{
            data , isError in
            DispatchQueue.main.async {
                if isError {
                    self.showAlert(alertMessage: "Cannot proceed futher due to some issues.")
                } else {
                    let response:getQuiz = self.networkingObj.parse(json: data)
                    self.quizID = response.data.quiz_id!
                    self.callToPerformSegue()
                }
            }
        } )
    }
    
    func callToPerformSegue(){
        self.performSegue(withIdentifier: "segueOfEnterNameEmailVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is enterNameEmailVC {
            let enterNameEmailVCObj = (segue.destination as? enterNameEmailVC)!
            enterNameEmailVCObj.quizID = self.quizID
        }
    }
    
    func showAlert(alertMessage:String){
        let alert = UIAlertController(title: alertMessage, message: "",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


