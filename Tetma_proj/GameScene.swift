import SpriteKit

class StripeAnimation {
    
    var position = CGPoint (x: 0, y: 0)
    var size = CGSize (width: 0, height: 0)
    var color: UIColor! = nil
    
    init (x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor){
        self.size = CGSize(width: width, height: height)
        self.position = CGPoint(x: x, y: y)
        self.color = color
    }
}

class MenuScene: SKScene {
    
    let arrayOfValues = ["Start", "Tutorial", "About us"]
    var skView: SKView! = nil
    let sndButtonClick = SKAction.playSoundFileNamed("menu_click1.wav", waitForCompletion: false)
    
    
    override func didMove(to view: SKView) {
        self.skView = self.view! as SKView
        
        let backgroundNode = SKSpriteNode(imageNamed: "background_default")
        backgroundNode.size = self.frame.size
        backgroundNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        backgroundNode.zPosition = 0
        self.createMenuInScene(arrayOfValues: arrayOfValues, zPosition: 3)
        self.addChild(backgroundNode)
        createSoundButton()
//        if interstitial.isReady && GameViewController.adBool.bool( forKey: "adBool") {
//            //      interstitial.present(fromRootViewController: (self.view?.window?.rootViewController)!)
//            interstitial.present(fromRootViewController: (self.view?.window?.rootViewController)!)
//        } else {
//            print("Ad wasn't ready")
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if self.atPoint(location).name == "Start_button" || self.atPoint(location).name == "Start_label" {
                let btn = self.childNode(withName: "Start_button")
             //   let scene = LevelScene(size: self.size)
              //  presentNewScene(scene: scene, skView: skView, button: btn!)
            } else if self.atPoint(location).name == "Settings_button" || self.atPoint(location).name == "Settings_label" {
                let btn = self.childNode(withName: "Settings_button")
               // let scene = SettingsScene(size: self.size)
               // presentNewScene(scene: scene, skView: skView, button: btn!)
            } else if self.atPoint(location).name == "Buy_button" || self.atPoint(location).name == "Buy_label" {
                let btn = self.childNode(withName: "Buy_button")
                //let scene = BuyScene(size: self.size)
               // presentNewScene(scene: scene, skView: skView, button: btn!)
            } else if self.atPoint(location).name == "Sound_button" {
                let soundButton = self.childNode(withName: "Sound_button") as! SKSpriteNode
                if GameViewController.sound {
                    GameViewController.sound = false
                    soundButton.texture = SKTexture(imageNamed: "sound_off")
                } else {
                    GameViewController.sound = true
                    soundButton.texture = SKTexture(imageNamed: "sound_on")
                }
            } else if self.atPoint(location).name == "About us_button" || self.atPoint(location).name == "About us_label"{
                let btn = self.childNode(withName: "About us_button")
               // let scene = AboutUsScene(size: self.size)
               // presentNewScene(scene: scene, skView: skView, button: btn!)
            } else if self.atPoint(location).name == "Tutorial_button" || self.atPoint(location).name == "Tutorial_label" {
                let btn = self.childNode(withName: "About us_button")
               // let scene = TutorialScene(size: self.size)
               // presentNewScene(scene: scene, skView: skView, button: btn!)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {}
}
