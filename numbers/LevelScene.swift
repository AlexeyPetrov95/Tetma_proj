import SpriteKit

class LevelScene: SKScene {
    
    var skView: SKView! = nil
    let arrayOfValues = ["Kid's mode", "Easy", "Hard", "Back"]
    let sndButtonClick = SKAction.playSoundFileNamed("menu_click.wav", waitForCompletion: false)
  
    
    override func didMoveToView(view: SKView) {
        self.skView = self.view! as SKView
        let backgroundNode = SKSpriteNode(imageNamed: "main_menu")
        backgroundNode.size = self.frame.size
        backgroundNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        backgroundNode.zPosition = 1
        self.createMenuInScene(arrayOfValues, zPosition: 3)
        self.addChild(backgroundNode)
        createSoundButton()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if self.nodeAtPoint(location).name == "Back_button" || self.nodeAtPoint(location).name == "Back_label" {
                let btn = self.childNodeWithName("Back_button")
                let scene = MenuScene(size: self.size)
                presentNewScene(scene, skView: skView, button: btn!)
            } else if self.nodeAtPoint(location).name == "Kid's mode_button" || self.nodeAtPoint(location).name == "Kid's mode_label" {
                let btn = self.childNodeWithName("Kid's mode_button")
                let scene = GameScene(size: self.size, countOfFallingNumbers: 1, fallingSpeed: 90, interval: 0, countOfRow:4,  level: "kid", timerForHelp: 30)
                presentNewScene(scene, skView: skView, button: btn!)
            } else if self.nodeAtPoint(location).name == "Easy_button" || self.nodeAtPoint(location).name == "Easy_label" {
                let endPoint = self.frame.width / CGFloat(5)
                let interval = ((self.frame.height - endPoint) / 110) / 2
                print(interval)
                let btn = self.childNodeWithName("Kid's mode_button")
                let scene = GameScene(size: self.size, countOfFallingNumbers: 2, fallingSpeed: 110, interval: Int(interval), countOfRow: 5, level: "easy", timerForHelp: 60)
                presentNewScene(scene, skView: skView, button: btn!)
              
            } else if self.nodeAtPoint(location).name == "Hard_button" || self.nodeAtPoint(location).name == "Hard_label" {
                let endPoint = self.frame.width / CGFloat(5)
                let interval = ((self.frame.height - endPoint) / 140) / 2
                let btn = self.childNodeWithName("Kid's mode_button")
                let scene = GameScene(size: self.size, countOfFallingNumbers: 2, fallingSpeed: 140, interval: Int(interval), countOfRow: 5, level: "hard", timerForHelp:60)
                presentNewScene(scene, skView: skView, button: btn!)
            } else if self.nodeAtPoint(location).name == "Sound_button" {
                let soundButton = self.childNodeWithName("Sound_button") as! SKSpriteNode
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
    
    override func update(currentTime: NSTimeInterval) {
        /* Called before each frame is rendered */
        
    }
}
