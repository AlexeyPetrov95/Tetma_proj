import SpriteKit
import Foundation
import SystemConfiguration

let sndButtonClick = SKAction.playSoundFileNamed("menu_click1.wav", waitForCompletion: false)

func presentNewScene (scene: SKScene, skView: SKView, button: SKNode) {
    scene.size = skView.bounds.size
    scene.scaleMode = .aspectFill
    if GameViewController.sound  {
        button.run(sndButtonClick, completion: {
            skView.presentScene(scene)
        })
    } else {
        skView.presentScene(scene)
    }
}
