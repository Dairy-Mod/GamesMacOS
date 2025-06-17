import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            RegisterView()
        }
    }
}




#Preview {
    ContentView()
        .environmentObject(UserSession.shared)
}

