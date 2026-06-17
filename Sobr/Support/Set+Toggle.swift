import Foundation

extension Set {
    /// Inserts `member` if absent, removes it if present. Handy for the
    /// multi-select lists (symptoms, goals).
    mutating func toggle(_ member: Element) {
        if contains(member) {
            remove(member)
        } else {
            insert(member)
        }
    }
}
