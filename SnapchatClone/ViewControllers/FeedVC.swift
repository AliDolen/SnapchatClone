

import UIKit
import Firebase
import SDWebImage

class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    let fireStoreDataBase = Firestore.firestore()
    
    var snapArray = [Snap]()
    
    
    var chosenSnap : Snap?
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        getSnapsFromFireBase()
        
        getUserinfo()
        
        
        
        
    }
    
    func getSnapsFromFireBase (){
        
        fireStoreDataBase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                
                self.alertFunction(titleinput: "ERROR!", messageinput: error?.localizedDescription ?? "ERROR!")
                
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                self.snapArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        
                        let documentid = document.documentID
                        
                        if let username = document.get("snapsOwner") as? String {
                            if let imageurlarray = document.get("imageURLArray") as? [String] {
                                if let date = document.get("date") as? Timestamp {
                                    
                                    if let timedifference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        
                                        if timedifference >= 24 {
                                            self.fireStoreDataBase.collection("Snaps").document(documentid).delete { (error) in
                                                
                                            }
                                            
                                        } else {
                                            
                                            let snap = Snap(username: username, imageUrlArray: imageurlarray, date: date.dateValue(), timeDifference: 24 - timedifference )
                                                                                                                            
                                             self.snapArray.append(snap)
                                             
                                            
                                        }
                                        
                                    }
                                         
                                }
                                                                
                            }
                            
                         
                        }
                        
                        
                    }
                    
                    self.tableView.reloadData()
                          
                    
                }
                
            }
            
        }
        
    }
    
    
    func getUserinfo() {
        
        
      
        fireStoreDataBase.collection("info").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { (snapshot, error) in
            
            if error != nil {
                
                
                self.alertFunction(titleinput: "ERROR!", messageinput: error?.localizedDescription ?? "ERROR!")
                
                
            } else {
                
                if snapshot?.isEmpty == false && snapshot != nil {
                   
                    for document in snapshot!.documents{
                        
                        if let username = document.get("username") as? String {
                            
                            userSingleton.shareduserinfo.email = Auth.auth().currentUser!.email!
                            
                            userSingleton.shareduserinfo.username = username
                            
                         
                        }
                                    
                        
                    }
                    
                }
                
            }
            
            
        }
        
        
    }
    
    func alertFunction (titleinput : String , messageinput : String){
        
        
        let alert = UIAlertController(title: titleinput, message: messageinput, preferredStyle: UIAlertController.Style.alert)
        
        let alertButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(alertButton)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        
        cell.usernameCell.text = snapArray[indexPath.row].username
        cell.cellView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return snapArray.count
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSnapVC" {
            
             let destinationVC = segue.destination as? SnapVC
                
            destinationVC?.selectedSnap = chosenSnap
            
                
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        chosenSnap = self.snapArray[indexPath.row]
        
        performSegue(withIdentifier: "toSnapVC", sender: nil)
        
        
    }

    

}
