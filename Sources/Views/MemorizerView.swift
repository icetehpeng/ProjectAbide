import SwiftUI

struct MemorizerView: View {
    @State private var currentCard: MemorizationCard?
    @State private var isFlipped: Bool = false
    @State private var cards: [MemorizationCard] = [
        MemorizationCard(reference: "John 3:16", text: "For God so loved the world..."),
        MemorizationCard(reference: "Psalm 23:1", text: "The Lord is my shepherd...")
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if cards.isEmpty {
                    ContentUnavailableView(
                        "No Cards",
                        systemImage: "card.texture",
                        description: Text("Add verses to start memorizing")
                    )
                } else if let card = currentCard ?? cards.first {
                    Spacer()
                    Text(card.reference)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    Text(isFlipped ? card.text : "Tap to reveal")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 150)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .onTapGesture {
                            withAnimation(.spring(response: 0.5)) {
                                isFlipped.toggle()
                            }
                        }
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Button("Again") { nextCard() }
                            .buttonStyle(.bordered)
                        Button("Good") { nextCard() }
                            .buttonStyle(.borderedProminent)
                        Button("Easy") { nextCard() }
                            .buttonStyle(.bordered)
                    }
                    .padding()
                }
            }
            .navigationTitle("Memorize")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    private func nextCard() {
        withAnimation {
            isFlipped = false
            if let card = currentCard, let index = cards.firstIndex(where: { $0.id == card.id }) {
                if index + 1 < cards.count {
                    currentCard = cards[index + 1]
                } else {
                    currentCard = cards.first
                }
            }
        }
    }
}

struct MemorizationCard: Identifiable, Codable {
    let id = UUID()
    let reference: String
    let text: String
    var nextReviewDate: Date = Date()
    var easeFactor: Double = 2.5
}

#Preview {
    MemorizerView()
}