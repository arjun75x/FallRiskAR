//
//  Global.swift
//  FallRiskAR
//
//  Created by Arjun Arun on 12/1/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

class Main {
    var risks : [Risk]
    
    init() {
        self.risks = [Risk]()
    }
    
    func add(risk : Risk) {
        risks.append(risk)
    }
}

var mainInstance = Main()
