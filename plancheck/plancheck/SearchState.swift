import Foundation

enum SearchState {
    case idle
    case searching(String)
    case results(Int)
    case noResults
}
