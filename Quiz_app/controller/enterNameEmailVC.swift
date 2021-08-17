//
//  enterNameEmailVC.swift
//  Quiz_app
//
//  Created by Cynoteck6 on 3/18/21.
//  Copyright © 2021 Cynoteck6. All rights reserved.
//

import UIKit
import ACProgressHUD_Swift

class enterNameEmailVC: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    var quizID:String = ""
    var playID:String = ""
    var auID:String = ""
    let networkingObj = networking()
    let apiObj = APIs()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor :UIColor.white])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor :UIColor.white])
        navigationController?.setNavigationBarHidden(true , animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ACProgressHUD.shared.hideHUD()
    }

    @IBAction func submitBtn(_ sender: Any) {
        ACProgressHUD.shared.showHUD()
        let validateObject = validateWidgets()
        
        let name:String = nameTextField.text!
        if !validateObject.checkName(name: name) {
            ACProgressHUD.shared.hideHUD()
            showAlert(alertMessage: "Your name is not appropriate.")
        }
        
        let email:String = emailTextField.text!
        if !validateObject.checkEmail(email: email) {
            ACProgressHUD.shared.hideHUD()
            showAlert(alertMessage: "Your email is not appropriate.")
        }
        
        if validateObject.checkName(name: name) && validateObject.checkEmail(email: email){
            let postDictForJoinApi: [String:String] = [ "quiz_id": quizID , "name": name, "email": email ]
            let urlString = "\(APIs.baseUrl)join"
            let apiString = "join"
            networkingObj.post(urlString:urlString, apiString:apiString ,postDict: postDictForJoinApi, completionHandler:{
                data,isError in

                DispatchQueue.main.async {
                    if isError {
                        self.showAlert(alertMessage: "Cannot proceed futher due to some issues.")
                    } else {

                        let response:joinResponse = self.networkingObj.parse(json: data)
                        if response.success! {
                            self.playID = String(response.data.play_id!)
                            self.auID = String(response.data.au_id!)
                            self.callToPerformSegue()
                        }
                        else{
                            self.showAlert(alertMessage: "Cannot proceed futher due to some issues.")
                        }
                    }
                }
            } )
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is hitTimerVC {
        let hitTimerVCObj = segue.destination as? hitTimerVC
            hitTimerVCObj?.name = nameTextField.text!
            hitTimerVCObj?.playID = self.playID
            hitTimerVCObj?.quizID  = self.quizID
            hitTimerVCObj?.auID  = self.auID
        }
    }

    func callToPerformSegue(){
        self.performSegue(withIdentifier: "segueForHitTimerVC", sender: self)
    }
    
    func showAlert(alertMessage:String){
        let alert = UIAlertController(title: alertMessage, message: "",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
