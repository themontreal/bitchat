//
//  FrogTheme.swift
//  FrogChat
//
//  Swamp-themed colors, fonts, and styling
//

import SwiftUI

struct FrogTheme {
    // MARK: - Colors

    /// Deep swamp green background
    static let swampGreen = Color(red: 0.176, green: 0.314, blue: 0.086) // #2d5016

    /// Lily pad green for accents
    static let lilyPadGreen = Color(red: 0.290, green: 0.486, blue: 0.173) // #4a7c2c

    /// Dark water blue-green
    static let waterBlue = Color(red: 0.102, green: 0.278, blue: 0.165) // #1a472a

    /// Bright frog skin green
    static let frogSkin = Color(red: 0.486, green: 0.702, blue: 0.259) // #7cb342

    /// Moonlight (for night mode)
    static let moonlight = Color(red: 0.8, green: 0.85, blue: 0.9)

    /// Mud brown for toads
    static let mudBrown = Color(red: 0.4, green: 0.3, blue: 0.2)

    /// Message bubble colors
    static let incomingBubble = Color(red: 0.25, green: 0.35, blue: 0.20)
    static let outgoingBubble = Color(red: 0.35, green: 0.50, blue: 0.25)

    // MARK: - Fonts

    static let croakFont = Font.system(.body, design: .rounded).weight(.medium)
    static let titleFont = Font.system(.title2, design: .rounded).weight(.bold)
    static let captionFont = Font.system(.caption, design: .rounded)

    // MARK: - Gradients

    static let swampGradient = LinearGradient(
        colors: [swampGreen, waterBlue],
        startPoint: .top,
        endPoint: .bottom
    )

    static let lilyPadGradient = RadialGradient(
        colors: [lilyPadGreen, swampGreen],
        center: .center,
        startRadius: 20,
        endRadius: 100
    )

    // MARK: - Time-based Backgrounds

    static func backgroundForTime() -> Color {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 6..<12:
            // Morning - lighter green
            return Color(red: 0.35, green: 0.45, blue: 0.25)
        case 12..<18:
            // Day - standard swamp green
            return swampGreen
        case 18..<22:
            // Evening - orange tint
            return Color(red: 0.3, green: 0.35, blue: 0.2)
        default:
            // Night - very dark
            return Color(red: 0.1, green: 0.15, blue: 0.1)
        }
    }

    // MARK: - Spacing

    static let lilyPadSpacing: CGFloat = 60
    static let frogSize: CGFloat = 44
    static let rippleMaxRadius: CGFloat = 200
}

// MARK: - Custom View Modifiers

struct SwampStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(FrogTheme.swampGradient)
            .foregroundColor(FrogTheme.moonlight)
    }
}

struct LilyPadButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(FrogTheme.lilyPadGradient)
            .foregroundColor(.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
    }
}

extension View {
    func swampStyle() -> some View {
        modifier(SwampStyle())
    }

    func lilyPadButton() -> some View {
        modifier(LilyPadButton())
    }
}
