
import UIKit
import ImageSlideshow

class SnapVC: UIViewController {
    
    
    @IBOutlet var timeLeftLabel: UILabel!
    
    var selectedSnap : Snap?
    var inputArray = [KingfisherSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        if  let snap = selectedSnap {
            
            timeLeftLabel.text = "Time Left: \(snap.timeDifference)"
            
            
            for imageurl in snap.imageUrlArray {
                
                inputArray.append(KingfisherSource(urlString: imageurl)!)
                
            }
            
            
            let imageslideshow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
            
            imageslideshow.backgroundColor = UIColor.white
            
            
            imageslideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
            
            let pageindicator = UIPageControl()
            
            pageindicator.currentPageIndicatorTintColor = UIColor.gray
            pageindicator.pageIndicatorTintColor = UIColor.black
            
            imageslideshow.pageIndicator = pageindicator
            
            
            imageslideshow.setImageInputs(inputArray)
            
            
            
            
            
            self.view.addSubview(imageslideshow)
            self.view.bringSubviewToFront(timeLeftLabel)
        
            
            
            
        }
        

        
        
        
    }
    
}
