//
//  SelectCountryScreen.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 27.01.2022.
//

import SwiftUI

extension LoginScreenView {
    
    struct SelectCountryView: View {
        
        @Environment(\.presentationMode) private var presentationMode
        
        @State var countries: [Country]
        private var baseCountries: [Country]
        @State private var searchText: String = ""
        @Binding private var currentCountry: Country
        
        init(countries: [Country], current: Binding<Country>) {
            _countries = State(initialValue: countries)
            baseCountries = countries
            _currentCountry = current
        }
        
        var body: some View {
            NavigationView {
                List {
                    ForEach(countries) { country in
                        countryRowItem(country)
                    }
                }
                .navigationTitle("Select country")
                .navigationBarTitleDisplayMode(.large)
                .navigationBarItems(trailing: closeButton)
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onChange(of: searchText) { searchText in
                if !searchText.isEmpty {
                    countries = baseCountries.filter {
                        $0.name.lowercased().contains(searchText.lowercased()) ||
                        $0.phoneCode.contains(searchText)
                    }
                } else {
                    countries = baseCountries
                }
            }
        }
        
        private var closeButton: some View {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Close")
                    .foregroundColor(Color.accent)
                    .fontWeight(.semibold)
                
            }
        }
        
        private func countryRowItem(_ country: Country) -> some View {
            Button {
                currentCountry = country
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Image(country.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 0)
                    VStack(alignment: .leading) {
                        Text(country.name)
                        Text(country.phoneCode)
                            .font(.subheadline)
                    }
                    Spacer()
                    if country == currentCountry {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color.accent)
                    }
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.primary)
            }
        }
    }
}

struct SelectCountryScreen_Previews: PreviewProvider {

    @StateObject static var vm = LoginScreenView.ViewModel(resolver: getPreviewResolver())

    static var previews: some View {
        LoginScreenView.SelectCountryView(
            countries: PlistCountryDataService().countries,
            current: $vm.currentCountry)
    }
}
