import SwiftUI

struct QuizView: View {
    @State private var cards: [MemorizationCardItem] = []
    @State private var currentIndex = 0
    @State private var score = 0
    @State private var showResults = false
    
    var body: some View {
        NavigationStack {
            if cards.isEmpty {
                ContentUnavailableView(
                    "No Cards",
                    systemImage: "questionmark.circle",
                    description: Text("Add memorization cards to start quizzing")
                )
            } else if showResults {
                QuizResultsView(
                    score: score,
                    total: cards.count,
                    onRetry: resetQuiz
                )
            } else {
                QuizCardView(
                    card: cards[currentIndex],
                    onCorrect: recordCorrect,
                    onIncorrect: recordIncorrect
                )
            }
        }
        .navigationTitle("Quiz")
        .task {
            do {
                cards = try await StorageService.shared.fetchCards()
            } catch {
                print("Error fetching cards: \(error)")
            }
        }
    }
    
    private func recordCorrect() {
        score += 1
        nextCard()
    }
    
    private func recordIncorrect() {
        nextCard()
    }
    
    private func nextCard() {
        if currentIndex + 1 < cards.count {
            currentIndex += 1
        } else {
            showResults = true
        }
    }
    
    private func resetQuiz() {
        currentIndex = 0
        score = 0
        showResults = false
    }
}

struct QuizCardView: View {
    let card: MemorizationCardItem
    let onCorrect: () -> Void
    let onIncorrect: () -> Void
    @State private var isFlipped = false
    
    var body: some View {
        VStack(spacing: 20) {
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
            
            if isFlipped {
                HStack(spacing: 20) {
                    Button(action: onIncorrect) {
                        Label("Incorrect", systemImage: "xmark.circle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    
                    Button(action: onCorrect) {
                        Label("Correct", systemImage: "checkmark.circle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
                .padding()
            }
        }
    }
}

struct QuizResultsView: View {
    let score: Int
    let total: Int
    let onRetry: () -> Void
    
    var percentage: Double {
        total > 0 ? Double(score) / Double(total) * 100 : 0
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Quiz Complete")
                .font(.title)
            
            VStack(spacing: 8) {
                Text("\(score)/\(total)")
                    .font(.system(size: 48, weight: .bold))
                Text(String(format: "%.0f%%", percentage))
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button(action: onRetry) {
                Label("Try Again", systemImage: "arrow.clockwise")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
}

#Preview {
    QuizView()
}