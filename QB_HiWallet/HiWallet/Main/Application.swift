//
//  Application.swift
//  TOP
//
//  Created by Jax on 13.07.18.
//  Copyright © 2018 TOP. All rights reserved.
//

import UIKit

class Application: UIApplication {
    private let dependencePrivader: ApplicationDependenceProvider
    
    override init() {
        dependencePrivader = ApplicationDependenceProvider()
        dependencePrivader.loadDependences()
    }
}
