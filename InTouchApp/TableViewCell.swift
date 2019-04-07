//
//  TableViewCell.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 27/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell, ConversationCellonfiguration {
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool = false
    var hasUnreadMessage: Bool = false
    @IBOutlet weak var onlineStatusView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lastVisitDate: UILabel!

    private func rnd() -> CGFloat {
        return CGFloat.random(in: 0...100) / 100
    }

    func configureCell(name: String, message: String, date: Date?, online: Bool, hasUnreadmessage: Bool) {

        self.name = name
        self.message = message
        self.online = online
        self.profileImage.backgroundColor = UIColor(red: rnd(), green: rnd(), blue: rnd(), alpha: 1.00)
        self.profileImage.layer.cornerRadius = 22.5
        self.hasUnreadMessage = hasUnreadmessage
        self.date = date
        if let date = self.date {
            lastVisitDate.text = dateToString(from: date)
        }
        descriptionLabel.text = self.message
        onlineStatusView.layer.cornerRadius = 7
        titleLabel.text = name

        if self.message == "" {
            self.message = nil
            descriptionLabel.text = "No messages yet"
            self.descriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        }
        if self.online == true {
            self.onlineStatusView.backgroundColor = UIColor(red: 0.43, green: 1.00, blue: 0.75, alpha: 1.00)
            //Закоммитил, то что было по требованию(не нравится как выглядит), но понимаю как сделать)
            //backgroundColor = UIColor(red:1.00, green:1.00, blue:0.82, alpha:1.00)
        }
        if self.hasUnreadMessage == true {
            self.descriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        }
        if self.hasUnreadMessage == true && self.message == "" {
            self.prepareForReuse()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.onlineStatusView.backgroundColor = .clear
        self.descriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        self.backgroundColor = UIColor.white

    }

    private func dateToString(from date: Date) -> String {
        let calendar = NSCalendar.autoupdatingCurrent
        let components = calendar.dateComponents([.month, .day, .year], from: date, to: Date())
        let dateFormat = DateFormatter()
        if let day = components.day, let month = components.month, let year = components.year {
            if day + month + year > 0 {
                dateFormat.dateFormat = "dd MMM"
                return dateFormat.string(from: date)
            }
        }
        dateFormat.dateFormat = "HH:mm"
        return dateFormat.string(from: date)
    }
}
