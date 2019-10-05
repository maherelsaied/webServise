//
//  extintionString.swift
//  WebService
//
//  Created by Maher on 10/2/19.
//  Copyright © 2019 Maher. All rights reserved.
//

import Foundation

extension String {
    var trimed : String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
