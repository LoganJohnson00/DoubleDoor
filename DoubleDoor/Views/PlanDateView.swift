import SwiftUI

struct PlanDateView: View {
    let venues: [Venue] = Venue.mockVenues
    @State private var selectedVenueID: UUID? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 6) {
                    Text("Plan Your Date")
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundColor(.primary)

                    Text("SUGGESTIONS BASED ON YOUR VIBES")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.secondary)
                        .tracking(1.3)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 24)

                // Vibe filter pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(["All", "Coffee", "Dinner", "Movies", "Outdoors", "Drinks"], id: \.self) { vibe in
                            VibePill(label: vibe, isSelected: vibe == "All")
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 24)

                // Venue cards
                VStack(spacing: 14) {
                    ForEach(venues) { venue in
                        VenueCard(
                            venue: venue,
                            isSelected: selectedVenueID == venue.id,
                            onTap: {
                                withAnimation(.easeInOut(duration: 0.18)) {
                                    selectedVenueID = selectedVenueID == venue.id ? nil : venue.id
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)

                // Book CTA
                if let selectedID = selectedVenueID,
                   let venue = venues.first(where: { $0.id == selectedID }) {
                    bookCTA(venue: venue)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                // Partner promo footer
                promoFooter
                    .padding(.horizontal, 20)
                    .padding(.top, 28)
                    .padding(.bottom, 40)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarHidden(true)
    }

    // MARK: - Book CTA

    private func bookCTA(venue: Venue) -> some View {
        VStack(spacing: 12) {
            Button(action: {}) {
                HStack(spacing: 8) {
                    Text("\(venue.emoji) Book \(venue.name)")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 22)
                .frame(height: 56)
                .background(Color.doubleDoorRed)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            Button(action: {}) {
                Text("Send to group chat →")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.doubleDoorRed)
            }
        }
    }

    // MARK: - Promo Footer

    private var promoFooter: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.doubleDoorRed.opacity(0.10))
                    .frame(width: 44, height: 44)
                Image(systemName: "percent")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.doubleDoorRed)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text("Partner Deals")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                Text("Exclusive discounts for DoubleDoor groups")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(Color(.systemGray5), lineWidth: 1)
        )
    }
}

// MARK: - Vibe Pill

struct VibePill: View {
    let label: String
    let isSelected: Bool

    var body: some View {
        Text(label)
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.primary : Color(.systemBackground))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(isSelected ? Color.clear : Color(.systemGray5), lineWidth: 1)
            )
    }
}

// MARK: - Venue Card

struct VenueCard: View {
    let venue: Venue
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .center, spacing: 14) {
                // Emoji icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .frame(width: 52, height: 52)
                    Text(venue.emoji)
                        .font(.system(size: 26))
                }

                // Info
                VStack(alignment: .leading, spacing: 5) {
                    Text(venue.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)

                    HStack(spacing: 4) {
                        Image(systemName: "mappin")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                        Text("\(venue.neighborhood) · \(venue.distance)")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }

                    if let deal = venue.deal {
                        HStack(spacing: 4) {
                            Image(systemName: "tag.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.green)
                            Text(deal)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.green)
                        }
                    } else {
                        Text("No deal available")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.systemGray4))
                    }
                }

                Spacer()

                // Right side
                VStack(alignment: .trailing, spacing: 8) {
                    if venue.isSponsored {
                        Text("SPONSORED")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(.secondary)
                            .tracking(0.8)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }

                    Image(systemName: isSelected ? "checkmark.circle.fill" : "chevron.right")
                        .font(.system(size: isSelected ? 22 : 14))
                        .foregroundColor(isSelected ? .doubleDoorRed : Color(.systemGray3))
                        .animation(.easeInOut(duration: 0.18), value: isSelected)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                isSelected
                ? Color.doubleDoorRed.opacity(0.04)
                : Color(.systemBackground)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        venueCardBorderStyle(venue: venue, isSelected: isSelected),
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
            .shadow(
                color: isSelected ? Color.doubleDoorRed.opacity(0.12) : .black.opacity(0.04),
                radius: isSelected ? 10 : 6,
                x: 0, y: 3
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.18), value: isSelected)
    }

    private func venueCardBorderStyle(venue: Venue, isSelected: Bool) -> Color {
        if isSelected { return Color.doubleDoorRed.opacity(0.5) }
        if !venue.isSponsored { return Color(.systemGray4) }
        return Color(.systemGray5)
    }
}

// Note: StrokeStyle dashes require a different approach — using a custom dashed border for non-sponsored venues
struct DashedBorderVenueCard: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5, 3]))
            .foregroundColor(Color(.systemGray4))
    }
}

// MARK: - Preview

#Preview {
    PlanDateView()
}
