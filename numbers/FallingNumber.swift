import SpriteKit

class FallingNumber: GameNumber {
    
    init (scene: GameScene) {
        super.init()
        self.value = minValue + Int(arc4random_uniform(UInt32(maxValue - minValue + 1)))
        self.row = setRandomRow(scene.sizeForEachVerticalRow)
        self.label.text = String(self.value)
        self.label.fontName = "Helvetica-Bold"
        self.node.position = CGPoint(x: self.row.1, y: scene.frame.height)
        self.label.text = String(self.value)
        self.label.position = CGPoint(x: 0 , y: 0 - self.label.frame.height / 2)
        self.time = Double(scene.frame.height - GameScene.arrayOfStartNumbers[0].secondLabelShape.position.y) / scene.fallingSpeed
        node.addChild(self.label)
        
    }
}
