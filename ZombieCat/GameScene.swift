/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


import SpriteKit


class GameScene: SKScene {
    
    // MARK: - Properties
    
    var pinBeakerToZombieArm: SKPhysicsJointFixed?
    var beakerReady = false
    
    // MARK: - Override
    
    override func didMove(to view: SKView) {
        newProjectile()
        let cloud = SKSpriteNode(imageNamed: "regularExplosion00")
        cloud.name = "cloud"
        cloud.setScale(0)
        cloud.zPosition = 1
        beaker.addChild(cloud)
    }
    
    //    MARK: - Methods
    
    func newProjectile () {
        let beaker = SKSpriteNode(imageNamed: "beaker")
        beaker.name = "beaker"
        beaker.zPosition = 5
        beaker.position = CGPoint(x: 120, y: 625)
        let beakerBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 40))
        beakerBody.mass = 1.0
        beakerBody.categoryBitMask = PhysicsType.beaker
        beakerBody.collisionBitMask = PhysicsType.wall | PhysicsType.cat
        beaker.physicsBody = beakerBody
        addChild(beaker)
        
        if let armBody = childNode(withName: "player")?.childNode(withName: "arm")?.physicsBody {
            pinBeakerToZombieArm = SKPhysicsJointFixed.joint(withBodyA: armBody, bodyB: beakerBody, anchor: CGPoint.zero)
            physicsWorld.add(pinBeakerToZombieArm!)
            beakerReady = true
        }
    }
    
    func tossBeaker(strength: CGVector) {
        if beakerReady == true {
            if let beaker = childNode(withName: "beaker") {
                if let arm = childNode(withName: "player")?.childNode(withName: "arm") {
                    let toss = SKAction.run() {
                        self.physicsWorld.remove(self.pinBeakerToZombieArm!)
                        beaker.physicsBody?.applyImpulse(strength)
                        beaker.physicsBody?.applyAngularImpulse(0.1125)
                        self.beakerReady = false
                    }
                    
                    let followTrough = SKAction.rotate(byAngle: -6 * 3.14, duration: 2.0)
                    
                    arm.run(SKAction.sequence([toss, followTrough]))
                }
                
                // explosion added later
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tossBeaker(strength: CGVector(dx: 1400, dy: 1150))
    }
}
