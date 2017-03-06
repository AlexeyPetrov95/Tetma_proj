
import SpriteKit

class AboutUsScene: SKScene {
    
    var skView: SKView! = nil
    let sndButtonClick = SKAction.playSoundFileNamed("menu_click1.wav", waitForCompletion: false)
    
    
    
    override func didMove(to view: SKView){
        self.skView = self.view! as SKView
        let backgroundNode = SKSpriteNode(imageNamed: "background")
        backgroundNode.size = self.frame.size
        backgroundNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        backgroundNode.zPosition = 1
        
        
        let aboutUsBlock = SKSpriteNode()
        aboutUsBlock.size = CGSize(width: self.frame.width, height: 120)
        aboutUsBlock.position = CGPoint(x: self.frame.midX, y: self.frame.midY + aboutUsBlock.size.height / 2)
        
        aboutUsBlock.color = UIColor(red: 0.2039215686, green: 0.2117647059, blue: 0.3019607843, alpha: 0.75)
        aboutUsBlock.zPosition = 3
        
        let labelTetma = SKLabelNode()
        labelTetma.text = "Tetma"
        labelTetma.fontSize = 22
        labelTetma.fontName = "Helvetica-Bold"
        labelTetma.zPosition = 3
        
        let labelSite = SKLabelNode()
        labelSite.text = "www.tetmaplay.com"
        labelSite.fontSize = 18
        labelSite.fontName = "Helvetica"
        labelSite.zPosition = 3
        
        
        
        // допилить позиционирование
        labelTetma.position = CGPoint(x: 0, y: 5)
        labelSite.position = CGPoint(x: 0, y: -20)
        
        aboutUsBlock.addChild(labelTetma)
        aboutUsBlock.addChild(labelSite)
        
        let labelForButton = SKLabelNode()
        let button = SKShapeNode()
        
        labelForButton.fontSize = 22
        //qlabelForButton.fontName = "Helvetica"
        labelForButton.zPosition = zPosition
        labelForButton.fontColor = UIColor(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        labelForButton.horizontalAlignmentMode = .center
        labelForButton.verticalAlignmentMode = .center
        labelForButton.name = "Back_label"
        labelForButton.fontName = "Helvetica"
        labelForButton.text = NSLocalizedString("Back", comment: "Back button")
        
        button.zPosition = 3
        button.position = CGPoint(x: self.frame.midX, y: aboutUsBlock.position.y - 120)
        //button.path = UIBezierPath(rect: CGRect(origin: CGPoint(x: -150, y: -40), size: CGSize(width: 300, height: 80))).cgPath
        button.path = UIBezierPath(rect: CGRect(x:-150, y:-40, width:300, height:80)).cgPath
        
        button.fillColor = UIColor(red: 0.2039215686, green: 0.2117647059, blue: 0.3019607843, alpha: 0.75)
        button.strokeColor = UIColor(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        button.name = "Back_button"
        
        
        button.addChild(labelForButton)
        
        
        self.addChild(button)
        self.addChild(backgroundNode)
        createSoundButton()
        self.addChild(aboutUsBlock)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if self.atPoint(location).name == "Back_button" || self.atPoint(location).name == "Back_label" {
                let btn = self.childNode(withName: "Back_button")
                let scene = MenuScene(size: self.size)
                presentNewScene(scene: scene, skView: skView, button: btn!)
            } else if self.atPoint(location).name == "Sound_button" {
                let soundButton = self.childNode(withName: "Sound_button") as! SKSpriteNode
                if GameViewController.sound {
                    GameViewController.sound = false
                    soundButton.texture = SKTexture(imageNamed: "sound_off")
                } else {
                    GameViewController.sound = true
                    soundButton.texture = SKTexture(imageNamed: "sound_on")
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
    }
}
