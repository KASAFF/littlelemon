//
//  JSONMenu.swift
//  Restraunt
//
//  Created by Aleksey Kosov on 15.02.2023.
//

struct JSONMenu: Codable {
    let menu: [MenuItem]
}


struct MenuItem: Codable {
    let name: String
    let price: Float
    let description: String
    let image: String
} 
