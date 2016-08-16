import SpriteKit

extension SKScene {
    
    /* custom Menu for each scene */
    func createMenuInScene (_ arrayOfValues: [String], zPosition: CGFloat){
    
        
        var yPosition:CGFloat = (arrayOfValues.count > 3) ? self.frame.midY + 2 * 80 - 10 : self.frame.midY + 80 * 1.5
        for i in 0..<arrayOfValues.count {
            let labelForButton = SKLabelNode()
            let button = SKSpriteNode()
            
            if arrayOfValues[i] == "Sound" {
                if GameViewController.sound {
                  labelForButton.text = NSLocalizedString("\(arrayOfValues[i]) off", comment: "\(arrayOfValues[i]) button")
                } else {
                 labelForButton.text = NSLocalizedString("\(arrayOfValues[i]) on", comment: "\(arrayOfValues[i]) button")
                }
            } else {
                 labelForButton.text = NSLocalizedString(arrayOfValues[i], comment: "\(arrayOfValues[i]) button")
            }
            
            labelForButton.fontSize = 22
            //qlabelForButton.fontName = "Helvetica"
            labelForButton.zPosition = zPosition
            labelForButton.fontColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
            labelForButton.horizontalAlignmentMode = .center
            labelForButton.verticalAlignmentMode = .center
            labelForButton.name = "\(arrayOfValues[i])_label"
            labelForButton.fontName = "Helvetica-Bold"
            
            button.zPosition = zPosition
            button.size = CGSize(width: 300, height: 80)
            button.position = CGPoint(x: self.frame.midX, y: yPosition)
            button.color = #colorLiteral(red: 0.2039215686, green: 0.2117647059, blue: 0.3019607843, alpha: 0.8788077911)
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
    
    func createSoundButton () {
        let soundButton = SKSpriteNode()
        soundButton.size = CGSize(width: 24, height: 24)
        
        if GameViewController.adBool {
             soundButton.position =  CGPoint(x: self.frame.width - soundButton.frame.width / 2 - 10, y: self.frame.height - soundButton.frame.height / 2 - 55)
        } else {
              soundButton.position =  CGPoint(x: self.frame.width - soundButton.frame.width / 2 - 10, y: self.frame.height - soundButton.frame.height / 2 - 15)
        }
       
        soundButton.zPosition = 5
        
        soundButton.name = "Sound_button"
        
        if (GameViewController.sound){
            soundButton.texture = SKTexture(imageNamed: "sound_on")
        } else {
            soundButton.texture = SKTexture(imageNamed: "sound_off")
        }
        
        self.addChild(soundButton)
        
    }
    
}
