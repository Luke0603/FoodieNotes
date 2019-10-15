//
//  CurrentUser.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/10/14.
//  Copyright © 2019 Luke. All rights reserved.
//

import Foundation
import UIKit

class CurrentUser {
    
    static let shared: CurrentUser = CurrentUser()
    
    var user: User?
}
