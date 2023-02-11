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
    @IBOutlet weak var searchBar: UISearchBar!
    /// 取得した内容をキャッシュする
    var films: [Film] = []
    /// TableViewに表示するデータ
    var items: [Displayable] = []
    /// セルを選択した際に格納する
    var selectedItem: Displayable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFilms()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // タップしたデータを詳細画面に渡す
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

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let shipName = searchBar.text else { return }
        searchStarships(for: shipName)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        // 取得したデータを再度表示する
        items = films
        articleListTableView.reloadData()
    }
}


extension ViewController {
    /// FIlmを全件取得する
    func fetchFilms() {
        AF.request("https://swapi.dev/api/films")
            .validate()
            .responseDecodable(of: Films.self) { [weak self] (response) in
                guard let films = response.value else { return }
                self?.items = films.all
                self?.films = films.all
                self?.articleListTableView.reloadData()
            }
    }
    /// パラメータ検索をする
    func searchStarships(for name: String) {
        let url = "https://swapi.dev/api/starships"
        let parameters: [ String : String ] = [ "search" : name ]
        
        AF.request(url, parameters: parameters)
            .validate()
            .responseDecodable(of: Starships.self) { response in
                guard let starships = response.value else { return }
                self.items = starships.all
                self.articleListTableView.reloadData()
            }
    }
}

