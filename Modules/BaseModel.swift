//
//  BaseModel.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 07.02.2022.
//

import SwiftUI
import Swinject

protocol BaseModel: ObservableObject {}

protocol BaseView: View {
    init(resolver: Resolver)
}
