import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Discover
            NavigationStack {
                DiscoverView()
            }
            .tabItem {
                Label("Discover", systemImage: selectedTab == 0 ? "flame.fill" : "flame")
            }
            .tag(0)

            // Matches / Chat
            NavigationStack {
                GroupChatView()
                    .navigationTitle("")
                    .navigationBarHidden(true)
            }
            .tabItem {
                Label("Matches", systemImage: selectedTab == 1 ? "bubble.left.and.bubble.right.fill" : "bubble.left.and.bubble.right")
            }
            .tag(1)

            // Plan
            NavigationStack {
                PlanDateView()
            }
            .tabItem {
                Label("Plan", systemImage: selectedTab == 2 ? "map.fill" : "map")
            }
            .tag(2)
        }
        .tint(Color.doubleDoorRed)
    }
}

// MARK: - Preview

#Preview {
    MainTabView()
}
