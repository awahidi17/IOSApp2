//
//  CoffeeRunTimerView.swift
//  TimsOrder — Foodies Cafe
//
//  Created by Ahmad Wahidi
//  Course: MWD3A — iOS Development
//  Assignment 2
//
//  A countdown timer for the office coffee run.
//  The person going to Tim Hortons sets how long they'll be gone.
//  A circular progress ring animates as time passes.
//
//  This mirrors the exercise timer from the HIITFit tutorial but
//  adapted for a coffee run context.
//
//  Concepts used:
//    - @AppStorage      → remembers default duration between app launches
//    - @State           → manages timer countdown and running state locally
//    - Timer.publish()  → fires every 1 second; same pattern as HIITFit
//    - .onReceive       → listens for timer ticks and decrements the counter
//    - Stepper          → lets user pick run duration in 5-minute increments
//    - Circle().trim    → draws the animated progress arc
//    - DispatchQueue    → (not used here; Timer.publish handles ticking)
//

import SwiftUI
import Combine

struct CoffeeRunTimerView: View {

    // MARK: - Persistent Settings
    //
    // @AppStorage saves this value to UserDefaults automatically.
    // Even if the app closes, the last chosen duration is remembered.

    @AppStorage("defaultRunMinutes_Ahmad") private var defaultMinutes: Int = 15

    // MARK: - Local Timer State
    //
    // @State variables are owned by this view and reset when the view disappears.

    @State private var secondsRemaining: Int = 0   // counts down from total seconds
    @State private var isRunning = false            // is the timer currently running?
    @State private var runnerName = ""              // optional name of who's going

    // MARK: - Timer Publisher
    //
    // Timer.publish(every:) creates a "publisher" that sends a signal every 1 second.
    // autoconnect() starts it immediately without needing a manual .connect() call.
    // This is the same pattern used in the HIITFit exercise timer from the textbook.

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // MARK: - Computed Properties
    //
    // These calculate display values from the raw state — no extra stored variables.

    /// Formats seconds as MM:SS (e.g. 14:35 for 875 seconds)
    var timeString: String {
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    /// Progress from 0.0 (just started) to 1.0 (finished) for the ring animation
    var progress: Double {
        let total = defaultMinutes * 60          // total seconds in the run
        guard total > 0 else { return 0 }
        return Double(total - secondsRemaining) / Double(total)
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {

                // MARK: Runner Name Field
                // Optional — shows the name in the timer when running
                TextField("Who's going? (name)", text: $runnerName)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                // MARK: Circular Timer Ring
                //
                // ZStack layers three things on top of each other:
                //   1. A grey background circle (full 360°)
                //   2. A coloured foreground arc (grows as progress increases)
                //   3. The time text in the centre

                ZStack {
                    // Background: full grey circle
                    Circle()
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 16)

                    // Foreground: coloured arc that fills from 0% to 100%
                    // .trim(from:to:) cuts the circle — to: progress draws only that portion
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            Color("AccentColor"),
                            style: StrokeStyle(lineWidth: 16, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90)) // start at the top (12 o'clock)
                        .animation(.linear(duration: 1), value: progress) // smooth 1-second steps

                    // Centre display: time and status text
                    VStack(spacing: 4) {
                        Text(timeString)
                            .font(.system(size: 52, weight: .bold, design: .monospaced))

                        // Status text changes based on whether the timer is running
                        Text(
                            isRunning
                            ? (runnerName.isEmpty ? "On the way! ☕" : "\(runnerName) is on the way!")
                            : "Set your timer"
                        )
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    }
                }
                .frame(width: 240, height: 240)
                .padding()

                // MARK: Duration Stepper
                //
                // Only visible when the timer is NOT running.
                // Stepper lets the user pick 5 to 60 minutes in steps of 5.
                // value: $defaultMinutes binds directly to @AppStorage.

                if !isRunning {
                    Stepper(
                        "Estimated time: \(defaultMinutes) min",
                        value: $defaultMinutes,
                        in: 5...60,
                        step: 5
                    )
                    .padding(.horizontal, 40)
                }

                // MARK: Start / Cancel Button
                Button(action: toggleTimer) {
                    Text(isRunning ? "Cancel Run" : "Start Coffee Run ☕")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isRunning ? Color.gray : Color("AccentColor"))
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                }

                Spacer()
            }
            .padding(.top, 24)
            .navigationTitle("⏱ Coffee Run Timer")

            // MARK: Timer Tick Handler
            //
            // .onReceive listens to the timer publisher.
            // Every second it fires, we check if the timer is running
            // and decrement the counter. At 0, we stop automatically.

            .onReceive(timer) { _ in
                guard isRunning else { return } // do nothing if not running
                if secondsRemaining > 0 {
                    secondsRemaining -= 1
                } else {
                    isRunning = false // timer finished — stop it
                }
            }
        }
    }

    // MARK: - Toggle Timer
    //
    // If running: cancel and reset to 0.
    // If stopped: set the total seconds and start counting.

    private func toggleTimer() {
        if isRunning {
            isRunning = false
            secondsRemaining = 0
        } else {
            secondsRemaining = defaultMinutes * 60 // e.g. 15 min × 60 = 900 seconds
            isRunning = true
        }
    }
}

#Preview {
    CoffeeRunTimerView()
}
