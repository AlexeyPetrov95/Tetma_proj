import SpriteKit

extension SKNode {
    
    func fallingAnimation (row:(Int, CGFloat), value: Int, time: Double, scene: GameScene){
        let fallAction = SKAction.move(to: CGPoint(x:row.1, y: GameScene.arrayOfStartNumbers[0].secondLabelShape.position.y), duration: time)
        self.run(fallAction, completion: {
            GameScene.arrayOfStartNumbers[row.0].refreshValue(value, scene: scene)
            self.destroy()
        });
    }
    
    
    func refreshFallingAnimation (row:(Int, CGFloat), value: Int, yPosition: CGFloat, time: Double, scene: GameScene){
        let fallAction = SKAction.move(to: CGPoint(x: row.1, y: GameScene.arrayOfStartNumbers[0].secondLabelShape.position.y), duration: time)
        self.run(fallAction, completion: {
            GameScene.arrayOfStartNumbers[row.0].refreshValue(value, scene: scene)
            self.destroy()
        });
    }
    
    
    func getValue (_ text: String) -> Int {
        let value = Int(text)
        return value!
    }
    
    func destroy () {
        self.removeAllActions()
        self.removeFromParent()
        GameScene.nextNumber.removeFirst()
    }
}
