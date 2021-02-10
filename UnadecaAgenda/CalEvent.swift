//
//  CalEvent.swift
//  UnadecaAgenda
//
//  Created by ISC Devolpers on 27/1/21.
//

import Foundation

struct CalEvent: Codable {
    var id:Int
    var init_date:String
    var end_date:String
    var title:String 
    var description:String?
}
