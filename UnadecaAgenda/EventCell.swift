//
//  EventCell.swift
//  UnadecaAgenda
//
//  Created by ISC Devolpers on 27/1/21.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var DateLabel: UITextField!
    @IBOutlet weak var EventTitle: UILabel!
    
    func setEvent(title: String, date: String) {
        DateLabel.text = date
        EventTitle.text = title
    }
    

}
