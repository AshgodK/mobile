//
//  UpdateEventView.swift
//  eventEW
//
//  Created by Mac Mini on 22/11/2023.
//



import SwiftUI



struct UpdateEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var updatedTitle = ""
    @State private var updatedDescription = ""
    @State private var updatedImage = ""
    @State private var updatedLocation = ""
    @State private var showAlert = false
    @State private var isShowingImagePicker = false

    var eventID: String
    
    var body: some View {
        VStack {
            TextField("Title", text: $updatedTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Description", text: $updatedDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button(action: {
                    isShowingImagePicker = true
                }) {
                    Image("camera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                .frame(width: 38, height: 38)
                .background(RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white))
                
                Text("Add Photo")
                    .fontWeight(.medium)
                    .foregroundColor(Color.black)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.leading)
                    .frame(width: 72, height: 38)
            }
            .frame(width: 140, alignment: .leading)
            .padding(.top, 28)
            
            TextField("Location", text: $updatedLocation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: updateEvent) {
                Text("Update")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .padding()
        .navigationBarTitle("Update Event")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Update Successful"), message: Text("Event updated successfully"), dismissButton: .default(Text("OK")) {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    func updateEvent() {
        // Prepare the payload to send to the server
        let payload: [String: Any] = [
            "eventId": eventID,
            "payload": [
                "title": updatedTitle,
                "desc": updatedDescription,
                "image": updatedImage,
                "location": updatedLocation
            ]
        ]
        
        // Create a URLRequest with the endpoint URL
        guard let url = URL(string: "http://localhost:3000/api/events/edit-event") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set the request body data as JSON
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }
        
        // Send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
                // Handle the success response here
                
                // Present the success alert on the main thread
                DispatchQueue.main.async {
                    showAlert = true
                }
            }
        }.resume()
    }
    
}

struct UpdateEventView_Previews: PreviewProvider {
    static var previews: some View {
        // Create an instance of Event and pass it to EventCell
        return UpdateEventView(eventID: "1223")
    }
}

