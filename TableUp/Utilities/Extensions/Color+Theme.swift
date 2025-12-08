//
//  Color+Theme.swift
//  TableUp
//
//  Theme color extensions
//

import SwiftUI

extension Color {
    // MARK: - Primary Colors
    static let primaryPurple = Color(hex: "7C3AED")
    static let primaryPurpleLight = Color(hex: "A78BFA")
    static let primaryPurpleDark = Color(hex: "5B21B6")

    // MARK: - Background Colors
    static let backgroundDark = Color(hex: "0F0F0F")
    static let backgroundCard = Color(hex: "1A1A1A")
    static let backgroundElevated = Color(hex: "252525")

    // MARK: - Text Colors
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "A0A0A0")
    static let textTertiary = Color(hex: "707070")

    // MARK: - Accent Colors
    static let accentGreen = Color(hex: "10B981")
    static let accentRed = Color(hex: "EF4444")
    static let accentBlue = Color(hex: "3B82F6")
    static let accentYellow = Color(hex: "F59E0B")

    // MARK: - Meet Category Colors
    static let categoryTech = Color(hex: "8B5CF6")
    static let categorySocial = Color(hex: "F59E0B")
    static let categoryFitness = Color(hex: "10B981")
    static let categoryCulture = Color(hex: "EC4899")
    static let categoryFood = Color(hex: "F97316")
    static let categorySports = Color(hex: "3B82F6")
    static let categoryOutdoors = Color(hex: "14B8A6")
    static let categoryLearning = Color(hex: "A855F7")

    // MARK: - Utility
    static let divider = Color(hex: "333333")
    static let overlay = Color.black.opacity(0.5)

    // MARK: - Helper
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    static func forCategory(_ category: String) -> Color {
        switch category.lowercased() {
        case "tech", "startup", "ai":
            return .categoryTech
        case "social", "networking":
            return .categorySocial
        case "fitness", "sports", "running":
            return .categoryFitness
        case "culture", "art", "music":
            return .categoryCulture
        case "food", "coffee", "dining":
            return .categoryFood
        case "outdoors", "hiking", "nature":
            return .categoryOutdoors
        case "learning", "education":
            return .categoryLearning
        default:
            return .primaryPurple
        }
    }
}
