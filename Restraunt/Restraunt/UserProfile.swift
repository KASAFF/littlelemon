//
//  UserProfile.swift
//  Restraunt
//
//  Created by Aleksey Kosov on 15.02.2023.
//

import SwiftUI

struct UserProfile: View {
    let firstName = UserDefaults.standard.string(forKey: kFirstName)
    let lastName = UserDefaults.standard.string(forKey: kLastName)
    let email = UserDefaults.standard.string(forKey: kEmail)
    @Environment(\.presentationMode) var presentation
    var body: some View {
        VStack {
            HStack (alignment: .center) {
                Spacer()
                Image("logo")
                    .resizable()
                    .frame(width: 160, height: 60, alignment: .trailing)
                    .padding()
                Spacer()
                Image("profile-image-placeholder")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .trailing)
                    .padding(.trailing)
            }
            Text("Personal information")
            Image("profile-image-placeholder")
                .resizable()
                .frame(width: 125, height: 125)
            Text(firstName ?? "")
            Text(lastName ?? "")
            Text(email ?? "")
            Button("Logout") {
                UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                self.presentation.wrappedValue.dismiss()
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(16)
            Spacer()
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}
