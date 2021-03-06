import UIKit
import SceneKit
import ARKit

final class SolarSystemViewController: UIViewController, StoryboardInstantiable {
    
    static let storyboardName = "SolarSystemViewController"
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var planetsCollectionView: UICollectionView!
    
    var interactor: SolarSystemOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor.viewDidLoad()
        setupScene()
        setupUI()
        AudioPlayer.shared.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    // MARK: - Private functions
    
    private func setupScene() {
        sceneView.delegate = self
        sceneView.showsStatistics = false
        
        let scene = SCNScene()
        sceneView.scene = scene
    }
    
    private func setupUI() {
        planetsCollectionView?.register(cellType: PlanetCollectionViewCell.self)
    }
    
    // MARK: - Actions
    
    @IBAction private func showManInSpace() {
        let controller = SpaceManListBuilder.build()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction private func showAudioPlayer() {
        let controller = AudioPlayerBuilder.build()
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func showFactsAboutPlanet() {
        
    }
    
    @IBAction func showDistanceFromEarth() {
//        let planetCategory = interactor.selectedOption
//        let controller = PlanetDistanceBuilder.build(with: planetCategory)
//        controller.modalTransitionStyle = .crossDissolve
//        controller.modalPresentationStyle = .fullScreen
//        self.addChild(controller)
    }
}

extension SolarSystemViewController: SolarSystemInput {
    
    func setupSceneView(with node: SCNNode) {
        DispatchQueue.main.async {
            _ = self.sceneView.scene.rootNode.childNodes.map { $0.removeFromParentNode() }
            self.sceneView.scene.rootNode.addChildNode(node)
        }
    }
}

extension SolarSystemViewController: ARSCNViewDelegate {
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.showAlert(with: "Error", alertMessage: error.localizedDescription)
        }
    }
}
