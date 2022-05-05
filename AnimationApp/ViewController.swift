//
//  ViewController.swift
//  AnimationsApp
//
//  Created by Artem Frolov on 10.04.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    typealias Item = (title: String, viewController: UIViewController.Type)

    var items: [Item] {
        return [
            ("Spinner", SpinnerViewController.self),
            ("More", UIViewController.self),
            ("More", UIViewController.self),
            ("More", UIViewController.self)
        ]
    }

    let tableView = UITableView()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupLayout()
    }

    func setupAppearance() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "Objects"
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    func setupLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(items[indexPath.row].title)
        let vc = items[indexPath.row].viewController.init()
        vc.view.backgroundColor = .white
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        return cell
    }
}
