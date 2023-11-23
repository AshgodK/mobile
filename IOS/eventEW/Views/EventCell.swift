//
//  EventCell.swift
//  eventEW
//
//  Created by Mac Mini on 22/11/2023.
//



import SwiftUI
import UserNotifications
import CoreLocation
struct EventCell: View {
    @State private var isMenuVisible = false
    @State private var eventIDToUpdate: String?
    
   @State var event: Event
    var body: some View {
        
       
        VStack {
                    HStack {
                        
                        
                        
                        
                        Spacer()
                        Button {
                            isMenuVisible.toggle()
                        } label: {
                            Image(systemName: "ellipsis")
                                .imageScale(.large)
                        }
                        .foregroundColor(.green)
                        .padding(.trailing, 8)
                        .actionSheet(isPresented: $isMenuVisible) {
                            ActionSheet(title: Text(""), buttons: [
                                .destructive(Text("Delete Event"), action: {
                                    deleteEvent(eventID: event.id)
                                    print(event.id)
                                }),
                                .default(Text("Update Event"), action: {
                                    eventIDToUpdate = event.id
                                    print(event.id)
                                       navigateToUpdateEventView(eventID: event.id) }),
                                .cancel()
                            ])
                        }
                        
                    }
            .padding(.leading, 8)
            
            
                       
            Text(event.title)
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    .background(Color(red: 124/255, green: 200/255, blue: 162/255)).foregroundColor(.white)
            
            Image(event.image)
                .resizable()
                .scaledToFit()
                .frame(height: 400)
                .clipShape(Rectangle())
            
            
            
            .padding(.leading,8)
            .padding(.top,4)
            .foregroundColor(.green)
            
            
            
            HStack{
                Text(event.description).fontWeight(.semibold)
                Text(event.location)
                Text(event.date)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.footnote)
            .padding(.leading, 10)
            .padding(.top, 1)
            
            
        }
        
        
    }
    
}










                                         func navigateToUpdateEventView(eventID: String) {
                                             // Utilisez votre méthode de navigation préférée pour accéder à la page UpdatePostView
                                             // Assurez-vous d'avoir une vue correspondante pour UpdatePostView dans votre code.

                                             // Exemple avec NavigationLink :
                                             NavigationLink(destination: UpdateEventView(eventID: eventID)) {
                                                 EmptyView()
                                             }
                                             
                                         }

func deleteEvent(eventID: String) {
    guard let url = URL(string: "http://localhost:3000/api/events/delete-event") else {
        print("Invalid URL")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let parameters: [String: Any] = [
        "eventId": eventID
    ]
    
    guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
    
    else {
        print("Failed to serialize JSON data")
        return
    }
    
    request.httpBody = jsonData
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
            return
        }
        
        guard let response = response as? HTTPURLResponse else {
            print("Invalid response")
            return
        }
        
        if response.statusCode == 200 {
            // Post deleted successfully
            DispatchQueue.main.async {
                // Update your local data or UI if needed
            }
        } else {
            print("Failed to delete event. Status code: \(response.statusCode)")
        }
        if response.statusCode == 200 {
                   // Post deleted successfully
                   DispatchQueue.main.async {
                       SuccessDAlert()
                   }
               } else {
                   print("Failed to delete event. Status code: \(response.statusCode)")
               }
    }.resume()
}

func SuccessDAlert() {
    let alertController = UIAlertController(title: "Success", message: "Event Deleted successfully!", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
        // Add any additional actions or code to be executed when the user taps "OK"
    }
    alertController.addAction(okAction)
    
    // Make sure to present the alert on the main queue
    DispatchQueue.main.async {
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}





struct EventCell_Previews: PreviewProvider {
    static var previews: some View {
        // Create an instance of Post and pass it to PostCell
        let sampleEvent = Event(id: "123",
                                title: "testEvent",
                                description: "This is a test event",
                                organizer: "John Doe",
                                location: "Sample Location",
                                date: "2023-12-31",
                                image: "sample_image.jpg",
                                v: 0)

        return EventCell(event: sampleEvent)
    }
}



