

import UIKit
import Firebase


class UploadVC: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        imageView.isUserInteractionEnabled = true
       
        
        let gesturerecognizer = UITapGestureRecognizer(target: self, action: #selector(imageClicked))
        imageView.addGestureRecognizer(gesturerecognizer)
        
        
        
        
    }
    
    @objc func imageClicked (){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.isEditing = true
        
        self.present(picker, animated: true, completion: nil)
        
        
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as! UIImage
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    @IBAction func uploadClicked(_ sender: Any) {
        
        
        
             //STORAGE
        
        let storage = Storage.storage()
        
        let referance = storage.reference()
        
        
        let mediafolder = referance.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imagereferance = mediafolder.child("\(uuid).jpg")
            
            imagereferance.putData(data, metadata: nil) { (storagedata, error) in
            
                if error != nil {
                    
                    
                    self.alertFunction(titleinput: "ERROR!", messageinput: error?.localizedDescription ?? "ERROR!")
                    
                    
                    
                } else {
                    
                    imagereferance.downloadURL { (url, error) in
                        
                        if error != nil {
                            
                            self.alertFunction(titleinput: "ERROR!", messageinput: error?.localizedDescription ?? "ERROR!")
                            
                            
                        } else {
                            
                            let imageURL = url?.absoluteString
                            
                            
                                // FİRESTORE DATABASE
                            
                            let firestore = Firestore.firestore()
                            
                            
                            firestore.collection("Snaps").whereField("snapsOwner", isEqualTo: userSingleton.shareduserinfo.username).getDocuments { (snapshot, error) in
                                if error != nil {
                                    
                                    self.alertFunction(titleinput: "ERROR!", messageinput: error?.localizedDescription ?? "ERROR!")
                                    
                                    
                                } else {
                                    
                                    if snapshot?.isEmpty == false && snapshot != nil {
                                        
                                        
                                        for document in snapshot!.documents {
                                            
                                            let documentid = document.documentID
                                            
                                            if var imageURLArray = document.get("imageURLArray") as? [String] {
                                                
                                                imageURLArray.append(imageURL!)
                                             
                                                let additionalDictionary = ["imageURLArray" : imageURLArray] as [String : Any]
                                                firestore.collection("Snaps").document(documentid).setData(additionalDictionary, merge: true) { (error) in
                                                    
                                                    if error != nil {
                                                        
                                                        self.alertFunction(titleinput: "ERROR!", messageinput: error?.localizedDescription ?? "ERROR!")
                                                        
                                                    } else {
                                                        
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.imageView.image = UIImage(named: "upload")
                                                    
                                                        
                                                    }
                                                    
                                                    
                                                }
                                                
                                            }
                                        
                                        }
                                        
                                    } else {
                                    let snapDictionary = ["imageURLArray" : [imageURL!] , "snapsOwner" : userSingleton.shareduserinfo.username , "date" : FieldValue.serverTimestamp()] as [String : Any]
                                                                  
                                    
                                    firestore.collection("Snaps").addDocument(data: snapDictionary) { (error) in
                                                if error != nil {
                                                                          
                                        self.alertFunction(titleinput: "ERROR!", messageinput: error?.localizedDescription ??  "ERROR!" )
                                                                          
                                                                          
                                        } else {
                                                                          
                                  self.tabBarController?.selectedIndex = 0
                                    self.imageView.image = UIImage(named: "upload")
                                                                      
                                                                          
                               }
                                                                      
                                     }
                                        
                                    }
                                    
                                }
                                
                            }
                            
                            
                            
                        }
                        
                    }
                    
                }
                
                
            }
            
            
            
        }
        
    }
    
    func alertFunction (titleinput: String , messageinput : String){
         
               let alert = UIAlertController(title: titleinput, message: messageinput, preferredStyle: UIAlertController.Style.alert)
               
               let alertButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
               
               alert.addAction(alertButton)
               
               self.present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
}
