import SwiftUI

struct FriendPickerView: View {
    let friends: [Friend]
    let onFriendPicked: () -> Void

    @State private var selectedFriendID: UUID? = nil

    private let avatarColors: [Color] = [
        Color(red: 0.93, green: 0.72, blue: 0.60),
        Color(red: 0.65, green: 0.80, blue: 0.70),
        Color(red: 0.62, green: 0.75, blue: 0.92),
        Color(red: 0.88, green: 0.72, blue: 0.88)
    ]

    var selectedFriend: Friend? {
        friends.first { $0.id == selectedFriendID }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 6) {
                Text("Pick a Friend")
                    .font(.system(size: 30, weight: .bold, design: .serif))
                    .foregroundColor(.primary)

                Text("Choose who joins the double date")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 24)
            .padding(.top, 28)
            .padding(.bottom, 20)

            // Friend list
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Array(friends.enumerated()), id: \.element.id) { index, friend in
                        FriendRow(
                            friend: friend,
                            avatarColor: avatarColors[index % avatarColors.count],
                            isSelected: selectedFriendID == friend.id,
                            onTap: {
                                withAnimation(.easeInOut(duration: 0.18)) {
                                    selectedFriendID = friend.id
                                }
                            }
                        )

                        if index < friends.count - 1 {
                            Divider()
                                .padding(.leading, 76)
                        }
                    }
                }
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
                .padding(.horizontal, 24)
            }

            Spacer()

            // CTA button
            Button(action: {
                if selectedFriendID != nil {
                    onFriendPicked()
                }
            }) {
                HStack(spacing: 8) {
                    Text(selectedFriend != nil ? "INVITE \(selectedFriend!.name.uppercased())" : "SELECT A FRIEND")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(selectedFriendID != nil ? .white : Color(.systemGray3))
                    if selectedFriendID != nil {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(selectedFriendID != nil ? Color.primary : Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(selectedFriendID == nil)
            .padding(.horizontal, 24)
            .padding(.bottom, 36)
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - Friend Row

struct FriendRow: View {
    let friend: Friend
    let avatarColor: Color
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(avatarColor)
                        .frame(width: 48, height: 48)
                    Text(friend.initials)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }

                // Info
                VStack(alignment: .leading, spacing: 3) {
                    Text("\(friend.name), \(friend.age)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    Text(friend.relationship)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Checkmark
                ZStack {
                    Circle()
                        .strokeBorder(
                            isSelected ? Color.doubleDoorRed : Color(.systemGray4),
                            lineWidth: 2
                        )
                        .frame(width: 26, height: 26)
                    if isSelected {
                        Circle()
                            .fill(Color.doubleDoorRed)
                            .frame(width: 26, height: 26)
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(isSelected ? Color.doubleDoorRed.opacity(0.06) : Color.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

// MARK: - Preview

#Preview {
    FriendPickerView(
        friends: UserProfile.mockProfiles[0].friends,
        onFriendPicked: {}
    )
}
