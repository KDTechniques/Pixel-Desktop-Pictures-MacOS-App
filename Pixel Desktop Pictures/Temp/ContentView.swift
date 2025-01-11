import SwiftUI

struct ContentView2: View {
    @State private var isSheetVisible = false
    
    var body: some View {
        ZStack {
            VStack {
                Button("Show Sheet") {
                    withAnimation {
                        isSheetVisible.toggle()
                    }
                }
            }
            .frame(maxHeight: .infinity)
            
            if isSheetVisible {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                isSheetVisible = false
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                    Text("This is a custom sheet")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                        .padding(.bottom, 30)
                }
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
                .transition(.move(edge: .bottom))
            }
        }
    }
}


#Preview {
    ContentView2()
        .previewModifier
}
