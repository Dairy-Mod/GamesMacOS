import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            MainView()
        }
    }
}




#Preview {
    ContentView()
        .environmentObject(UserSession.shared)
}

