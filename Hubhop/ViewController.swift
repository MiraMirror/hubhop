//
//  ViewController.swift
//  Hubhop
//
//  Created by Xuan Yang on 9/27/15.
//  Copyright © 2015 MiraCode. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    //User already logged in
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }
    
    
    //User never logged in
    // log in with fb
    @IBAction func fbBtbPressed(sender: UIButton!) {
        
        print("pressed button")
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"]) { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) -> Void in
            
            
            if facebookError != nil {
                print("facebook login was not succesful, Error \(facebookError)")
                
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("suc login with fb. \(accessToken)")
                
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook",token: accessToken, withCompletionBlock: { error, authData in
                    
                    if error != nil {
                        print("login failed")
                    } else {
                        print("logged in! \(authData)")
                        
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                        
                        let user = ["provider": authData.provider!]
                        DataService.ds.createFirebaseUser(authData.uid, user: user)
                        
                    }
                })
            }
            
            
        }

    }
    
    
    @IBAction func attemptLoggin(Sender: UIButton!) {
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            
            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
                
                if error != nil {
                    
                    if error.code == STATUS_ACCOUNT_NONEXIST {
                        
                        DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { error, result in
                            if error != nil {
                                self.showErrorAlert("Could not create account", msg: "Try facebook login")
                            } else {
                                
                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                                
                                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: {err, authData in
                                    let user = ["provider": authData.provider!]
                                    DataService.ds.createFirebaseUser(authData.uid, user: user)
                                    
                                    print("\(authData.uid)")
                                })
                                
                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                                
                                
                            }
                        })
                    } else {
                        self.showErrorAlert("Could not log in", msg: "Please check your email or password!")
                    }
                } else {
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
                
            })
            
        }else{
            showErrorAlert("Email and Password required", msg: "You must provide email and password")
        }
        
    }
    
    
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
        
    }

}

