//
//  EditView.swift
//  BucketList
//
//  Created by Héctor Manuel Sandoval Landázuri on 25/10/23.
//

import SwiftUI

struct EditView: View {
    @StateObject private var editVM: EditViewModel
    
    @Environment(\.dismiss) var dismiss
    var onSave: (Location) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $editVM.name)
                    TextField("Description", text: $editVM.description)
                }
                Section("Nearby…") {
                    switch editVM.loadingState {
                    case .loaded:
                        ForEach(editVM.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                               .italic()
                        }
                    case .loading:
                        Text("Loading…")
                    case .failed:
                        Text("Please try again later.")
                    }
                }

                        
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    let newLocation = editVM.editLocation()
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await editVM.fetchNearbyPlaces()
            }
        }
    }

    init(location:Location, onSave: @escaping(Location) -> Void) {
        self.onSave = onSave
        _editVM = StateObject(wrappedValue: EditViewModel(location: location))
    }

    
}


#Preview {
    EditView(location:Location.example) { newLocation in }
}
