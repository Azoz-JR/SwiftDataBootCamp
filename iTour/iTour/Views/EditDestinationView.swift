//
//  EditDestinationView.swift
//  iTour
//
//  Created by Azoz Salah on 15/02/2024.
//

import PhotosUI
import SwiftUI
import SwiftData


struct EditDestinationView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var destination: Destination
    @State private var newSightName = ""
    @State private var selectedImage: PhotosPickerItem?
    
    var body: some View {
        Form {
            Section {
                if let imageData = destination.photo, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .clipShape(.rect(cornerRadius: 10))
                }
                
                PhotosPicker(selection: $selectedImage, matching: .images) {
                    Label("Select a photo", systemImage: "person")
                }
            }
            
            Section {
                TextField("Name", text: $destination.name)
                TextField("Details", text: $destination.details, axis: .vertical)
                DatePicker("Date", selection: $destination.date)
            }
            
            Section("Priority") {
                Picker("Priority", selection: $destination.priority) {
                    Text("Meh").tag(1)
                    Text("Maybe").tag(2)
                    Text("Must").tag(3)
                }
                .pickerStyle(.segmented)
            }
            
            Section("Sights") {
                ForEach(destination.sights) { sight in
                    Text(sight.name)
                }
                .onDelete(perform: deleteSight)
                
                HStack {
                    TextField("Add a new sight to \(destination.name)", text: $newSightName)
                    
                    Button("Add", action: addSight)
                        .disabled(newSightName.isEmpty)
                }
            }
        }
        .navigationTitle("Edit Destination")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: selectedImage, loadPhoto)
        .scrollDismissesKeyboard(.interactively)
    }
    
    func addSight() {
        guard newSightName.isEmpty == false else { return }
        
        withAnimation {
            let newSight = Sight(name: newSightName)
            destination.sights.append(newSight)
            newSightName = ""
        }
    }
    
    func deleteSight(at indexSet: IndexSet) {
        for index in indexSet {
            withAnimation {
                let sight = destination.sights.remove(at: index)
                modelContext.delete(sight)
            }
        }
    }
    
    func loadPhoto() {
        Task { @MainActor in
            destination.photo = try await selectedImage?.loadTransferable(type: Data.self)
        }
    }
    
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Destination.self, configurations: config)
        
        let alex = Destination(name: "Alexandria", details: "Alex Alex Alex Alex Alex Alex Alex Alex Alex Alex Alex Alex Alex")
        
        return NavigationStack {
            EditDestinationView(destination: alex)
                .modelContainer(container)
        }
    } catch {
        fatalError("Failed to create model container.")
    }
    
    
}
