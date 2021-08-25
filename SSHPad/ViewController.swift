//
//  ViewController.swift
//  SSHPad
//
//  Created by Tomas Martins on 25/08/21.
//

import UIKit
import NMSSH

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapButton(_ sender: Any) {
        var alert = UIAlertController(title: "Login", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Username"
        }
        alert.addTextField { textField in
            textField.placeholder = "IP address"
        }
        alert.addTextField { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { [weak alert] action in
            let session = NMSSHSession(host: (alert?.textFields![1].text)!, andUsername: (alert?.textFields![0].text)!)
            session.connect()
            if session.isConnected {
                session.authenticate(byPassword: (alert?.textFields![2].text)!)
                
                if session.isAuthorized {
                    print("Authorized!")
                }
            }
            
            var error: NSError?
            let response: String = session.channel.execute("osascript Documents/terminal.scpt", error: &error)
            print(response)
            session.disconnect()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    

}

