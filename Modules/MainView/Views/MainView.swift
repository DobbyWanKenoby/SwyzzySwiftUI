//
//  MainView.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 10.02.2022.
//

import SwiftUI
import Swinject

struct MainView: View {
    
    private var resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    var body: some View {
        TabView {
            OwnWishesView(resolver: resolver)
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("List")
                    }
                }
            Text("Add wishes")
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("Add wishes")
                    }
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(resolver: getPreviewResolver())
    }
}
