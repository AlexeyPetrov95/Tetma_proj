/**
 *  Установка двух рядов нижних чисел и взаимодействие с ними
 */

import SpriteKit

class InitailNumbers {
    
    
    var sizeForEachHorizontalRow:CGFloat = 0
    var firstRowNumber = 0
    var secondRowNumber = 0
    var sizeForEachVerticalRow:CGFloat = 0
    
    
    var firtsLabelShape = SKSpriteNode()
    var secondLabelShape = SKShapeNode()
    
    var firstLabel = SKLabelNode()
    var secondLabel = SKLabelNode()
    
    
    init (x:CGFloat, scene: GameScene){
        
        self.createNumbers()
        
        self.firstLabel.text = String(self.firstRowNumber)
        self.secondLabel.text = String(self.secondRowNumber)
        
        self.sizeForEachVerticalRow = scene.sizeForEachVerticalRow
        self.sizeForEachHorizontalRow = scene.sizeForEachHorizontalRow
        
        self.firtsLabelShape.position = CGPoint(x: x, y: sizeForEachVerticalRow / 4)
        self.secondLabelShape.position = CGPoint(x: x, y: sizeForEachVerticalRow)
    
    
        self.firstLabel.horizontalAlignmentMode = .center
        self.firstLabel.verticalAlignmentMode = .center
        self.secondLabel.horizontalAlignmentMode = .center
        self.secondLabel.verticalAlignmentMode = .center
        
        //self.secondLabelShape.path = UIBezierPath(roundedRect: CGRect(x: -sizeForEachVerticalRow / 2 + 2.5, y: -sizeForEachVerticalRow / 2, width: sizeForEachVerticalRow - 5, height: sizeForEachVerticalRow), cornerRadius: CGFloat(sizeForEachVerticalRow / 2)).cgPath
        
        self.secondLabelShape.path = UIBezierPath(arcCenter: CGPoint(x: 0, y:0), radius: sizeForEachVerticalRow / 2 - 2.5, startAngle: CGFloat(0), endAngle: CGFloat(-M_PI), clockwise: false).cgPath
        
        self.firstLabel.fontColor = UIColor(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        self.secondLabel.fontColor = UIColor(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        
        self.firstLabel.fontName = "Helvetica-Bold"
        self.secondLabel.fontName = "Helvetica-Bold"
        
        self.firtsLabelShape.zPosition = 3
        self.secondLabelShape.zPosition = 3
        self.firstLabel.zPosition = 5
        self.secondLabel.zPosition = 5
        
        self.firtsLabelShape.addChild(self.firstLabel)
        self.secondLabelShape.addChild(self.secondLabel)
        scene.addChild(self.firtsLabelShape)
        scene.addChild(self.secondLabelShape)
    }
    
    
    
    // Создание 2 рядов чисел
    func createNumbers() {
        self.firstRowNumber = randomInt(min: -10, max: 10)
        self.secondRowNumber = randomInt(min: -15, max: 15)
        if  self.firstRowNumber == self.secondRowNumber {
            if self.secondRowNumber == -15 {
                self.secondRowNumber += 1
            } else if self.secondRowNumber == 15 {
                self.secondRowNumber -= 1
            } else {
                self.secondRowNumber += 1
            }
        }
    }
    
    // Функция вызывает каждый раз когда числа падает на строчку
    // Идет проверка на победу.
    func victory () -> Bool {
        var check = 0
        for i in 0..<GameScene.arrayOfStartNumbers.count {
            if GameScene.arrayOfStartNumbers[i].firstRowNumber == GameScene.arrayOfStartNumbers[i].secondRowNumber {
                check += 1
            }
        }
        
        if check == GameScene.arrayOfStartNumbers.count {
            return true
        } else {
            return false
        }
    }
    
    // FIXME::SOUND INIT
    let sound = SKAction.playSoundFileNamed("numbers.wav", waitForCompletion: false)
    
    
    // FIXME:: need to be in the other file
    // logic for sum numbers
    // Обновление чисел в верхней строке при падении
    func refreshValue (fallingNumber: Int, scene: GameScene) {
        self.secondRowNumber += fallingNumber
        self.secondLabel.text = String(self.secondRowNumber)
        if self.secondRowNumber > 15 || self.secondRowNumber < -15 {
            scene.over = true
            scene.gameOver(text: "Game Over")
        } else if (self.secondRowNumber == self.firstRowNumber ){
            if GameViewController.sound {
                scene.run(sound)
            }
            self.secondLabelShape.path = UIBezierPath(rect: CGRect(x: -sizeForEachVerticalRow / 2 + 2.5, y: -sizeForEachVerticalRow / 2, width: sizeForEachVerticalRow - 5, height: sizeForEachVerticalRow / 2)).cgPath
            
        } else if (self.secondRowNumber != self.firstRowNumber ){
            self.secondLabelShape.path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: sizeForEachVerticalRow / 2 - 2.5, startAngle: CGFloat(0), endAngle: CGFloat(-M_PI), clockwise: false).cgPath
        }
        
        if victory() {
            if GameViewController.sound {
                scene.run(sound)
            }
            scene.over = true
            scene.gameOver(text: "Victory")
        }
    }
}
