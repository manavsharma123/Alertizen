//
//  OTExtensionString.swift
//  Raj
//
//  Created by Raj on 10/11/16.
//  Copyright © 2016 Raj. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func Trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
