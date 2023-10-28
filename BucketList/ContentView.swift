//
//  ContentView.swift
//  BucketList
//
//  Created by Héctor Manuel Sandoval Landázuri on 25/10/23.
//

import SwiftUI
import MapKit
import LocalAuthentication

//Primer ejemplo
//struct User: Identifiable, Comparable {
//    let id = UUID()
//    let firstName: String
//    let lastName: String
//
//    static func <(lhs: User, rhs: User) -> Bool {
//            lhs.lastName < rhs.lastName
//        }
//    }
//
//struct ContentView: View {
//    let users = [
//        User(firstName: "Arnold", lastName: "Rimmer"),
//        User(firstName: "Kristine", lastName: "Kochanski"),
//        User(firstName: "David", lastName: "Lister"),
//    ].sorted()
//    
//    var body: some View {
//        List(users) { user in
//            Text("\(user.lastName), \(user.firstName)")
//        }
//    }
//    
    
//}

//Segundo ejemplo
//struct ContentView: View {
//    var body: some View {
//        Text("Hello World")
//            .onTapGesture {
//                let str = "Test Message"
//                let url = getDocumentsDirectory().appendingPathComponent("message.txt")
//
//                do {
//                    try str.write(to: url, atomically: true, encoding: .utf8)
//                    let input = try String(contentsOf: url)
//                    print(input)
//                } catch {
//                    print(error.localizedDescription)
//                }
//        }
//    }
//    func getDocumentsDirectory() -> URL {
//    // find all possible documents directories for this user
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//    
//        // just send back the first one, which ought to be the only one
//        return paths[0]
//    }
//
//}

//Tercer ejemplo
//enum LoadingState {
//    case loading, success, failed
//}
//
//struct LoadingView: View {
//    var body: some View {
//        Text("Loading...")
//    }
//}
//
//struct SuccessView: View {
//    var body: some View {
//        Text("Success!")
//    }
//}
//
//struct FailedView: View {
//    var body: some View {
//        Text("Failed.")
//    }
//}
//
//
//struct ContentView: View {
//    var loadingState = LoadingState.success
//    var body: some View {
//        if loadingState == .loading {
//            LoadingView()
//        } else if loadingState == .success {
//            SuccessView()
//        } else if loadingState == .failed {
//            FailedView()
//        }
//    }
//}

//struct Location: Identifiable {
//    let id = UUID()
//    let name: String
//    let coordinate: CLLocationCoordinate2D
//}
//
//let locations = [
//    Location(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
//    Location(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
//]
//
//struct ContentView: View {
//    @State private var mapRegion = MapCameraPosition.region( MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)))
//    var body: some View {
//        NavigationView {
//            Map(position: $mapRegion) {
//                ForEach(locations) { location in
//    //                Marker(location.name, coordinate: location.coordinate)
//    //                    .tint(.orange)
//                    Annotation(location.name, coordinate: location.coordinate) {
//                            Circle()
//                                .stroke(.red, lineWidth: 3)
//                                .frame(width: 44, height: 44)
//                                .onTapGesture {
//                                    print("Tapped on \(location.name)")
//                                }
//                        }
//                }
//
//            }
//            .navigationTitle("London Explorer")
//        }
//    }
//}

//Cuarto ejemplo
//struct ContentView: View {
//    @State private var isUnlocked = false
//    
//    var body: some View {
//        VStack {
//            if isUnlocked {
//                Text("Unlocked")
//            } else {
//                Text("Locked")
//            }
//        }
//        .onAppear(perform: authenticate)
//    }
//    
//    func authenticate() {
//        let context = LAContext()
//        var error: NSError?
//
//        // check whether biometric authentication is possible
//        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            // it's possible, so go ahead and use it
//            let reason = "We need to unlock your data."
//
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
//                // authentication has now completed
//                if success {
//                    // authenticated successfully
//                    isUnlocked = true
//                } else {
//                    // there was a problem
//                }
//            }
//        } else {
//            // no biometrics
//        }
//    }
//}

//App
struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.isUnlocked {
            Map(position: $viewModel.mapRegion) {
                ForEach(viewModel.locations) { location in
//                    Marker(location.name,coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
//                        .tint(.orange)
                    
                    Annotation(location.name, coordinate: location.coordinate) {
                        Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(Circle())
                                .onTapGesture {
                                    viewModel.selectedPlace = location
                                }
                    }

                }
            }
            .ignoresSafeArea()
            .onMapCameraChange { mapCameraUpdateContext in
                viewModel.mapRegion = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: mapCameraUpdateContext.camera.centerCoordinate.latitude, longitude: mapCameraUpdateContext.camera.centerCoordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25)))
                }
            Circle()
                .fill(.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        viewModel.addLocation()
                    } label: {
                        Image(systemName: "plus")
                            .padding()
                            .background(.black.opacity(0.75))
                            .foregroundColor(.white)
                            .font(.title)
                            .clipShape(Circle())
                            .padding(.trailing)
                    }
                }
            }
            .sheet(item: $viewModel.selectedPlace) { place in
                EditView(location: place) { viewModel.update(location: $0)
                }
            }
        } else {
            Button("Unlock Places") {
                viewModel.authenticate()
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .alert("Authenticate error", isPresented: $viewModel.presentAlert ) {
                Button("OK", role: .cancel) { }
            }
        }
            
        }
    }
}


#Preview {
    ContentView()
}
