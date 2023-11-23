//
//  ContentView.swift
//  eventEW
//
//  Created by Mac Mini on 22/11/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
                    VStack {
                        NavigationLink(destination: AddEventView()) {
                            Text("Ajouter un event")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                        
                        NavigationLink(destination: EventView()) {
                            Text("Voir les events")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                        
                        // Autres contenus de votre ContentView
                        
                    }
            
                    .navigationTitle("Contenu de votre vue")
                    .onAppear {
                        
                    }
                }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
