import UIKit
import SpriteKit
import GoogleMobileAds
import StoreKit

class GameViewController: UIViewController, GADBannerViewDelegate {

    
    static var sound = true
    var adBannerView: GADBannerView!
    static var adBool: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = MenuScene(fileNamed:"GameScene") {
            let skView = self.view as! SKView
            scene.size = skView.bounds.size
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
            
            
            adBannerView = GADBannerView(frame: CGRect(x: 0, y: 0, width: self.view!.frame.width, height: 50))
            adBannerView.delegate = self
            adBannerView.rootViewController = self
            adBannerView.adUnitID = "ca-app-pub-9894820443925606/8733568178"
            
            let reqAd = GADRequest()
            reqAd.testDevices = ["ac772c88a5cdd8324566c05e63727702"];
            adBannerView.load(reqAd)
            self.view.addSubview(adBannerView)
            
            adBannerView.isHidden = true
            
            if !adBannerView.isHidden {
                GameViewController.adBool = true
            } else {
                 GameViewController.adBool = false
            }
        }
    
    }
    


    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.current().userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
