import SpriteKit

class SettingsScene: SKScene {
    
    var skView: SKView! = nil
    let arrayOfValues = ["About us", "Back"]
    let sndButtonClick = SKAction.playSoundFileNamed("menu_click.wav", waitForCompletion: false)
    

    
    override func didMoveToView(view: SKView) {
        skView = self.view! as SKView
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
            } else if self.nodeAtPoint(location).name == "Sound_button" || self.nodeAtPoint(location).name == "Sound_label" {
                let btn = self.childNodeWithName( "Sound_button")
                let label = btn!.childNodeWithName( "Sound_label") as! SKLabelNode
                if GameViewController.sound {
                    label.text = "Sound on"
                    GameViewController.sound = false
                } else {
                    label.text = "Sound off"
                    GameViewController.sound = true
                }
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
