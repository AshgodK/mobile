//
//  AddEventView.swift
//  eventEW
//
//  Created by Mac Mini on 23/11/2023.
//

import SwiftUI
import Combine
import UIKit

struct AddEventView: View {
    @State private var isScrolling = false
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var location: String = ""
    @State private var organizer: String = ""
    @State private var selectedImage: Image?
    @State private var selectedImageName: String?
    @State private var privacy: String = ""
    @State private var isRequesting = false
    @State private var eventDate: String = ""
    @State private var nonFormattedEventDate = Date()
    @State private var isImagePickerPresented = false
    @State private var isShowingImagePicker = false
    @State private var selectedImageURL: URL?
    private let addEventURL = URL(string: "http://localhost:3000/api/events/add-event")!
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Add Event")
                        .fontWeight(.medium)
                        .foregroundColor(Color.black)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 8)
                    
                    Spacer()
                }
                .frame(height: 45)
                .padding(.top, 100)
                .padding(.horizontal, 10)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        TextField("Enter event title", text: $title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .padding(.top, 16)
                    }
                    .padding(.top, 25)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    TextField("Event Description ?", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .padding(.top, 16)
                    
                    TextField("Event Location ?", text: $location)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .padding(.top, 16)
                    
                    TextField("Event organizer ?", text: $organizer)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .padding(.top, 16)
                    
                    DatePicker("Event Date", selection: $nonFormattedEventDate, in: Date()...)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white))
                        .padding(.horizontal)
                        .padding(.top, 16)
                    
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 1) {
                                HStack {
                                    Button(action: {
                                        isImagePickerPresented.toggle()
                                    }) {
                                        if let selectedImage = selectedImage {
                                                                selectedImage
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .frame(width: 40, height: 40)
                                                            }
                                        Image("camera")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                    }
                                    .frame(width: 38, height: 38)
                                    .background(RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white))
                                    .sheet(isPresented: $isImagePickerPresented) {
                                        ImagePicker(selectedImage: $selectedImage, selectedImageName: $selectedImageName, selectedImageURL: Binding.constant(nil)) // Add this line
                                    }
                                    
                                    Text("Add Photo")
                                        .fontWeight(.medium)
                                        .foregroundColor(Color.black)
                                        .minimumScaleFactor(0.5)
                                        .multilineTextAlignment(.leading)
                                        .frame(width: 72, height: 38)
                                }
                                .frame(width: 140, alignment: .leading)
                                .padding(.top, 28)
                            }
                        }
                        .padding()
                    }
                    
                    let event = Event(id: "",
                                      title: title,
                                      description: description,
                                      organizer: organizer,
                                      location: location,
                                      date: formatDate(nonFormattedEventDate),
                                      image: selectedImageName ?? "", // Corrected placement of ??
                                      v: 0)

                    
                    Button(action: {
                        addEvent(event: event)
                    }) {
                        HStack {
                            Text("Event")
                                .fontWeight(.medium)
                                .padding(.leading, 9)
                                .padding(.vertical, 6)
                                .foregroundColor(Color.white)
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.leading)
                                .background(RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.green))
                                .padding(.horizontal, 28)
                        }
                    }
                    .background(RoundedRectangle(cornerRadius: 4)
                        .fill(Color.green))
                    .padding(.horizontal, 28)
                }
                .padding(.horizontal, 16)
                
                .onAppear {
                    isScrolling = false
                }
                .onDisappear {
                    isScrolling = true
                }
            }
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Change this format based on your requirements
        return dateFormatter.string(from: date)
    }
    
    struct EventRequestBody: Encodable {
        let title: String
        let description: String
        let organizer: String
        let image: String
        let location: String
        let date: String
    }
    
    func addEvent(event: Event) {
        guard let url = URL(string: "http://localhost:3000/api/events/add-event") else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create a new dictionary to represent the request body
        let requestBody = EventRequestBody(title: event.title,
                                           description: event.description,
                                           organizer: event.organizer,
                                           image: event.image,
                                           location: event.location,
                                           date: event.date)
        
        do {
            let encodedRequestBody = try JSONEncoder().encode(requestBody)
            urlRequest.httpBody = encodedRequestBody
        } catch {
            print("Error encoding event data: \(error)")
            // Handle the event data encoding error (e.g., display an alert)
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 201 {
                showSuccessAlert()
            } else {
                print("Error posting event: \(error?.localizedDescription ?? "Unknown error")")
                //  display an alert
            }
        }.resume()
    }
    
    func showSuccessAlert() {
        let alertController = UIAlertController(title: "Success", message: "Event added successfully!", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            // Add any additional actions or code to be executed when the user taps "OK"
        }
        alertController.addAction(okAction)
        
        // Make sure to present the alert on the main queue
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    struct ImagePicker: UIViewControllerRepresentable {
        @Binding var selectedImage: Image?
        @Binding var selectedImageName: String?
        @Binding var selectedImageURL: URL?  // Add this line
        @Environment(\.presentationMode) var presentationMode
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
            var parent: ImagePicker
            
            init(_ parent: ImagePicker) {
                self.parent = parent
            }
            func saveImageToDocumentsDirectory(image: UIImage, imageName: String) -> String? {
                guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    return nil
                }

                let fileURL = documentsDirectory.appendingPathComponent(imageName)
                if let imageData = image.jpegData(compressionQuality: 1.0) {
                    do {
                        try imageData.write(to: fileURL)
                        return fileURL.path
                    } catch {
                        print("Error saving image data: \(error)")
                        return nil
                    }
                }
                return nil
            }

            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let uiImage = info[.originalImage] as? UIImage {
                    parent.selectedImage = Image(uiImage: uiImage)
                    parent.selectedImageURL = URL(fileURLWithPath: saveImageToDocumentsDirectory(image: uiImage, imageName: "dynamic_image.jpg") ?? "")
                    
                    // Get the image URL
                    if let imageUrl = info[.imageURL] as? URL {
                                    parent.selectedImageName = imageUrl.deletingPathExtension().lastPathComponent
                                }
                }
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView()
    }
}
