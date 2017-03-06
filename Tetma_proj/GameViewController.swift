

import UIKit
import SpriteKit
//import GoogleMobileAds
import StoreKit

//public var interstitial: GADInterstitial!

class GameViewController: UIViewController {
    
    
    static var sound = true
    //var adBannerView: GADBannerView!
    static var adBool = UserDefaults.standard
    
    
    
//    func createAndLoadInterstitial() {
//        interstitial = GADInterstitial(adUnitID: "ca-app-pub-9894820443925606/3042654572")
//        let request = GADRequest()
//        request.testDevices = [ kGADSimulatorID, "ac772c88a5cdd8324566c05e63727702" ]
//        interstitial.load(request)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GameViewController.adBool.set(true, forKey: "adBool")
        
        if let scene = MenuScene(fileNamed:"GameScene") {
            let skView = self.view as! SKView
            scene.size = skView.bounds.size
            scene.scaleMode = .aspectFill

            
//            adBannerView = GADBannerView(frame: CGRect(x: 0, y: 0, width: self.view!.frame.width, height: 50))
//            adBannerView.delegate = self
//            adBannerView.rootViewController = self
//            adBannerView.adUnitID = "ca-app-pub-9894820443925606/8733568178"
//            createAndLoadInterstitial()
//            
//            //let reqAd = GADRequest()
//            //       reqAd.testDevices = ["ac772c88a5cdd8324566c05e63727702"];
//           // adBannerView.load(reqAd)
           
            GameViewController.adBool.set(false, forKey: "adBool")
           // self.view.addSubview(adBannerView)
            
            
           // adBannerView.isHidden = true
            
            skView.presentScene(scene)
        
            
        }
        
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
