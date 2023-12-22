//
//  UserModel.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 5/29/22.
//

import Foundation
import SwiftUI

struct User {
    static let instance = User()
    
    @AppStorage("first_name") var first_name: String = ""
    @AppStorage("last_name") var last_name: String = ""
    @AppStorage("is_initialized") var is_initialized: Bool = false
    var name: String { first_name + " " + last_name }
    @AppStorage("haptics_on") var haptics_on: Bool = true
}
