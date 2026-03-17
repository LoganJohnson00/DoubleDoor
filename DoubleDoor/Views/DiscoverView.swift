import SwiftUI

struct DiscoverView: View {
    @State private var profiles: [UserProfile] = UserProfile.mockProfiles
    @State private var topCardOffset: CGSize = .zero
    @State private var currentIndex: Int = 0
    @State private var showMatch: Bool = false
    @State private var rotation: Double = 0

    private let swipeThreshold: CGFloat = 100

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                headerView
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .padding(.bottom, 20)

                // Card stack
                ZStack {
                    if currentIndex < profiles.count {
                        // Background cards (depth effect)
                        ForEach((0..<min(3, profiles.count - currentIndex)).reversed(), id: \.self) { offset in
                            let cardIndex = currentIndex + offset
                            if cardIndex < profiles.count {
                                ProfileCardView(profile: profiles[cardIndex])
                                    .scaleEffect(1.0 - CGFloat(offset) * 0.04)
                                    .offset(y: CGFloat(offset) * 10)
                                    .zIndex(Double(profiles.count - cardIndex))
                                    .allowsHitTesting(false)
                            }
                        }

                        // Top interactive card
                        ProfileCardView(profile: profiles[currentIndex])
                            .offset(topCardOffset)
                            .rotationEffect(.degrees(rotation))
                            .zIndex(Double(profiles.count + 1))
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        topCardOffset = value.translation
                                        rotation = Double(value.translation.width / 20)
                                    }
                                    .onEnded { value in
                                        handleSwipeEnd(translation: value.translation)
                                    }
                            )
                    } else {
                        // Empty state
                        emptyStateView
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)

                Spacer()

                // Action buttons
                if currentIndex < profiles.count {
                    actionButtons
                        .padding(.bottom, 32)
                }
            }
        }
        .fullScreenCover(isPresented: $showMatch) {
            MatchView(
                matchedProfile: profiles[max(0, currentIndex - 1 < profiles.count ? (currentIndex > 0 ? currentIndex - 1 : 0) : profiles.count - 1)],
                onDismiss: { showMatch = false },
                onFriendPicked: { showMatch = false }
            )
        }
    }

    // MARK: - Subviews

    private var headerView: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Discover")
                    .font(.system(size: 34, weight: .bold, design: .serif))
                    .foregroundColor(.primary)
                Text("SWIPE TO MATCH")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.secondary)
                    .tracking(1.4)
            }
            Spacer()
            // Profile indicator dots
            HStack(spacing: 6) {
                ForEach(0..<profiles.count, id: \.self) { i in
                    Circle()
                        .fill(i == currentIndex ? Color.doubleDoorRed : Color(.systemGray4))
                        .frame(width: i == currentIndex ? 8 : 6, height: i == currentIndex ? 8 : 6)
                        .animation(.easeInOut(duration: 0.2), value: currentIndex)
                }
            }
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 48) {
            // X button
            Button(action: { triggerSwipe(direction: -1) }) {
                ZStack {
                    Circle()
                        .fill(Color(.systemBackground))
                        .frame(width: 64, height: 64)
                        .shadow(color: .black.opacity(0.10), radius: 10, x: 0, y: 4)
                        .overlay(
                            Circle()
                                .strokeBorder(Color(.systemGray4), lineWidth: 1.5)
                        )
                    Image(systemName: "xmark")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(Color(.systemGray2))
                }
            }

            // Heart button
            Button(action: { triggerSwipe(direction: 1) }) {
                ZStack {
                    Circle()
                        .fill(Color.doubleDoorRed)
                        .frame(width: 64, height: 64)
                        .shadow(color: Color.doubleDoorRed.opacity(0.35), radius: 12, x: 0, y: 6)
                    Image(systemName: "heart.fill")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.white)
                }
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 88, height: 88)
                Image(systemName: "heart.slash")
                    .font(.system(size: 34))
                    .foregroundColor(.secondary)
            }
            Text("You've seen everyone")
                .font(.system(size: 20, weight: .bold, design: .serif))
                .foregroundColor(.primary)
            Text("Check back soon for new double date matches.")
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxHeight: .infinity)
    }

    // MARK: - Swipe Logic

    private func triggerSwipe(direction: CGFloat) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
            topCardOffset = CGSize(width: direction * 500, height: 0)
            rotation = direction * 15
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            advanceCard(liked: direction > 0)
        }
    }

    private func handleSwipeEnd(translation: CGSize) {
        if translation.width > swipeThreshold {
            // Swipe right — liked
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                topCardOffset = CGSize(width: 600, height: translation.height)
                rotation = 15
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) {
                advanceCard(liked: true)
            }
        } else if translation.width < -swipeThreshold {
            // Swipe left — passed
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                topCardOffset = CGSize(width: -600, height: translation.height)
                rotation = -15
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) {
                advanceCard(liked: false)
            }
        } else {
            // Snap back
            withAnimation(.spring(response: 0.4, dampingFraction: 0.72)) {
                topCardOffset = .zero
                rotation = 0
            }
        }
    }

    private func advanceCard(liked: Bool) {
        topCardOffset = .zero
        rotation = 0
        if liked {
            showMatch = true
        }
        if currentIndex < profiles.count {
            currentIndex += 1
        }
    }
}

// MARK: - Profile Card View

struct ProfileCardView: View {
    let profile: UserProfile

    private let maxVisibleFriends = 2

    var body: some View {
        VStack(spacing: 0) {
            // Photo area — colored block placeholder
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .fill(profile.cardColor)

                // Gradient overlay at bottom of photo
                LinearGradient(
                    colors: [.clear, .black.opacity(0.45)],
                    startPoint: .center,
                    endPoint: .bottom
                )

                // Name overlay
                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .lastTextBaseline, spacing: 6) {
                        Text(profile.name)
                            .font(.system(size: 28, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                        Text("\(profile.age)")
                            .font(.system(size: 22, weight: .regular, design: .serif))
                            .foregroundColor(.white.opacity(0.90))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 18)
            }
            .frame(height: UIScreen.main.bounds.width * 0.72)

            // Info area
            VStack(alignment: .leading, spacing: 14) {
                // City + Occupation
                HStack(spacing: 16) {
                    Label(profile.city, systemImage: "mappin.circle.fill")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.secondary)

                    Divider()
                        .frame(height: 14)

                    Label(profile.occupation, systemImage: "briefcase.fill")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.secondary)
                }

                Divider()

                // Friends section
                VStack(alignment: .leading, spacing: 10) {
                    Text("WITH FRIENDS")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.secondary)
                        .tracking(1.3)

                    HStack(spacing: 8) {
                        ForEach(profile.friends.prefix(maxVisibleFriends)) { friend in
                            FriendChip(name: friend.name.split(separator: " ").first.map(String.init) ?? friend.name)
                        }
                        if profile.friends.count > maxVisibleFriends {
                            FriendChip(
                                name: "+\(profile.friends.count - maxVisibleFriends)",
                                isOverflow: true
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 6)
    }
}

// MARK: - Friend Chip

struct FriendChip: View {
    let name: String
    var isOverflow: Bool = false

    var body: some View {
        Text(name)
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(isOverflow ? .secondary : .primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(.systemGray6))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(Color(.systemGray5), lineWidth: 1)
            )
    }
}

// MARK: - Preview

#Preview {
    DiscoverView()
}
