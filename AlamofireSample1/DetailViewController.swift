//
//  DetailViewController.swift
//  AlamofireSample1
//
//  Created by 鈴木楓香 on 2023/02/10.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var item1Label: UILabel!
    @IBOutlet weak var item1Value: UILabel!
    @IBOutlet weak var item2Label: UILabel!
    @IBOutlet weak var item2Value: UILabel!
    @IBOutlet weak var item3Label: UILabel!
    @IBOutlet weak var item3Value: UILabel!
    @IBOutlet weak var listTitle: UILabel!
    
    var data: Displayable?
    var listData: [Any] = []
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchList()
    }
    
    private func setup() {
        guard let data = data else { return }
        titleLabel.text = data.titleLabelText
        subtitleLabel.text = data.subtitleLabelText
        item1Label.text = data.item1.label
        item1Value.text = data.item1.value
        item2Label.text = data.item2.label
        item2Value.text = data.item2.value
        item3Label.text = data.item3.label
        item3Value.text = data.item3.value
        listTitle.text = data.listTitle
    }

}

extension DetailViewController {
    private func fetch< T : Decodable & Displayable >(_ list: [String], of: T.Type) {
        var items: [T] = []
        // 非同期処理完了後に実行するため
        let fetchGroup = DispatchGroup()
        list.forEach { (url) in
            fetchGroup.enter()
            AF.request(url)
                .validate()
                .responseDecodable(of: T.self) { (response) in
                    if let value = response.value {
                        items.append(value)
                    }
                    fetchGroup.leave()
                }
        }
        // 非同期処理完了後の処理
        fetchGroup.notify(queue: .main) { [weak self] in
            self?.listData = items
            self?.listTableView.reloadData()
        }
    }
    
    func fetchList() {
        guard let data = data else { return }
        switch data {
        case is Film:
            fetch(data.listItems, of: Starship.self)
        default:
            //
            print("Unkown type: ", String(describing: type(of: data)))
        }
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "starshipsCell", for: indexPath)
        // nameを表示
        var config = cell.defaultContentConfiguration()
        if let starship = listData[indexPath.row] as? Starship {
            config.text = starship.name
        }
        
        cell.contentConfiguration = config
        return cell
    }
    
    
}
