//
//  CharacterSet+Character.swift
//  Flexer
//
//  Created by Matt Massicotte on 2020-04-24.
//  Copyright © 2020 Chime Systems Inc. All rights reserved.
//

import Foundation

public extension CharacterSet {
    func contains(_ character: Character) -> Bool {
        return character.unicodeScalars.allSatisfy({ self.contains($0) })
    }
}
