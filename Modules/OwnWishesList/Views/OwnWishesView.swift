//
//  OwnWishesView.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 10.02.2022.
//

import SwiftUI
import Swinject

struct OwnWishesView: View {
    
    private var resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    var body: some View {
        NavigationView {
            Form {
                
            }
            .navigationBarTitle("My wishes")
                .toolbar {
                    ToolbarItem {
                        NavigationLink {
                            SettingsView(resolver: resolver)
                        } label: {
                            Image(systemName: "person.circle.fill")
                        }

                    }
                }
        }
    }
}

struct OwnWishesView_Previews: PreviewProvider {
    static var previews: some View {
        OwnWishesView(resolver: getPreviewResolver())
    }
}
