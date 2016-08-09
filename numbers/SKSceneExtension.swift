import SpriteKit

extension SKScene {
    
    /* custom Menu for each scene */
    func createMenuInScene (_ arrayOfValues: [String], zPosition: CGFloat){
        
        var yPosition:CGFloat = (arrayOfValues.count > 3) ? self.frame.midY + 2 * 80 : self.frame.midY + 80 * 1.5
        for i in 0..<arrayOfValues.count {
            let labelForButton = SKLabelNode()
            let button = SKSpriteNode()
            
            labelForButton.fontSize = 24
            labelForButton.fontName = "Helvetica"
            labelForButton.text = NSLocalizedString(arrayOfValues[i], comment: "\(arrayOfValues[i]) button")
            labelForButton.zPosition = zPosition
            labelForButton.fontColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
            labelForButton.horizontalAlignmentMode = .center
            labelForButton.verticalAlignmentMode = .center
            labelForButton.name = "\(arrayOfValues[i])_label"
            
            button.zPosition = zPosition
            button.size = CGSize(width: 220, height: 80)
            button.position = CGPoint(x: self.frame.midX, y: yPosition)
            button.color = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 0.5)
            button.name = "\(arrayOfValues[i])_button"
            
            yPosition = button.position.y - button.frame.height - 10
            
            button.addChild(labelForButton)
        
            self.addChild(button)
        }
    }
    
    func deleteMenuFromScene(_ arrayOfValues: [String]) {
        for element in arrayOfValues {
            let childButton = self.childNode(withName: "\(element)_button")
            let childLabel = self.childNode(withName: "\(element)_label")
            childLabel?.removeFromParent()
            childButton?.removeFromParent()
        }
    }
}
