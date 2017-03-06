import SpriteKit

class LevelScene: SKScene {
    
    var skView: SKView! = nil
    let arrayOfValues = ["Kid's mode", "Easy", "Hard", "Back"]
    let sndButtonClick = SKAction.playSoundFileNamed("menu_click1.wav", waitForCompletion: false)
  
    
    override func didMove(to view: SKView) {
        self.skView = self.view! as SKView
        let backgroundNode = SKSpriteNode(imageNamed: "main_menu")
        backgroundNode.size = self.frame.size
        backgroundNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        backgroundNode.zPosition = 1
        self.createMenuInScene(arrayOfValues: arrayOfValues, zPosition: 3)
        self.addChild(backgroundNode)
        createSoundButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if self.atPoint(location).name == "Back_button" || self.atPoint(location).name == "Back_label" {
                let btn = self.childNode(withName: "Back_button")
                let scene = MenuScene(size: self.size)
                presentNewScene(scene: scene, skView: skView, button: btn!)
            } else if self.atPoint(location).name == "Kid's mode_button" || self.atPoint(location).name == "Kid's mode_label" {
                let btn = self.childNode(withName: "Kid's mode_button")
                let scene = GameScene(size: self.size, countOfFallingNumbers: 1, fallingSpeed: 90, interval: 0, countOfRow:4,  level: "kid", timerForHelp: 30)
                presentNewScene(scene: scene, skView: skView, button: btn!)
            } else if self.atPoint(location).name == "Easy_button" || self.atPoint(location).name == "Easy_label" {
                let endPoint = self.frame.width / CGFloat(5)
                let interval = ((self.frame.height - endPoint) / 110) / 2
                print(interval)
                let btn = self.childNode(withName: "Kid's mode_button")
                let scene = GameScene(size: self.size, countOfFallingNumbers: 2, fallingSpeed: 110, interval: Int(interval), countOfRow: 5, level: "easy", timerForHelp: 60)
                presentNewScene(scene: scene, skView: skView, button: btn!)
              
            } else if self.atPoint(location).name == "Hard_button" || self.atPoint(location).name == "Hard_label" {
                let endPoint = self.frame.width / CGFloat(5)
                let interval = ((self.frame.height - endPoint) / 140) / 2
                let btn = self.childNode(withName: "Kid's mode_button")
                let scene = GameScene(size: self.size, countOfFallingNumbers: 2, fallingSpeed: 140, interval: Int(interval), countOfRow: 5, level: "hard", timerForHelp:60)
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
