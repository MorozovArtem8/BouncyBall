import Foundation
import UIKit
var buttonOn: Bool = true
var barriers: [Shape] = []
var targets: [Shape] = []
let ball = OvalShape(width: 40, height: 40)

let funnelPoints = [
    Point(x: 0, y: 50),
    Point(x: 80, y: 50),
    Point(x: 60, y: 0),
    Point(x: 20, y: 0)
]
let funnel = PolygonShape(points: funnelPoints)
let button = PolygonShape(points: [Point(x: 0, y: 50), Point(x: 0, y: 0), Point(x: 50, y: 0), Point(x: 50, y: 50)])

func addTarget(position: Point) {
    let targetPoints = [
            Point(x: 10, y: 0),
            Point(x: 0, y: 10),
            Point(x: 10, y: 20),
            Point(x: 20, y: 10)
        ]
    let target = PolygonShape(points:
           targetPoints)
    targets.append(target)
    target.position = position
    target.hasPhysics = true
    target.isImmobile = true
    target.isImpermeable = false
    target.fillColor = .yellow
    scene.add(target)
    target.name = "target"
    target.isDraggable = false
    
}

fileprivate func setupBall() {
    ball.position = Point(x: 250, y: 250)
    ball.hasPhysics = true
    ball.fillColor = Color(red: 100, green: 333, blue: 555)
    scene.add(ball)
    ball.onCollision = ballCollided(with:)
    ball.isDraggable = false
    scene.trackShape(ball)
    ball.onExitedScene = ballExitedScene
    ball.onTapped = resetGame
    ball.bounciness = 0.8

}

fileprivate func addBarrier(position: Point, width: Double, height: Double, angle: Double) {
    let barrierPoints = [
            Point(x: 0, y: 0),
            Point(x: 0, y: height),
            Point(x: width, y: height),
            Point(x: width, y: 0)
        ]
    let barrier = PolygonShape(points:barrierPoints)
    barriers.append(barrier)

    barrier.position = position
    barrier.hasPhysics = true
    barrier.isImmobile = true
    barrier.fillColor = .red
    scene.add(barrier)
    barrier.angle = angle
}

fileprivate func setupFunnel() {
    // Add a funnel to the scene
    funnel.position = Point(x: 200, y: scene.height - 25)
    funnel.fillColor = .gray
    
    scene.add(funnel)
    funnel.onTapped = dropBall
    funnel.isDraggable = false
}
fileprivate func setupButton(){
    button.position = Point(x: 368, y: 735)
    button.fillColor = .gray
    scene.add(button)
    button.onTapped = buttonTapped
    button.isDraggable = false
    
    
}

func setup() {
    scene.backgroundColor = .cyan
    setupBall()
    setupFunnel()
    setupButton()
    
    addBarrier(position: Point(x: 200, y: 150), width: 60, height: 25, angle: 0.1)
    addBarrier(position: Point(x: 300, y: 350), width: 60, height: 25, angle: 2)
    addBarrier(position: Point(x: 100, y: 50), width: 60, height: 25, angle: 0.7)
    
    addTarget(position: Point(x: 163, y: 442))
    addTarget(position: Point(x: 277, y: 314))
    addTarget(position: Point(x: 101, y: 199))
    
    resetGame()
    
    scene.onShapeMoved = printPosition(of:)


}

func buttonTapped(){
    if buttonOn {
        button.fillColor = .yellow
        for target in targets {
            target.isDraggable = true
        }
    }else{
        button.fillColor = .gray
        for target in targets {
            target.isDraggable = false
        }
    }
    
    buttonOn = !buttonOn
}

func dropBall() {
    for target in targets {
        target.fillColor = .yellow
    }
    ball.position = funnel.position
    ball.stopAllMotion()
    for barier in barriers {
        barier.isDraggable = false
    }
}

func ballCollided(with otherShape: Shape) {
    if otherShape.name != "target" {return}
    
    otherShape.fillColor = .green

}
func ballExitedScene() {
    var hitTargets = 0
    for target in targets {
        if target.fillColor == .green {
            hitTargets += 1
        }
    }
    if hitTargets == targets.count {
        scene.presentAlert(text: "You won!",
           completion: alertDismissed)
    }
    
    for barrier in barriers {
            barrier.isDraggable = true
        }
}
func resetGame(){
    ball.position = Point(x: 0, y: 0)
}

func printPosition(of shape: Shape){
    print(shape.position)
}
func alertDismissed() {
    for target in targets {
        target.fillColor = .yellow
    }
}
//

