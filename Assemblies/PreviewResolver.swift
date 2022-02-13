//
//  MockResolver.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 26.01.2022.
//

import Foundation
import Swinject

func getPreviewResolver() -> Resolver {
    Assembler([
        BaseAssembly()
    ]).resolver
}
