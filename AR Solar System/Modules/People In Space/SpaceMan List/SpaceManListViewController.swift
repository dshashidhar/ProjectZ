import UIKit
import ARKit

final class SpaceManListViewController: UIViewController, StoryboardInstantiable {
    
    static let storyboardName = "SpaceManListViewController"
    
    var interactor: SpaceManListOutput!
    
    @IBOutlet weak var cosmonautsListTableView: UITableView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private functions
    
    private func setupUI() {
        cosmonautsListTableView.register(UINib(nibName: CosmonautTableViewCell.identifier, bundle: nil),
                                         forCellReuseIdentifier: CosmonautTableViewCell.identifier)
        cosmonautsListTableView.tableFooterView = UIView()
    }
}

extension SpaceManListViewController: SpaceManListInput {
    
    func reloadData() {
        loadingActivityIndicator.stopAnimating()
        cosmonautsListTableView.reloadData()
    }
    
    func onError(_ error: ErrorType) {
        loadingActivityIndicator.stopAnimating()
    }
    
    func showCosmonautDetails(spaceMan: SpaceMan) {
        let controller = SpaceManDetailsBuilder.build(with: spaceMan)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension SpaceManListViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return interactor.peopleInSpaceRightNow?.number ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CosmonautTableViewCell.identifier, for: indexPath) as! CosmonautTableViewCell
        
        if let cosmonaut = interactor.peopleInSpaceRightNow?.people[indexPath.row] {
            cell.populate(with: cosmonaut)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SpaceManListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor.getCosmonautDetails(at: indexPath.row)
    }
}
