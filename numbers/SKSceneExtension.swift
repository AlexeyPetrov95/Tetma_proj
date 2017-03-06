import SpriteKit

extension SKScene {
    
    /* custom Menu for each scene */
    func createMenuInScene (arrayOfValues: [String], zPosition: CGFloat){
    
        
        var yPosition:CGFloat = (arrayOfValues.count > 3) ? self.frame.midY + 2 * 80 - 20 : self.frame.midY + 80 * 1 + 20
        for i in 0..<arrayOfValues.count {
            let labelForButton = SKLabelNode()
            let button = SKShapeNode()
            
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
            labelForButton.fontColor = UIColor(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
            labelForButton.horizontalAlignmentMode = .center
            labelForButton.verticalAlignmentMode = .center
            labelForButton.name = "\(arrayOfValues[i])_label"
            labelForButton.fontName = "Helvetica-Bold"
            
            button.zPosition = zPosition
         //   button.size = CGSize(width: 300, height: 80)
            button.position = CGPoint(x: self.frame.midX, y: yPosition)
          //  button.path = UIBezierPath(rect: CGRectMake(origin: CGPoint(x: -150, y: -40), size: CGSize(width: 300, height: 80))).cgPath
         
            button.path = UIBezierPath(rect: CGRect(x:-150, y:-40, width: 300, height: 80)).cgPath
            button.fillColor = UIColor(red: 0.2039215686, green: 0.2117647059, blue: 0.3019607843, alpha: 0.7545109161)
            button.strokeColor = UIColor(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
            button.name = "\(arrayOfValues[i])_button"
            
            yPosition = button.position.y - button.frame.height - 10
            
            button.addChild(labelForButton)
        
            self.addChild(button)
        }
    }
    
    func deleteMenuFromScene(arrayOfValues: [String]) {
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
        
        if GameViewController.adBool.bool(forKey: "adBool") {
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
