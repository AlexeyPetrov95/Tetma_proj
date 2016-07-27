import SpriteKit

class GameNumber {
    
    var start = false
    var value = 0
    let maxValue = 10
    let minValue = -10
    var row: (Int, CGFloat) = (0, 0)
    var time:Double = 0
    var node = SKSpriteNode()
    var label = SKLabelNode()
    
    init(){
        self.node.name = "fallingNumber"
        self.label.name = "fallingNumberLabel"
        self.node.size = CGSize(width: 64, height: 64)
        self.label.zPosition = 48
        self.node.zPosition = 49
    }
    
    func setRandomRow (_ firstRowPosition: CGFloat) -> (Int, CGFloat) {
        let numberOfRow =  0 + Int(arc4random_uniform(UInt32(3 - 0 + 1)))
        return  (numberOfRow, 0 + CGFloat(numberOfRow) * firstRowPosition + firstRowPosition / 2)
    }
    

    func start(_ scene: GameScene) {
        self.node.fallingAnimation(row: self.row, value: self.value, time: self.time, scene: scene)
        scene.addChild(self.node)
    }
}
