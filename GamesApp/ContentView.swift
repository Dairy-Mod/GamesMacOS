import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: UserSession
    
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

