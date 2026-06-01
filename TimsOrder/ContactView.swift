//
//  ContactView.swift
//  TimsOrder — Foodies Cafe
//
//  Created by Ahmad Wahidi
//  Course: MWD3A — iOS Development
//  Assignment 2
//
//  Shows the coffee bar's address, hours, email, and an interactive map.
//  A button at the bottom opens Apple Maps with the address pre-filled.
//
//  Concepts used:
//    - MapKit / Map view  → displays an interactive map in SwiftUI
//    - @State             → manages the map camera position
//    - UIApplication.open → opens another app (Apple Maps) from within our app
//    - Custom subviews    → InfoBlock keeps the layout clean and DRY
//

import SwiftUI
import MapKit

struct ContactView: View {

    // MARK: - Map Camera Position
    //
    // MapCameraPosition controls what the map is showing.
    // .region() lets us specify a centre coordinate and a zoom level.
    // MKCoordinateSpan controls zoom: smaller values = more zoomed in.

    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 43.4516, longitude: -80.4925),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // MARK: Interactive Map
                // Map() renders an interactive MapKit map inside a SwiftUI view
                Map(position: $cameraPosition)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 20) {

                    // MARK: Address
                    InfoBlock(
                        icon: "mappin.circle.fill",
                        title: "Address",
                        detail: "247 Roasters Street, Downtown\nWaterloo, ON"
                    )
                    Divider()

                    // MARK: Hours
                    InfoBlock(
                        icon: "clock.fill",
                        title: "Hours",
                        detail: "Mon–Fri: 6:30 AM – 7:00 PM\nSat–Sun: 7:00 AM – 8:00 PM"
                    )
                    Divider()

                    // MARK: Email
                    InfoBlock(
                        icon: "envelope.fill",
                        title: "Email",
                        detail: "hello@foodiescafe.com"
                    )
                    Divider()

                    // MARK: Coffee Classes
                    InfoBlock(
                        icon: "cup.and.saucer.fill",
                        title: "Coffee Classes",
                        detail: "Every Saturday at 10:00 AM & 2:00 PM"
                    )
                    Divider()

                    // MARK: Open in Maps Button
                    // Launches Apple Maps with the address as a search query
                    Button(action: openInMaps) {
                        Label("Open in Apple Maps", systemImage: "map.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("AccentColor"))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)

                Spacer(minLength: 32)
            }
            .padding(.top)
        }
        .navigationTitle("Find Us")
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Open Apple Maps
    //
    // Builds a maps:// URL with the address as a search query.
    // addingPercentEncoding replaces spaces and special characters
    // with URL-safe codes (e.g. space becomes %20).
    // UIApplication.shared.open() hands off to the Maps app.

    private func openInMaps() {
        let address = "247 Roasters Street, Waterloo, ON"
        let encoded = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "http://maps.apple.com/?q=\(encoded)") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Info Block
//
// A reusable row component showing an icon, a bold title, and detail text.
// Used for Address, Hours, Email, and Coffee Classes sections above.

struct InfoBlock: View {
    let icon: String    // SF Symbols icon name
    let title: String   // bold heading
    let detail: String  // body text (can span multiple lines with \n)

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Icon on the left (fixed 32pt wide for alignment)
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color("AccentColor"))
                .frame(width: 32)

            // Title and detail stacked vertically
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(detail)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack { ContactView() }
}
