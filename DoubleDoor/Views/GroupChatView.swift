import SwiftUI

struct GroupChatView: View {
    @State private var messageText: String = ""
    @State private var messages: [Message] = Message.mockMessages
    @FocusState private var inputFocused: Bool

    private let participants = ["You", "Alex", "Jordan", "Emma"]
    private let avatarColors: [Color] = [
        Color(red: 0.93, green: 0.87, blue: 0.80),
        Color(red: 0.93, green: 0.72, blue: 0.60),
        Color(red: 0.62, green: 0.80, blue: 0.70),
        Color(red: 0.68, green: 0.75, blue: 0.92)
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Header
            chatHeader
                .background(Color(.systemBackground))

            Divider()

            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        // Date label
                        dateSeparator(label: "TODAY")
                            .padding(.top, 16)
                            .padding(.bottom, 8)

                        // First two messages
                        ForEach(messages.prefix(2)) { message in
                            MessageBubble(message: message, avatarColor: avatarColor(for: message.sender))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 4)
                        }

                        // Date suggestions card
                        DateSuggestionCard()
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)

                        // Remaining messages
                        ForEach(messages.dropFirst(2)) { message in
                            MessageBubble(message: message, avatarColor: avatarColor(for: message.sender))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 4)
                                .id(message.id)
                        }

                        Color.clear.frame(height: 12).id("bottom")
                    }
                }
                .onChange(of: messages.count) { _ in
                    withAnimation {
                        proxy.scrollTo("bottom", anchor: .bottom)
                    }
                }
            }
            .background(Color(.systemGroupedBackground))

            Divider()

            // Input bar
            messageInputBar
                .background(Color(.systemBackground))
        }
        .navigationBarHidden(true)
    }

    // MARK: - Chat Header

    private var chatHeader: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                // Overlapping avatars
                ZStack {
                    ForEach(Array(participants.prefix(4).enumerated()), id: \.offset) { index, name in
                        avatarCircle(
                            initials: String(name.prefix(1)),
                            color: avatarColors[index % avatarColors.count],
                            size: 36
                        )
                        .offset(x: CGFloat(index) * 18)
                    }
                }
                .frame(width: 36 + 3 * 18 + 36, height: 36, alignment: .leading)

                VStack(alignment: .leading, spacing: 3) {
                    Text("Alex, Jordan, Emma, Sarah")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    Text("4 people · double date")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.secondary)
                }

                Spacer()

                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
        }
    }

    // MARK: - Message Input Bar

    private var messageInputBar: some View {
        HStack(spacing: 10) {
            HStack {
                TextField("Message the group...", text: $messageText, axis: .vertical)
                    .font(.system(size: 15))
                    .lineLimit(4)
                    .focused($inputFocused)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
            }
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 22))

            // Send button
            Button(action: sendMessage) {
                ZStack {
                    Circle()
                        .fill(messageText.trimmingCharacters(in: .whitespaces).isEmpty
                              ? Color(.systemGray4)
                              : Color.primary)
                        .frame(width: 38, height: 38)
                    Image(systemName: "arrow.up")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .disabled(messageText.trimmingCharacters(in: .whitespaces).isEmpty)
            .animation(.easeInOut(duration: 0.15), value: messageText.isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    // MARK: - Helpers

    private func dateSeparator(label: String) -> some View {
        HStack {
            Rectangle().fill(Color(.systemGray5)).frame(height: 0.5)
            Text(label)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.secondary)
                .tracking(1.2)
                .fixedSize()
            Rectangle().fill(Color(.systemGray5)).frame(height: 0.5)
        }
        .padding(.horizontal, 24)
    }

    private func avatarColor(for sender: String) -> Color {
        switch sender {
        case "You": return avatarColors[0]
        case "Alex": return avatarColors[1]
        case "Jordan": return avatarColors[2]
        default: return avatarColors[3]
        }
    }

    private func avatarCircle(initials: String, color: Color, size: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: size, height: size)
                .overlay(Circle().strokeBorder(Color(.systemBackground), lineWidth: 2))
            Text(initials)
                .font(.system(size: size * 0.38, weight: .semibold))
                .foregroundColor(.white)
        }
    }

    private func sendMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        let newMessage = Message(sender: "You", text: trimmed, isCurrentUser: true)
        withAnimation(.easeIn(duration: 0.2)) {
            messages.append(newMessage)
        }
        messageText = ""
    }
}

// MARK: - Message Bubble

struct MessageBubble: View {
    let message: Message
    let avatarColor: Color

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isCurrentUser {
                Spacer(minLength: 60)
                bubble
            } else {
                // Avatar
                ZStack {
                    Circle()
                        .fill(avatarColor)
                        .frame(width: 30, height: 30)
                    Text(String(message.sender.prefix(1)))
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(message.sender)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.secondary)
                        .padding(.leading, 2)
                    bubble
                }

                Spacer(minLength: 60)
            }
        }
    }

    @ViewBuilder
    private var bubble: some View {
        Text(message.text)
            .font(.system(size: 15))
            .foregroundColor(message.isCurrentUser ? .white : .primary)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                message.isCurrentUser
                ? Color.primary
                : Color(.systemBackground)
            )
            .clipShape(
                BubbleShape(isCurrentUser: message.isCurrentUser)
            )
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Bubble Shape

struct BubbleShape: Shape {
    let isCurrentUser: Bool
    let radius: CGFloat = 18
    let tailRadius: CGFloat = 4

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let tr = min(radius, rect.height / 2, rect.width / 2)
        path.addRoundedRect(
            in: rect,
            cornerSize: CGSize(width: tr, height: tr)
        )
        return path
    }
}

// MARK: - Date Suggestion Card

struct DateSuggestionCard: View {
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            // Spacer for left alignment (from others)
            HStack(spacing: 8) {
                // Avatar placeholder (system)
                ZStack {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 30, height: 30)
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }

                // Card content
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 6) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.doubleDoorRed)
                        Text("DATE SUGGESTIONS")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.doubleDoorRed)
                            .tracking(1.1)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Blue Bottle Coffee")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.primary)
                        Text("Williamsburg · 0.4 mi")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }

                    HStack(spacing: 5) {
                        Image(systemName: "tag.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.green)
                        Text("20% off for DoubleDoor dates")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.green)
                    }

                    Button(action: {}) {
                        Text("View All Suggestions →")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.doubleDoorRed)
                    }
                }
                .padding(14)
                .frame(maxWidth: 260, alignment: .leading)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(Color(.systemGray5), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
            }

            Spacer(minLength: 60)
        }
    }
}

// MARK: - Preview

#Preview {
    GroupChatView()
}
