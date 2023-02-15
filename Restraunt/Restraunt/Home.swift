//
//  Home.swift
//  Restraunt
//
//  Created by Aleksey Kosov on 15.02.2023.
//

import SwiftUI

struct Home: View {
    var body: some View {
        TabView {
            Menu()
        }
        .navigationBarBackButtonHidden(true)
        .tabItem {
            Label("Menu", systemImage: "list.dash")
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
