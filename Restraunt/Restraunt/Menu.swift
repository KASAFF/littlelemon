//
//  Menu.swift
//  Restraunt
//
//  Created by Aleksey Kosov on 15.02.2023.
//

import SwiftUI

struct Menu: View {
    var body: some View {
        VStack {
            Text("Little Lemon Restraunt")
            Text("Chicago")
            Text("We offer alcoholic beverages, desserts, main dish")
            List {
                
            }
        }
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
