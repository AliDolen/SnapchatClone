
import UIKit
import Firebase


class SignInVC: UIViewController {
    
    
    @IBOutlet var emailText: UITextField!
    
    @IBOutlet var usernameText: UITextField!
    
    @IBOutlet var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }


    @IBAction func signInClicked(_ sender: Any) {
        if  emailText.text != "" && passwordText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (result, error) in
                
                if error != nil {
                    
                    self.alertFunction(titleinput: "ERROR!", messageinput: error?.localizedDescription ?? "ERROR!")
                    
                    
                } else {
                    
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    
                    
                }
                
            }
            
            
        } else{
            
            self.alertFunction(titleinput: "ERROR!", messageinput: "username / password / email !")
            
            
        }
        
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if usernameText.text != "" && emailText.text != "" && passwordText.text != "" {
           
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (auth, error) in
                if error != nil {
                    
                    self.alertFunction(titleinput: "ERROR!", messageinput: error?.localizedDescription ?? "Error")
                    
                    
                } else{
                    
                    let firestore = Firestore.firestore()
                    
                    let userDictionary = ["username" : self.usernameText.text! , "email" : self.emailText.text! ] as [String : Any]
                    
                    
                    firestore.collection("info").addDocument(data: userDictionary) { (error) in
                        if error != nil {
                            
                            
                            self.alertFunction(titleinput: "ERROR!", messageinput: error?.localizedDescription ?? "Error!")
                            
                            
                        }
                        
                    
                    }
                    
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    
                    
                }
                
            }
            
        }
        else {
           
            self.alertFunction(titleinput: "ERROR!", messageinput: "USERNAME / PASSWORD / EMAİL !")
            
            
            
        }
        
        
    }
    
    func alertFunction(titleinput : String , messageinput : String){
        
        let alert = UIAlertController(title: titleinput, message: messageinput, preferredStyle: UIAlertController.Style.alert)
        
        let alertButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(alertButton)
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
}

