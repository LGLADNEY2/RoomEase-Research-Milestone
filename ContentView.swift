import SwiftUI

struct InventoryItem: Identifiable {
    var id = UUID()
    var name: String
    var category: String
    var quantity: Int
}

// Determine the stock status
func stockStatus(_ quantity: Int) -> String {
    if quantity == 0 {
        return "Out of Stock, Order Now"
    } else if quantity == 1 {
        return "Low Stock, Order More Soon"
    } else {
        return "In Stock"
    }
}

// Color of stock status
func stockColor(_ quantity: Int) -> Color {
    if quantity == 0 {
        return .red
    } else if quantity == 1 {
        return .orange
    } else {
        return .green
    }
}

struct ContentView: View {
    @State private var itemName = ""
    @State private var itemCategory = "Kitchen"
    @State private var itemQuantity = 1
    
    // Inventory list
    @State private var items: [InventoryItem] = []
    
    var body: some View {
        NavigationStack {
            List {
                // Adding a new item
                Section("Add an Item") {
                    TextField("Item name", text: $itemName)
                    
                    Picker("Category", selection: $itemCategory) {
                        Text("Kitchen").tag("Kitchen")
                        Text("Bathroom").tag("Bathroom")
                        Text("Cleaning").tag("Cleaning")
                        Text("Pantry").tag("Pantry")
                    }
                    
                    Stepper(
                        "Quantity: \(itemQuantity)",
                        value: $itemQuantity,
                        in: 0...999
                    )
                    
                    Button("Add Item") {
                        addItem()
                    }
                }
                
                // Inventory display list
                Section("Household Inventory") {
                    if items.isEmpty {
                        Text("No items added yet.")
                    }
                    
                    ForEach($items) { $item in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.name)
                                .font(.headline)
                            
                            Text(item.category)
                                .foregroundColor(.gray)
                            
                            Text(stockStatus(item.quantity))
                                .foregroundColor(
                                    stockColor(item.quantity)
                                )
                            
                            Stepper(
                                "Quantity: \(item.quantity)",
                                value: $item.quantity,
                                in: 0...999
                            )
                        }
                        .padding(.vertical, 5)
                    }
                    .onDelete(perform: deleteItem)
                }
            }
            .navigationTitle("RoomEase Inventory Tracker")
        }
    }
    
    // Add a new item
    func addItem() {
        let name = itemName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        if name != "" {
            let newItem = InventoryItem(
                name: name,
                category: itemCategory,
                quantity: itemQuantity
            )
            
            items.append(newItem)
            
            // Clear the form
            itemName = ""
            itemCategory = "Kitchen"
            itemQuantity = 1
        }
    }
    
    // Delete an item
    func deleteItem(at positions: IndexSet) {
        items.remove(atOffsets: positions)
    }
}
