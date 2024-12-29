import SwiftUI
import SceneKit

struct ContentView: View {
    var body: some View {
        BalloonSceneView()
            .edgesIgnoringSafeArea(.all)
    }
}

struct BalloonSceneView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        let scene = createScene()
        sceneView.scene = scene
        sceneView.allowsCameraControl = false
        sceneView.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        sceneView.autoenablesDefaultLighting = true

        // Connect the coordinator to the scene view
        sceneView.delegate = context.coordinator
        context.coordinator.scene = scene

        // Add tap gesture recognizer for balloon interaction
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)

        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    private func createScene() -> SCNScene {
        let scene = SCNScene()

        // Add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 10, 30)
        scene.rootNode.addChildNode(cameraNode)

        return scene
    }

    class Coordinator: NSObject, SCNSceneRendererDelegate {
        var scene: SCNScene?
        
        override init() {
            super.init()
            startSpawningBalloons()
        }
        
        private func startSpawningBalloons() {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                guard let scene = self.scene else { return }
                let balloon = self.createBalloon()
                scene.rootNode.addChildNode(balloon)
                self.animateBalloon(balloon)
            }
        }
        
        private func createBalloon() -> SCNNode {
            let balloonRadius: CGFloat = 2
            let sphere = SCNSphere(radius: balloonRadius)
            
            // Random color for the balloon
            sphere.firstMaterial?.diffuse.contents = UIColor(
                red: CGFloat.random(in: 0...1),
                green: CGFloat.random(in: 0...1),
                blue: CGFloat.random(in: 0...1),
                alpha: 1.0
            )
            
            let balloonNode = SCNNode(geometry: sphere)
            
            // Add alphabet label to the top center of the balloon
            let alphabetLabel = createAlphabetLabel(balloonRadius: balloonRadius)
            balloonNode.addChildNode(alphabetLabel)
            
            // Random starting position
            let randomX = Float.random(in: -5...5)
            let randomZ = Float.random(in: -5...5)
            balloonNode.position = SCNVector3(randomX, -10, randomZ)
            
            return balloonNode
        }
        
        /*private func createAlphabetLabel() -> SCNNode {
         let text = SCNText(string: randomAlphabet(), extrusionDepth: 1.0)
         text.font = UIFont.systemFont(ofSize: 8, weight: .bold)
         text.firstMaterial?.diffuse.contents = UIColor.white
         
         let textNode = SCNNode(geometry: text)
         textNode.scale = SCNVector3(0.3, 0.3, 0.8)
         textNode.position = SCNVector3(-0.2, -0.3, 0.5) // Center position
         return textNode
         }*/
        
        private func createAlphabetLabel(balloonRadius: CGFloat) -> SCNNode {
            let text = SCNText(string: randomAlphabet(), extrusionDepth: 0.2)
            text.font = UIFont.systemFont(ofSize: 4, weight: .bold)
            text.firstMaterial?.diffuse.contents = UIColor.white
            text.flatness = 0.1
            
            let textNode = SCNNode(geometry: text)
            textNode.scale = SCNVector3(0.3, 0.3, 0.3)
            
            // Calculate bounding box
            let (minBounds, maxBounds) = text.boundingBox
            let textWidth = maxBounds.x - minBounds.x
            let textHeight = maxBounds.y - minBounds.y
            
            // Simplify position calculations
            let xPosition = -textWidth / 2 * 0.3 // Center horizontally
            let yPosition = (balloonRadius + CGFloat(textHeight)) / 2 * 0.3 // Center horizontally
            // let yPosition = balloonRadius + CGFloat(textHeight) * 0.3 // Slightly above the top of the balloon
            let zPosition: Float = 2.0 // Align with balloon Z-axis
            
            // Set position
            textNode.position = SCNVector3(xPosition, Float(yPosition), zPosition)
            
            return textNode
        }
        
        private func randomAlphabet() -> String {
            let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            return String(letters.randomElement() ?? "A")
        }
        
        private func animateBalloon(_ balloon: SCNNode) {
            // Move the balloon upward
            let moveUp = SCNAction.moveBy(x: 0, y: 50, z: 0, duration: Double.random(in: 5...8))
            let remove = SCNAction.removeFromParentNode()
            let sequence = SCNAction.sequence([moveUp, remove])
            balloon.runAction(sequence)
        }
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let sceneView = gesture.view as? SCNView,
                  let hitResult = sceneView.hitTest(gesture.location(in: sceneView), options: nil).first else { return }
            
            let node = hitResult.node
            /*
             // Load explosion particle system
             if let explosion = SCNParticleSystem(named: "Explosion.scnp", inDirectory: nil) {
             // Add particle system to the tapped node
             node.addParticleSystem(explosion)
             } else {
             print("Explosion particle system not found!")
             }*/
            self.explodeBalloon(node)
            // Remove the balloon after the explosion
            node.removeFromParentNode()
        }
        
        
        private func explodeBalloon(_ balloon: SCNNode) {
            // Add programmatically created explosion
            let explosion = createExplosion()
            balloon.addParticleSystem(explosion)
            
            // Animate scaling down (pop effect)
            let scaleDown = SCNAction.scale(to: 0.0, duration: 0.2)
            let remove = SCNAction.removeFromParentNode()
            let sequence = SCNAction.sequence([scaleDown, remove])
            
            balloon.runAction(sequence)
        }
        
        private func createExplosion() -> SCNParticleSystem {
            let explosion = SCNParticleSystem()
            explosion.birthRate = 500
            explosion.particleSize = 1.0 // 0.1
            explosion.particleColor = UIColor.red
            explosion.emissionDuration = 1.0// 0.1
            explosion.spreadingAngle = 360
            explosion.speedFactor = 5.0
            // explosion.particleLifeSpan = 1.0
            explosion.loops = false
            explosion.isAffectedByGravity = true
            return explosion
        }
    }
}
