//
//  ViewController.swift
//  AlamofireSample1
//
//  Created by 鈴木楓香 on 2023/02/10.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var articleListTableView: UITableView!
    var items: [Displayable] = []
    /// セルを選択した際に格納する
    var selectedItem: Displayable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFilms()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? DetailViewController else { return }
        destinationVC.data = selectedItem
    }


}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = articleListTableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath)
        // titleとsubTitleの設定
        var config = cell.defaultContentConfiguration()
        config.text = items[indexPath.row].titleLabelText
        config.secondaryText = items[indexPath.row].subtitleLabelText
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedItem = items[indexPath.row]
        return indexPath
    }
    
    
}

extension ViewController {
    func fetchFilms() {
        AF.request("https://swapi.dev/api/films")
            .validate()
            .responseDecodable(of: Films.self) { [weak self] (response) in
                guard let films = response.value else { return }
                self?.items = films.all
                self?.articleListTableView.reloadData()
            }
    }
}

