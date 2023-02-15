//
//  Menu.swift
//  Restraunt
//
//  Created by Aleksey Kosov on 15.02.2023.
//

import SwiftUI

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText = ""
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)])
    private var dishes: FetchedResults<Dish>
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
            VStack(alignment: .leading, spacing: 0.0) {
                Text("Little Lemon")
                    .foregroundColor(.yellow)
                    .font(.largeTitle)

                Text("Chicago")
                    .foregroundColor(.white)
                    .font(.title)
                HStack {
                    Text("We offer alcoholic beverages, desserts, main dish")
                        .foregroundColor(.white)
                    Image("restrauntImage")
                        .resizable()
                        .cornerRadius(16)
                        .frame(width: 150, height: 150)
                }

            }
            .padding()
            .background(Color("green"))
            TextField("Search menu", text: $searchText)
                .onChange(of: searchText) { _ in
                                   dishes.nsPredicate = buildPredicate()
                               }
                .padding()
                .foregroundColor(.white)
                .background(.gray.opacity(0.5))
                .cornerRadius(16)


            //                        FetchedObjects<Dish, List>(
            //                            predicate: buildPredicate(),
            //                            sortDescriptors: buildSortDescriptors(),
            //                            content: { dishes in
            List {
                ForEach(dishes, id: \.self) { dish in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(dish.title ?? "")
                                .font(.headline)
                            Text(dish.text ?? "")
                            Text("$\(dish.price ?? "")")
                                .font(.subheadline)

                        }
                        Spacer()
                        AsyncImage(url: URL(string: dish.image!)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: 70, maxHeight: 70)
                            case .failure:
                                Image(systemName: "photo")
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 70, height: 70)
                        .scaledToFit()
                        .padding()

                    }
                }
            }
        }





        .onAppear() {
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
        viewContext.reset()
        PersistenceController.shared.clearAllData()


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
