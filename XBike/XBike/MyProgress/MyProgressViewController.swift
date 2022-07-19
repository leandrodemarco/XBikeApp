//
//  MyProgressViewController.swift
//  XBike
//
//  Created by Leandro.Demarco on 18/07/2022.
//

import UIKit

protocol MyProgressViewPresenter: AnyObject {
    func getAllRides() -> [RideModel]
}

class MyProgressViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let timeFormatter = XBikeTimeFormatter()

    var presenter: MyProgressViewPresenter?
    private let cellId = "RideCellIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        let nib = UINib(nibName: "RideCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView?.reloadData()
    }
}

extension MyProgressViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.getAllRides().count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RideCell
        if let model = presenter?.getAllRides()[indexPath.row] {
            cell.configureWithRideModel(model, timeFormatter: timeFormatter)
        }
        return cell
    }
}
