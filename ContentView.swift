import SwiftUI

private enum Palette {
    static let background = Color(red: 0.00, green: 0.22, blue: 0.22)
    static let teal = Color(red: 0.00, green: 0.82, blue: 0.68)
    static let muted = Color.white.opacity(0.62)
    static let panel = Color(red: 0.02, green: 0.28, blue: 0.29).opacity(0.82)
}

struct ContentView: View {
    @State private var selectedManager = "Sileo"
    @State private var showManagerPicker = false
    @State private var showSettings = false
    @State private var showCredits = false
    @State private var isRunning = false
    @State private var finished = false
    @State private var progress = 0.0
    @State private var currentStep = 0

    private let steps = [
        "Preparing demonstration...",
        "Analyzing kernel (simulation)...",
        "Checking exploit stages (simulation)...",
        "Testing Patching Liter13 (simulation)...",
        "Testing Kernel Pwnage via iB4d (simulation)...",
        "Preparing \( "Sileo" ) / Zebra selection...",
        "Demo sequence completed"
    ]

    var body: some View {
        ZStack {
            LinearGradient(colors: [
                Color(red: 0.00, green: 0.34, blue: 0.32),
                Palette.background,
                Color(red: 0.00, green: 0.16, blue: 0.19)
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()

            Circle().fill(Palette.teal.opacity(0.22))
                .frame(width: 260, height: 260).blur(radius: 90)
                .offset(x: -150, y: 100)
            Circle().fill(Color.cyan.opacity(0.15))
                .frame(width: 240, height: 240).blur(radius: 90)
                .offset(x: 160, y: 420)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 26) {
                    header
                    menuCard
                    if isRunning || finished { progressCard }
                    managerCard
                    jailbreakButton
                    Text("DEMONSTRATION BUILD • NO SYSTEM MODIFICATIONS")
                        .font(.system(size: 9, weight: .medium, design: .rounded))
                        .tracking(1.1)
                        .foregroundStyle(.white.opacity(0.38))
                        .frame(maxWidth: .infinity)
                        .padding(.top, 2)
                }
                .padding(.horizontal, 25)
                .padding(.top, 48)
                .padding(.bottom, 30)
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showManagerPicker) { managerPicker }
        .sheet(isPresented: $showSettings) { settingsSheet }
        .sheet(isPresented: $showCredits) { creditsSheet }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                Text("23:41").font(.system(size: 15, weight: .semibold))
                Spacer()
                Image(systemName: "cellularbars")
                Image(systemName: "wifi")
                Image(systemName: "battery.100percent")
            }
            .foregroundStyle(.white.opacity(0.9))
            .padding(.bottom, 54)

            Text("Dopamine")
                .font(.system(size: 43, weight: .bold, design: .rounded))
                .tracking(-1.6)
                .foregroundStyle(.white)

            Text("iOS 27 – 27.2.1  ·  A12 – A13")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Palette.muted)

            Text("by geraforsov")
                .font(.system(size: 14))
                .foregroundStyle(Palette.muted)
        }
    }

    private var menuCard: some View {
        VStack(spacing: 0) {
            menuRow("gearshape", "Settings") { showSettings = true }
            Divider().overlay(.white.opacity(0.12)).padding(.leading, 48)
            menuRow("arrow.clockwise", "Restart SpringBoard", disabled: true) {}
            Divider().overlay(.white.opacity(0.12)).padding(.leading, 48)
            menuRow("power", "Reboot Userspace", disabled: true) {}
            Divider().overlay(.white.opacity(0.12)).padding(.leading, 48)
            menuRow("info.circle", "Credits") { showCredits = true }
        }
        .padding(.horizontal, 19)
        .padding(.vertical, 4)
        .background(Palette.panel, in: RoundedRectangle(cornerRadius: 25))
        .overlay(RoundedRectangle(cornerRadius: 25).stroke(.white.opacity(0.10)))
    }

    private func menuRow(_ icon: String, _ title: String, disabled: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon).frame(width: 23)
                Text(title)
                Spacer()
                if !disabled { Image(systemName: "chevron.right").font(.system(size: 13, weight: .semibold)) }
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(disabled ? .white.opacity(0.35) : .white.opacity(0.88))
            .padding(.vertical, 19)
            .contentShape(Rectangle())
        }
        .disabled(disabled)
    }

    private var managerCard: some View {
        Button { showManagerPicker = true } label: {
            HStack {
                Image(systemName: "shippingbox")
                VStack(alignment: .leading, spacing: 3) {
                    Text("Package Manager").font(.system(size: 13)).foregroundStyle(Palette.muted)
                    Text(selectedManager).font(.system(size: 17, weight: .semibold)).foregroundStyle(.white)
                }
                Spacer()
                Text("Change").font(.system(size: 13, weight: .semibold)).foregroundStyle(Palette.teal)
                Image(systemName: "chevron.right").font(.system(size: 12))
            }
            .padding(17)
            .background(.black.opacity(0.15), in: RoundedRectangle(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.10)))
        }
        .buttonStyle(.plain)
    }

    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 13) {
                if isRunning {
                    ProgressView().tint(Palette.teal).scaleEffect(1.25).frame(width: 34, height: 34)
                } else {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 29)).foregroundStyle(Palette.teal)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(isRunning ? "Jailbreaking..." : "Demo complete")
                        .font(.system(size: 19, weight: .semibold))
                    Text(isRunning ? "Running visual simulation" : "No changes were made to iOS")
                        .font(.system(size: 13)).foregroundStyle(Palette.muted)
                }
            }

            ProgressView(value: progress).tint(Palette.teal)

            ForEach(steps.indices, id: \.self) { index in
                HStack(spacing: 10) {
                    Circle().fill(index <= currentStep ? Palette.teal : .white.opacity(0.18))
                        .frame(width: 7, height: 7)
                    Text(steps[index])
                        .font(.system(size: 12, weight: index == currentStep ? .semibold : .regular))
                        .foregroundStyle(index <= currentStep ? .white.opacity(0.9) : Palette.muted.opacity(0.55))
                }
            }
            Text("All exploit-stage labels are fictional demo text.")
                .font(.system(size: 10)).foregroundStyle(.white.opacity(0.42))
                .padding(.top, 2)
        }
        .padding(19)
        .background(.black.opacity(0.22), in: RoundedRectangle(cornerRadius: 23))
        .overlay(RoundedRectangle(cornerRadius: 23).stroke(Palette.teal.opacity(0.65), lineWidth: 1))
    }

    private var jailbreakButton: some View {
        Button {
            if finished {
                resetDemo()
            } else if !isRunning {
                Task { await runDemo() }
            }
        } label: {
            HStack(spacing: 13) {
                Image(systemName: finished ? "checkmark" : "lock.open")
                Text(isRunning ? "Please wait..." : (finished ? "Run Again" : "Jailbreak"))
            }
            .font(.system(size: 18, weight: .medium))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.white.opacity(0.07), in: Capsule())
            .overlay(Capsule().stroke(Palette.teal.opacity(0.55), lineWidth: 1))
        }
        .disabled(isRunning)
        .padding(.top, 2)
    }

    private var managerPicker: some View {
        NavigationStack {
            List {
                ForEach(["Sileo", "Zebra"], id: \.self) { manager in
                    Button {
                        selectedManager = manager
                        showManagerPicker = false
                    } label: {
                        HStack {
                            Image(systemName: manager == "Sileo" ? "shippingbox.fill" : "shippingbox")
                            Text(manager)
                            Spacer()
                            if selectedManager == manager { Image(systemName: "checkmark").foregroundStyle(.tint) }
                        }
                    }
                    .foregroundStyle(.primary)
                }
            }
            .navigationTitle("Package Manager")
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { showManagerPicker = false } } }
        }
        .presentationDetents([.medium])
    }

    private var settingsSheet: some View {
        NavigationStack {
            Form {
                LabeledContent("Developer", value: "geraforsov")
                LabeledContent("Display version", value: "iOS 27 – 27.2.1")
                LabeledContent("Device profile", value: "A12 – A13")
                LabeledContent("Package Manager", value: selectedManager)
                Section { Text("This app is a UI demonstration. It does not exploit iOS, install packages, or change system settings.") }
            }
            .navigationTitle("Settings")
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { showSettings = false } } }
        }
        .presentationDetents([.medium, .large])
    }

    private var creditsSheet: some View {
        NavigationStack {
            Form {
                LabeledContent("Application concept", value: "Dopamine-style demo")
                LabeledContent("Developer label", value: "geraforsov")
                LabeledContent("Build type", value: "Visual simulation")
            }
            .navigationTitle("Credits")
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { showCredits = false } } }
        }
        .presentationDetents([.medium])
    }

    @MainActor
    private func runDemo() async {
        isRunning = true
        finished = false
        progress = 0
        currentStep = 0
        for index in steps.indices {
            currentStep = index
            try? await Task.sleep(for: .milliseconds(1050))
            progress = Double(index + 1) / Double(steps.count)
        }
        isRunning = false
        finished = true
    }

    private func resetDemo() {
        progress = 0
        currentStep = 0
        finished = false
    }
}
