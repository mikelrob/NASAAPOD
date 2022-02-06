import APODKit

extension APODItem {
    func formatForCLI() -> String {
        return "\(title) - \(explanation)"
    }
}
