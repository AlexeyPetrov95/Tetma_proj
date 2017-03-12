/*
 * Сцена настроек
 */
import SpriteKit

class SettingsScene: SKScene {
    
    var skView: SKView! = nil
    let arrayOfValues = ["About us", "Back"]
    let sndButtonClick = SKAction.playSoundFileNamed("menu_click1.wav", waitForCompletion: false)
    

    
    override func didMove(to view: SKView) {
        skView = self.view! as SKView
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
            } else if self.atPoint(location).name == "Sound_button" || self.atPoint(location).name == "Sound_label" {
                let btn = self.childNode( withName: "Sound_button")
                let label = btn!.childNode( withName: "Sound_label") as! SKLabelNode
                if GameViewController.sound {
                    label.text = "Sound on"
                    GameViewController.sound = false
                } else {
                    label.text = "Sound off"
                    GameViewController.sound = true
                }
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
