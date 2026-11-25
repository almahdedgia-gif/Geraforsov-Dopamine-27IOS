
import SwiftUI

private enum DopamineStyle {
    static let teal = Color(red: 0.00, green: 0.86, blue: 0.70)
    static let deep = Color(red: 0.00, green: 0.17, blue: 0.19)
    static let panel = Color.white.opacity(0.075)
    static let muted = Color.white.opacity(0.58)

    static let background = LinearGradient(
        colors: [
            Color(red: 0.00, green: 0.34, blue: 0.32),
            deep,
            Color(red: 0.00, green: 0.11, blue: 0.15)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

private enum AppScreen {
    case home
    case progress
    case reboot
}

struct ContentView: View {
    @State private var selectedManager = "Sileo"
    @State private var screen: AppScreen = .home

    @State private var showManagerPicker = false
    @State private var showSettings = false
    @State private var showCredits = false

    @State private var currentStep = -1
    @State private var progress = 0.0
    @State private var completed = false
    @State private var glow = false

    private var steps: [String] {
        [
            "Preparing demonstration...",
            "Checking device profile...",
            "Analyzing kernel environment...",
            "Testing Patching Liter13...",
            "Testing Kernel Pwnage via iB4d...",
            "Preparing \(selectedManager) environment...",
            "Configuring package manager: \(selectedManager)...",
            "Finalizing visual simulation..."
        ]
    }

    var body: some View {
        ZStack {
            DopamineStyle.background
                .ignoresSafeArea()

            ambientGlow

            Group {
                switch screen {
                case .home:
                    homeScreen
                        .transition(.opacity)

                case .progress:
                    progressScreen
                        .transition(.move(edge: .trailing).combined(with: .opacity))

                case .reboot:
                    rebootScreen
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.4), value: screen)
        }
        .preferredColorScheme(.dark)
        .statusBarHidden(false)
        .sheet(isPresented: $showManagerPicker) {
            managerPicker
        }
        .sheet(isPresented: $showSettings) {
            settingsSheet
        }
        .sheet(isPresented: $showCredits) {
            creditsSheet
        }
        .onAppear {
            glow = true
        }
    }

    // MARK: - Background

    private var ambientGlow: some View {
        GeometryReader { geo in
            Circle()
                .fill(DopamineStyle.teal.opacity(0.19))
                .frame(width: 260, height: 260)
                .blur(radius: 85)
                .offset(
                    x: glow ? -130 : -95,
                    y: geo.size.height * 0.17
                )

            Circle()
                .fill(Color.cyan.opacity(0.13))
                .frame(width: 250, height: 250)
                .blur(radius: 90)
                .offset(
                    x: glow ? 145 : 105,
                    y: geo.size.height * 0.67
                )
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .animation(
            .easeInOut(duration: 5).repeatForever(autoreverses: true),
            value: glow
        )
    }

    // MARK: - Home

    private var homeScreen: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 25) {
                    header

                    menuCard

                    managerCard

                    jailbreakButton

                    Text("DEMONSTRATION BUILD • NO SYSTEM MODIFICATIONS")
                        .font(.system(size: 9, weight: .medium))
                        .tracking(1.1)
                        .foregroundStyle(.white.opacity(0.38))
                        .frame(maxWidth: .infinity)
                        .padding(.top, 2)
                }
                .padding(.horizontal, 24)
                .padding(.top, 28)
                .padding(.bottom, 28)
                .frame(minHeight: geo.size.height, alignment: .center)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(spacing: 8) {
                Circle()
                    .fill(DopamineStyle.teal)
                    .frame(width: 8, height: 8)
                    .shadow(color: DopamineStyle.teal, radius: 7)

                Text("DEMO EDITION")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(2)
                    .foregroundStyle(DopamineStyle.teal)
            }
            .padding(.bottom, 8)

            Text("Dopamine")
                .font(.system(size: 45, weight: .bold, design: .rounded))
                .tracking(-1.8)
                .foregroundStyle(.white)

            Text("iOS 27 – 27.2.1")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white.opacity(0.78))

            Text("A12 – A13  ·  by geraforsov")
                .font(.system(size: 13))
                .foregroundStyle(DopamineStyle.muted)
        }
    }

    private var menuCard: some View {
        VStack(spacing: 0) {
            menuRow("gearshape", "Settings") {
                showSettings = true
            }

            rowDivider

            menuRow("arrow.clockwise", "Restart SpringBoard", disabled: true) {}

            rowDivider

            menuRow("power", "Reboot Userspace", disabled: true) {}

            rowDivider

            menuRow("info.circle", "Credits") {
                showCredits = true
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 5)
        .background(DopamineStyle.panel, in: RoundedRectangle(cornerRadius: 24))
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(.white.opacity(0.10), lineWidth: 1)
        }
    }

    private var rowDivider: some View {
        Divider()
            .overlay(.white.opacity(0.11))
            .padding(.leading, 43)
    }

    private func menuRow(
        _ icon: String,
        _ title: String,
        disabled: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 17))
                    .frame(width: 23)

                Text(title)
                    .font(.system(size: 15, weight: .medium))

                Spacer()

                if !disabled {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.42))
                }
            }
            .foregroundStyle(
                disabled ? .white.opacity(0.32) : .white.opacity(0.9)
            )
            .padding(.vertical, 18)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(disabled)
    }

    // MARK: - Package Manager

    private var managerCard: some View {
        Button {
            showManagerPicker = true
        } label: {
            HStack(spacing: 13) {
                Image(systemName: "shippingbox.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(DopamineStyle.teal)

                VStack(alignment: .leading, spacing: 4) {
                    Text("PACKAGE MANAGER")
                        .font(.system(size: 10, weight: .semibold))
                        .tracking(1)
                        .foregroundStyle(DopamineStyle.muted)

                    Text(selectedManager)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                }

                Spacer()

                Text("Change")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(DopamineStyle.teal)

                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(DopamineStyle.teal)
            }
            .padding(18)
            .background(.black.opacity(0.17), in: RoundedRectangle(cornerRadius: 19))
            .overlay {
                RoundedRectangle(cornerRadius: 19)
                    .stroke(.white.opacity(0.10), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }

    private var managerPicker: some View {
        NavigationStack {
            List {
                ForEach(["Sileo", "Zebra"], id: \.self) { manager in
                    Button {
                        selectedManager = manager
                        showManagerPicker = false
                    } label: {
                        HStack(spacing: 13) {
                            Image(systemName: "shippingbox.fill")
                                .foregroundStyle(DopamineStyle.teal)

                            Text(manager)
                                .foregroundStyle(.primary)

                            Spacer()

                            if selectedManager == manager {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(DopamineStyle.teal)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Package Manager")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        showManagerPicker = false
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }

    // MARK: - Main Button

    private var jailbreakButton: some View {
        Button {
            startDemo()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "lock.open.fill")

                Text("Jailbreak")
                    .font(.system(size: 18, weight: .semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background {
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                DopamineStyle.teal.opacity(0.30),
                                Color.white.opacity(0.07)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
            .overlay {
                Capsule()
                    .stroke(DopamineStyle.teal.opacity(0.75), lineWidth: 1)
            }
            .shadow(color: DopamineStyle.teal.opacity(0.13), radius: 18)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Progress Screen

    private var progressScreen: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    if !completed {
                        return
                    }
                    resetDemo()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 42, height: 42)
                        .background(.white.opacity(0.09), in: Circle())
                }
                .opacity(completed ? 1 : 0)

                Spacer()

                Text("DOPAMINE DEMO")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(2)
                    .foregroundStyle(DopamineStyle.teal)

                Spacer()

                Color.clear.frame(width: 42, height: 42)
            }
            .padding(.bottom, 35)

            Spacer(minLength: 10)

            ZStack {
                Circle()
                    .stroke(.white.opacity(0.08), lineWidth: 7)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        DopamineStyle.teal,
                        style: StrokeStyle(lineWidth: 7, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .shadow(color: DopamineStyle.teal.opacity(0.65), radius: 9)

                Image(systemName: completed ? "checkmark" : "bolt.fill")
                    .font(.system(size: 38, weight: .medium))
                    .foregroundStyle(DopamineStyle.teal)
            }
            .frame(width: 116, height: 116)
            .padding(.bottom, 27)
            .animation(.easeInOut(duration: 0.5), value: progress)

            Text(completed ? "Demo completed" : "Running demo")
                .font(.system(size: 27, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("Package manager: \(selectedManager)")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(DopamineStyle.muted)
                .padding(.top, 7)

            Spacer(minLength: 28)

            logCard

            Spacer(minLength: 25)

            Text("VISUAL SIMULATION ONLY")
                .font(.system(size: 10, weight: .semibold))
                .tracking(1.4)
                .foregroundStyle(.white.opacity(0.38))
                .padding(.bottom, 12)
        }
        .padding(.horizontal, 24)
        .padding(.top, 18)
        .padding(.bottom, 12)
    }

    private var logCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                HStack(spacing: 7) {
                    Circle()
                        .fill(DopamineStyle.teal)
                        .frame(width: 7, height: 7)

                    Text("PROCESS LOG")
                        .font(.system(size: 10, weight: .bold))
                        .tracking(1.4)
                }
                .foregroundStyle(DopamineStyle.teal)

                Spacer()

                Text("\(Int(progress * 100))%")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.75))
            }
            .padding(.bottom, 17)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(.white.opacity(0.09))

                    Capsule()
                        .fill(DopamineStyle.teal)
                        .frame(width: geo.size.width * progress)
                }
            }
            .frame(height: 4)
            .padding(.bottom, 20)

            ForEach(steps.indices, id: \.self) { index in
                logRow(index)
            }

            Text("All process labels are fictional demonstration text.")
                .font(.system(size: 10))
                .foregroundStyle(.white.opacity(0.35))
                .padding(.top, 14)
        }
        .padding(19)
        .background(.black.opacity(0.24), in: RoundedRectangle(cornerRadius: 23))
        .overlay {
            RoundedRectangle(cornerRadius: 23)
                .stroke(DopamineStyle.teal.opacity(0.30), lineWidth: 1)
        }
    }

    private func logRow(_ index: Int) -> some View {
        let isDone = index < currentStep || completed
        let isCurrent = index == currentStep && !completed

        return HStack(spacing: 11) {
            Group {
                if isDone {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(DopamineStyle.teal)
                } else if isCurrent {
                    ProgressView()
                        .tint(DopamineStyle.teal)
                        .scaleEffect(0.8)
                } else {
                    Circle()
                        .fill(.white.opacity(0.19))
                        .frame(width: 8, height: 8)
                }
            }
            .frame(width: 15, height: 16)

            Text(steps[index])
                .font(.system(
                    size: 11,
                    weight: isCurrent ? .semibold : .regular,
                    design: .monospaced
                ))
                .foregroundStyle(
                    isDone || isCurrent
                    ? .white.opacity(0.94)
                    : .white.opacity(0.34)
                )
                .lineLimit(2)

            Spacer(minLength: 0)
        }
        .padding(.vertical, 7)
        .animation(.easeInOut(duration: 0.25), value: currentStep)
    }

    // MARK: - Reboot Simulation

    private var rebootScreen: some View {
        VStack(spacing: 22) {
            Spacer()

            ZStack {
                Circle()
                    .stroke(.white.opacity(0.08), lineWidth: 5)
                    .frame(width: 105, height: 105)

                ProgressView()
                    .tint(DopamineStyle.teal)
                    .scaleEffect(1.7)
            }

            Text("Rebooting...")
                .font(.system(size: 29, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("Finishing the visual demonstration")
                .font(.system(size: 14))
                .foregroundStyle(DopamineStyle.muted)

            Spacer()

            Text("SIMULATED REBOOT · YOUR IPHONE IS NOT RESTARTING")
                .font(.system(size: 9, weight: .medium))
                .tracking(1)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.4))
                .padding(.bottom, 25)
        }
        .padding(.horizontal, 28)
    }

    // MARK: - Demo Flow

    private func startDemo() {
        currentStep = -1
        progress = 0
        completed = false

        withAnimation(.easeInOut(duration: 0.35)) {
            screen = .progress
        }

        Task {
            await runDemo()
        }
    }

    @MainActor
    private func runDemo() async {
        for index in steps.indices {
            currentStep = index

            try? await Task.sleep(for: .milliseconds(1150))

            progress = Double(index + 1) / Double(steps.count)
        }

        completed = true

        try? await Task.sleep(for: .milliseconds(900))

        withAnimation(.easeInOut(duration: 0.5)) {
            screen = .reboot
        }

        try? await Task.sleep(for: .seconds(3))

        withAnimation(.easeInOut(duration: 0.5)) {
            screen = .home
        }
    }

    private func resetDemo() {
        currentStep = -1
        progress = 0
        completed = false

        withAnimation {
            screen = .home
        }
    }

    // MARK: - Settings

    private var settingsSheet: some View {
        NavigationStack {
            Form {
                LabeledContent("Developer", value: "geraforsov")
                LabeledContent("Display version", value: "iOS 27 – 27.2.1")
                LabeledContent("Device profile", value: "A12 – A13")
                LabeledContent("Package Manager", value: selectedManager)

                Section {
                    Text("This application is a visual demonstration. It does not exploit iOS, install packages, or modify system settings.")
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        showSettings = false
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private var creditsSheet: some View {
        NavigationStack {
            Form {
                LabeledContent("Application", value: "Dopamine-style demo")
                LabeledContent("Developer", value: "geraforsov")
                LabeledContent("Build type", value: "Visual simulation")
            }
            .navigationTitle("Credits")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        showCredits = false
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}
