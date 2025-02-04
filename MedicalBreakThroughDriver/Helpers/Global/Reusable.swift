//
//  Reusable.swift
//  Done_Lite
//
//  Created by Denish Gediya on 16/10/23.
//

import Foundation

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

typealias NibReusable = Reusable & NibLoadable
