import SwiftUI

struct MatchView: View {
    let matchedProfile: UserProfile
    let onDismiss: () -> Void
    let onFriendPicked: () -> Void

    @State private var showFriendPicker = false
    @State private var animateIn = false

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                // Top decorative area
                ZStack {
                    // Soft radial glow behind avatars
                    Circle()
                        .fill(Color.doubleDoorRed.opacity(0.08))
                        .frame(width: 220, height: 220)

                    // Overlapping avatars
                    HStack(spacing: -28) {
                        // Current user avatar
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.93, green: 0.87, blue: 0.80))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Circle()
                                        .strokeBorder(Color(.systemBackground), lineWidth: 4)
                                )
                            Text("You")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(red: 0.50, green: 0.38, blue: 0.28))
                        }
                        .shadow(color: .black.opacity(0.10), radius: 8, x: 0, y: 4)
                        .zIndex(1)

                        // Match avatar
                        ZStack {
                            Circle()
                                .fill(matchedProfile.avatarColor)
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Circle()
                                        .strokeBorder(Color(.systemBackground), lineWidth: 4)
                                )
                            Text(matchedProfile.name.prefix(1))
                                .font(.system(size: 32, weight: .bold, design: .serif))
                                .foregroundColor(.white)
                        }
                        .shadow(color: .black.opacity(0.10), radius: 8, x: 0, y: 4)
                        .zIndex(0)
                    }
                }
                .scaleEffect(animateIn ? 1.0 : 0.6)
                .opacity(animateIn ? 1.0 : 0.0)
                .padding(.top, 72)

                // Heart icon
                Image(systemName: "heart.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.doubleDoorRed)
                    .padding(.top, 24)
                    .scaleEffect(animateIn ? 1.0 : 0.4)
                    .opacity(animateIn ? 1.0 : 0.0)

                // Match headline
                VStack(spacing: 10) {
                    Text("It's a Match!")
                        .font(.system(size: 38, weight: .bold, design: .serif))
                        .foregroundColor(.primary)

                    Text("YOU & \(matchedProfile.name.uppercased()) LIKED EACH OTHER")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                        .tracking(1.2)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 22)
                .opacity(animateIn ? 1.0 : 0.0)

                Spacer()

                // Friend picker section
                VStack(spacing: 16) {
                    VStack(spacing: 6) {
                        Text("Now make it a double date.")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.primary)
                        Text("Pick a friend to join you both.")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }

                    // Friend preview chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(matchedProfile.friends.prefix(3)) { friend in
                                HStack(spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(.systemGray5))
                                            .frame(width: 28, height: 28)
                                        Text(friend.initials)
                                            .font(.system(size: 10, weight: .semibold))
                                            .foregroundColor(.primary)
                                    }
                                    Text(friend.name.split(separator: " ").first.map(String.init) ?? friend.name)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.primary)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(.systemGray6))
                                .clipShape(Capsule())
                            }
                        }
                        .padding(.horizontal, 24)
                    }

                    // Choose friend button
                    Button(action: { showFriendPicker = true }) {
                        HStack(spacing: 8) {
                            Text("Choose a Friend")
                                .font(.system(size: 16, weight: .semibold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.doubleDoorRed)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal, 24)
                }
                .opacity(animateIn ? 1.0 : 0.0)
                .padding(.bottom, 16)

                // Dismiss
                Button(action: onDismiss) {
                    Text("Keep Swiping")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 44)
                .opacity(animateIn ? 1.0 : 0.0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.72)) {
                animateIn = true
            }
        }
        .sheet(isPresented: $showFriendPicker) {
            FriendPickerView(
                friends: matchedProfile.friends,
                onFriendPicked: {
                    showFriendPicker = false
                    onFriendPicked()
                }
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Preview

#Preview {
    MatchView(
        matchedProfile: UserProfile.mockProfiles[0],
        onDismiss: {},
        onFriendPicked: {}
    )
}
