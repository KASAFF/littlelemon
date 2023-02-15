//
//  Menu.swift
//  Restraunt
//
//  Created by Aleksey Kosov on 15.02.2023.
//

import SwiftUI

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)])
    private var dishes: FetchedResults<Dish> 
   @State private var searchText = ""
    var body: some View {
        VStack {
            Text("Little Lemon Restraunt")
            Text("Chicago")
            Text("We offer alcoholic beverages, desserts, main dish")
            TextField("Search menu", text: $searchText)
                .onChange(of: searchText) { _ in
                    dishes.nsPredicate = buildPredicate()
                }
                .padding()
            List {
                ForEach(dishes, id: \.self) { dish in
                    VStack {
                        HStack {
                            Text(dish.title ?? "")
                            Text("\(dish.price ?? "")$")
                            AsyncImage(url: URL(string: dish.image!)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: 100, maxHeight: 100)
                                case .failure:
                                    Image(systemName: "photo")
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(width: 200, height: 200)
                            .scaledToFit()

                        }
                        Text(dish.text ?? "")
                    }
                }
            }
        }
        .onAppear {
            getMenuData()
        }
    }

    private func buildPredicate() -> NSPredicate {
        if searchText.isEmpty { return NSPredicate(value: true) }
        return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
    }

    private func buildSortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare))]
    }




    private func getMenuData() {
        PersistenceController.shared.clear()
        let urlString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else { return }
            if let data = data {
                let items = try? JSONDecoder().decode(MenuList.self, from: data)
                items?.menu.forEach({ item in
                    let dish = Dish(context: viewContext)
                    dish.title = item.title
                    dish.price = item.price
                    dish.image = item.image
                    dish.text = item.description
                })
                try? viewContext.save()

            }
        }.resume()
    }
}


struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
