//
//  EventView.swift
//  eventEW
//
//  Created by Mac Mini on 22/11/2023.
//

import SwiftUI

struct EventView: View {
    @State private var events: [Event] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(events, id: \.id) { event in
                    EventCell(event : event)
                }
            }
            .navigationBarTitle("Events")
            .onAppear {
                getAllEvents()
            }
            
        }
        
        
    }
        
    
    func getAllEvents() {
        guard let url = URL(string: "http://localhost:3000/api/events/get-all-events") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // Assuming your response is an array of Post objects
                let events = try decoder.decode([Event].self, from: data)
                
                // Update the state variable to refresh the view
                DispatchQueue.main.async {
                    self.events = events
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView()
    }
}

