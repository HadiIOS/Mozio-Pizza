//
//  MozioAlert.swift
//  Mozio Pizza
//
//  Created by Mac on 19/03/2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class MozioAlert: UIViewController {

    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var alertDescLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    private var alertTitle: String = ""
    private var alertText: String = ""
    private var acceptTitle: String = ""
    private var cancelTitle: String = ""
    private var acceptAction: (() -> Void)?
    private var cancelAction: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.alertLabel.text = alertTitle
        self.alertDescLabel.text = alertText
        self.acceptButton.setTitle(acceptTitle, for: .normal)
        self.cancelButton.setTitle(cancelTitle, for: .normal)
        // Do any additional setup after loading the view.
    }

    
    @IBAction func acceptAction(_ sender: Any) {
        self.dismiss(animated: true, completion: acceptAction)
    }
    
    @IBAction func cancelAcction(_ sender: Any) {
        self.dismiss(animated: true, completion: cancelAction)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    static func getViewController(_ title: String, text: String, acceptTitle: String, cancelTitle: String, acceptAction: @escaping (() -> Void), cancelAction: @escaping (() -> Void)) -> MozioAlert {
        let vc = MozioAlert(nibName: "MozioAlert", bundle: nil)
        vc.alertTitle = title
        vc.alertText = text
        vc.acceptTitle = acceptTitle
        vc.cancelTitle = cancelTitle
        vc.acceptAction = acceptAction
        vc.cancelAction = cancelAction
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
}
