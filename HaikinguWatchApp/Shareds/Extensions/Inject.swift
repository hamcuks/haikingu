//
//  Inject.swift
//  HaikinguApp
//
//  Created by I Gusti Ngurah Surya Ardika Dinataputra on 02/10/24.
//

import Foundation
import Swinject

@propertyWrapper
struct Inject<T> {
    private let container: Container
    private var storedValue: T?
    private var name: String?
    
    init(name: String? = nil, container: Container = Container.shared) {
        self.container = container
        self.storedValue = container.resolve(T.self, name: name)
        self.name = name
    }
    
    var wrappedValue: T {
        get {
            let resolved = storedValue ?? container.resolve(T.self, name: name)
            assert(resolved != nil, "Dependency not found: \(String(describing: T.self))")
            return resolved!
        }
        set {
            storedValue = newValue
        }
    }
}
