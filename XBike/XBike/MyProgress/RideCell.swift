//
//  RideCell.swift
//  XBike
//
//  Created by Leandro.Demarco on 18/07/2022.
//

import UIKit

class RideCell: UITableViewCell {

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var startPointLabel: UILabel!
    @IBOutlet weak var endPointLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureWithRideModel(_ rideModel: RideModel, timeFormatter: XBikeTimeFormatter) {
        durationLabel.text = timeFormatter.formatTime(Double(rideModel.durationInSeconds))
        distanceLabel.text = "\(rideModel.distanceInMeters)"
        startPointLabel.text = rideModel.startAddress
        endPointLabel.text = rideModel.endAddress
    }
}
