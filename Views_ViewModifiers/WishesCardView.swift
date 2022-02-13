//
//  WishesCardView.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 12.02.2022.
//

import SwiftUI

struct WishesCardView: View {
    
    @ObservedObject private var vm: ViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(uiImage: vm.user.image)
                    .resizable()
                    
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)
                    .shadow(color: .black, radius: 1)
                Text("\(vm.user.firstname) \(vm.user.lastname)")
                    .font(.headline)
            }
            VStack {
                Image(uiImage: vm.wish.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    
                    
                
            }
            .shadow(color: .black, radius: 1)
//            HStack(spacing: 5) {
//                Image(systemName: "gift.fill")
//                Text("Wants to \(vm.event!.title)")
//
//            }
            .font(.subheadline)
        }
    }
    
    init(wish: Wish) {
        vm = ViewModel(wish: wish)
    }
}

extension WishesCardView {
    @MainActor
    class ViewModel: ObservableObject {
        @Published var wish: Wish
        @Published var user: User
        var event: Event? = nil
        
        init(wish: Wish) {
            self.wish = wish
            self.user = wish.user!
        }
    }
}

struct WishesCardView_Previews: PreviewProvider {
    
    static var wish: Wish {
        let wish = Wish(id: UUID().uuidString, description: "My best way", create_at: Date())
        let user = User(id: UUID().uuidString, firstname: "Jason", lastname: "Statham Jr.", birthday: Date())
        wish.assign(user: user)
        return wish
    }
    
    
//    static var event = Event(title: "My birthday", date: Date(), owner: "222")
    
    static var previews: some View {
        WishesCardView(wish: Self.wish)
//            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
    }
}
