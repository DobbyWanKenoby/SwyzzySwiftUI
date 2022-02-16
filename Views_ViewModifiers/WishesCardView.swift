//
//  WishesCardView.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 12.02.2022.
//

import SwiftUI
import UIKit

struct WishesCardView: View {
    
    @ObservedObject private var vm: ViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(uiImage: vm.userimage)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)
                VStack(alignment: .leading) {
                    Text("\(vm.username)")
                        .font(.headline)
                    Text("\(vm.createDateString)")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                }
            }
            HStack(spacing: 5) {
                Button {
                    
                } label: {
                    Label("Wants to \(vm.eventTitle)", systemImage: "gift.fill")
                }
            }
            .font(.subheadline)
            Image(uiImage: vm.wishimage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
        }
    }
    
    init(wish: Wish) {
        vm = ViewModel(wish: wish)
    }
}

extension WishesCardView {
    @MainActor
    class ViewModel: ObservableObject {
//        private var wish: Wish
        var createDate: Date = Date()
        var createDateString = "1 day ago"
        var username: String = "John Malkovich"
        @Published var userimage: UIImage = UIImage(named: "testUser")!
        @Published var wishimage: UIImage = UIImage(named: "testWish")!
        var eventTitle: String = "My birthsday"
        var eventDate: Date = Date()

        init(wish: Wish) {
//            self.wish = wish
//            //self.username = "\(wish.user.firstname) \(wish.user.lastname)"
//            self.userimage = wish.user.image
//            self.wishimage = wish.image
//            self.createDate = wish.create_at
        }
    }
}

struct WishesCardView_Previews: PreviewProvider {
    
    static var wish: Wish {
        let user = User(id: UUID().uuidString, firstname: "Jason", lastname: "Statham Jr.", birthday: Date())
        let wish = Wish(resolver: getPreviewResolver(), description: "My best way", createDate: Date(), user: user)
        user.assign(wishes: [wish])
        return wish
    }
    
    static var previews: some View {
        WishesCardView(wish: Self.wish)
//            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
    }
}
