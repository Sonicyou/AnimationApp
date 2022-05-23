//
//  SkeletonViewController.swift
//  AnimationApp
//
//  Created by Artem Frolov on 23.05.2022.
//

import UIKit
import SkeletonView

class SkeletonViewController: UIViewController, SkeletonTableViewDataSource {

    let skeletonTableView = UITableView()

    var data = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(skeletonTableView)

        skeletonTableView.rowHeight = 100
        skeletonTableView.estimatedRowHeight = 100
        skeletonTableView.dataSource = self

        skeletonTableView.register(SkeletonTableViewCell.self, forCellReuseIdentifier: "cell")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            for _ in 0..<10 {
                self.data.append("You should always wear your mask, covid-19 is everythere")
            }

            self.skeletonTableView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))

            self.skeletonTableView.reloadData()
        })
        
        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        skeletonTableView.isSkeletonable = true
        skeletonTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .link),
                                                       animation: nil,
                                                       transition: .crossDissolve(0.5))
    }

    private func setupLayout() {
        skeletonTableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "cell"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)  as! SkeletonTableViewCell
        if !data.isEmpty {
            cell.label.text = data[indexPath.row]
            cell.image.image = UIImage.init(systemName: "facemask.fill")
        }
        return cell
    }
}
