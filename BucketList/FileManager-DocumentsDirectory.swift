//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Héctor Manuel Sandoval Landázuri on 27/10/23.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
