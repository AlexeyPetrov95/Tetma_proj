import SpriteKit
import UIKit
import Foundation

class TutorialScene: SKScene  {
    var skView: SKView! = nil
    

    
    override func didMove(to view: SKView) {
        self.skView = self.view! as SKView
        
        let background = SKSpriteNode(imageNamed: "back_tutorial")
        background.size = self.frame.size
        background.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        background.zPosition = 0
        
        let backgroundNode = SKSpriteNode(imageNamed: "move")
        backgroundNode.size = CGSize(width: 250, height: 350)
        backgroundNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 50)
        backgroundNode.zPosition = 1
    
        
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
        button.position = CGPoint(x: self.frame.midX, y: 50)
     //   button.path = UIBezierPath(rect: CGRectMake(origin: CGPointMake(x: -150, y: -40), size: CGSizeMake(width: 300, height: 80))).cgPath
        
        button.path = UIBezierPath(rect: CGRect(x: -150, y:-40, width: 300, height:80)).cgPath
        
        button.fillColor = UIColor(red: 0.2039215686, green: 0.2117647059, blue: 0.3019607843, alpha: 0.75)
        button.strokeColor = UIColor(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        button.name = "Back_button"
        
        
        button.addChild(labelForButton)
        
        self.addChild(button)
        self.addChild(backgroundNode)
       // self.addChild(backgroundNodePart2)
        self.addChild(background)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if self.atPoint(location).name == "Back_button" || self.atPoint(location).name == "Back_label" {
                let btn = self.childNode(withName: "Back_button")
                let scene = MenuScene(size: self.size)
                presentNewScene(scene: scene, skView: skView, button: btn!)
            }
        }
    }
    

}
