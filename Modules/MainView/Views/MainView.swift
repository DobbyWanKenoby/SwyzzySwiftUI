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
            feedView
            friendsView
            addWishView
            myWishesView
            calendarView
        }
    }
    
    private var myWishesView: some View {
        OwnWishesView(resolver: resolver)
            .tabItem {
                VStack {
                    Image(systemName: "gift.fill")
                    Text("My wishes")
                }
            }
    }
    
    private var feedView: some View {
        Text("Add wishes")
            .tabItem {
                VStack {
                    Image(systemName: "list.bullet")
                    Text("Feed")
                }
            }
    }
    
    private var addWishView: some View {
        NavigationView {
            AddWishView(resolver: resolver)
                .navigationTitle("Add wish")
        }
        .tabItem {
            VStack {
                Image(systemName: "plus.app.fill")
                Text("Create wish")
            }
        }
            
    }
    
    private var friendsView: some View {
        Text("Add wish")
            .tabItem {
                VStack {
                    Image(systemName: "person.3.fill")
                    Text("Friends")
                }
            }
    }
    
    private var calendarView: some View {
        Text("Add wish")
            .tabItem {
                VStack {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            }
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(resolver: getPreviewResolver())
    }
}
