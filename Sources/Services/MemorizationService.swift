import Foundation

final class MemorizationService {
    static let shared = MemorizationService()
    
    private init() {}
    
    // SM-2 Algorithm for spaced repetition
    func calculateNextReview(
        currentCard: MemorizationCardItem,
        quality: Int // 0-5, where 5 is perfect recall
    ) -> (nextDate: Date, easeFactor: Double, interval: Int) {
        var easeFactor = currentCard.easeFactor
        var interval = currentCard.interval
        
        if quality < 3 {
            interval = 1
        } else {
            if currentCard.repetitions == 0 {
                interval = 1
            } else if currentCard.repetitions == 1 {
                interval = 3
            } else {
                interval = Int(Double(currentCard.interval) * easeFactor)
            }
        }
        
        easeFactor = max(1.3, easeFactor + (0.1 - (5 - Double(quality)) * (0.08 + (5 - Double(quality)) * 0.02)))
        
        let nextDate = Calendar.current.date(byAdding: .day, value: interval, to: Date()) ?? Date()
        
        return (nextDate, easeFactor, interval)
    }
    
    func recordQuizAttempt(cardId: String, isCorrect: Bool) -> QuizAttempt {
        return QuizAttempt(cardId: cardId, isCorrect: isCorrect)
    }
    
    func getQuizStats(attempts: [QuizAttempt]) -> (correct: Int, total: Int, percentage: Double) {
        let correct = attempts.filter { $0.isCorrect }.count
        let total = attempts.count
        let percentage = total > 0 ? Double(correct) / Double(total) * 100 : 0
        return (correct, total, percentage)
    }
    
    func updateStreak(current: StreakItem) -> StreakItem {
        let today = Calendar.current.startOfDay(for: Date())
        let lastDate = current.lastActivityDate.map { Calendar.current.startOfDay(for: $0) }
        
        if let lastDate = lastDate {
            let daysDifference = Calendar.current.dateComponents([.day], from: lastDate, to: today).day ?? 0
            
            if daysDifference == 1 {
                current.currentStreak += 1
            } else if daysDifference > 1 {
                current.currentStreak = 1
            }
        } else {
            current.currentStreak = 1
        }
        
        current.longestStreak = max(current.longestStreak, current.currentStreak)
        current.lastActivityDate = Date()
        current.totalDaysActive += 1
        
        return current
    }
}