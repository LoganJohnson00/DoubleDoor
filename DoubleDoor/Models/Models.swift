import SwiftUI

// MARK: - Color Extension

extension Color {
    static let doubleDoorRed = Color(red: 0.91, green: 0.19, blue: 0.16)
}

// MARK: - Models

struct Friend: Identifiable {
    let id = UUID()
    let name: String
    let age: Int
    let relationship: String
    var isSelected: Bool = false

    var initials: String {
        let parts = name.split(separator: " ")
        return parts.compactMap { $0.first }.map(String.init).joined()
    }
}

struct UserProfile: Identifiable {
    let id = UUID()
    let name: String
    let age: Int
    let city: String
    let occupation: String
    let friends: [Friend]
    let cardColor: Color
    let avatarColor: Color
}

struct Message: Identifiable {
    let id = UUID()
    let sender: String
    let text: String
    let isCurrentUser: Bool
}

struct Venue: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let neighborhood: String
    let distance: String
    let deal: String?
    let isSponsored: Bool
}

// MARK: - Mock Data

extension UserProfile {
    static let mockProfiles: [UserProfile] = [
        UserProfile(
            name: "Alex",
            age: 28,
            city: "Brooklyn, NY",
            occupation: "Architect",
            friends: [
                Friend(name: "Jordan Lee", age: 27, relationship: "Best friend"),
                Friend(name: "Marcus Webb", age: 29, relationship: "Roommate"),
                Friend(name: "Priya Kapoor", age: 26, relationship: "Coworker"),
                Friend(name: "Sam Torres", age: 28, relationship: "College friend")
            ],
            cardColor: Color(red: 0.93, green: 0.87, blue: 0.80),
            avatarColor: Color(red: 0.85, green: 0.72, blue: 0.60)
        ),
        UserProfile(
            name: "Riley",
            age: 26,
            city: "Manhattan, NY",
            occupation: "Graphic Designer",
            friends: [
                Friend(name: "Casey Park", age: 25, relationship: "College roommate"),
                Friend(name: "Devon Shaw", age: 27, relationship: "Bestie"),
                Friend(name: "Nadia Kim", age: 26, relationship: "Coworker"),
                Friend(name: "Elliot Ray", age: 28, relationship: "Neighbor")
            ],
            cardColor: Color(red: 0.82, green: 0.88, blue: 0.84),
            avatarColor: Color(red: 0.60, green: 0.78, blue: 0.66)
        ),
        UserProfile(
            name: "Morgan",
            age: 29,
            city: "Williamsburg, NY",
            occupation: "Product Manager",
            friends: [
                Friend(name: "Taylor Wren", age: 28, relationship: "Your bestie"),
                Friend(name: "Avery Cole", age: 30, relationship: "Coworker"),
                Friend(name: "Jamie Fox", age: 27, relationship: "Gym buddy"),
                Friend(name: "Quinn Ash", age: 29, relationship: "High school friend")
            ],
            cardColor: Color(red: 0.82, green: 0.87, blue: 0.94),
            avatarColor: Color(red: 0.56, green: 0.72, blue: 0.90)
        )
    ]
}

extension Message {
    static let mockMessages: [Message] = [
        Message(sender: "Alex", text: "Hey everyone! So excited 🎉", isCurrentUser: false),
        Message(sender: "Jordan", text: "Same! Where should we go?", isCurrentUser: false),
        Message(sender: "You", text: "I was thinking coffee or a movie?", isCurrentUser: true),
        Message(sender: "Alex", text: "Coffee sounds perfect!", isCurrentUser: false)
    ]
}

extension Venue {
    static let mockVenues: [Venue] = [
        Venue(
            name: "Blue Bottle Coffee",
            emoji: "☕",
            neighborhood: "Williamsburg",
            distance: "0.4 mi",
            deal: "20% off for DoubleDoor groups",
            isSponsored: true
        ),
        Venue(
            name: "Nitehawk Cinema",
            emoji: "🎬",
            neighborhood: "Prospect Park",
            distance: "1.2 mi",
            deal: "4 tickets for the price of 3",
            isSponsored: true
        ),
        Venue(
            name: "Roberta's Pizza",
            emoji: "🍕",
            neighborhood: "Bushwick",
            distance: "2.1 mi",
            deal: nil,
            isSponsored: false
        )
    ]
}
