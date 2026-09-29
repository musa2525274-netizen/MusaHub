import SwiftUI
import ReplayKit

@MainActor
final class ScreenRecorderModel: ObservableObject {
    @Published var isRecording = false
    @Published var errorMessage: String?

    private let recorder = RPScreenRecorder.shared()

    func toggleRecording() {
        if isRecording {
            recorder.stopRecording { [weak self] previewController, error in
                Task { @MainActor in
                    if let error {
                        self?.errorMessage = error.localizedDescription
                    }
                    self?.isRecording = false

                    // ReplayKit can provide a preview controller here.
                    // The preview can be presented by the UI in a later iteration.
                    _ = previewController
                }
            }
        } else {
            guard recorder.isAvailable else {
                errorMessage = "Ekran kaydı bu cihazda şu anda kullanılamıyor."
                return
            }

            recorder.isMicrophoneEnabled = true

            recorder.startRecording { [weak self] error in
                Task { @MainActor in
                    if let error {
                        self?.errorMessage = error.localizedDescription
                        self?.isRecording = false
                    } else {
                        self?.isRecording = true
                    }
                }
            }
        }
    }
}

struct ScreenRecorderView: View {
    @StateObject private var model = ScreenRecorderModel()

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            ZStack {
                Circle()
                    .fill(model.isRecording ? .red.opacity(0.15) : .secondary.opacity(0.12))
                    .frame(width: 190, height: 190)

                Image(systemName: model.isRecording ? "stop.fill" : "record.circle")
                    .font(.system(size: 72))
                    .foregroundStyle(model.isRecording ? .red : .primary)
            }

            Text(model.isRecording ? "Kayıt yapılıyor" : "Hazır")
                .font(.title2.bold())

            Text(model.isRecording
                 ? "Durdurmak için aşağıdaki düğmeye dokun."
                 : "Musa Hub içindeki ekran kayıt modülü.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button {
                model.toggleRecording()
            } label: {
                Label(
                    model.isRecording ? "Kaydı Durdur" : "Kaydı Başlat",
                    systemImage: model.isRecording ? "stop.fill" : "record.circle"
                )
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
            }
            .buttonStyle(.borderedProminent)
            .tint(model.isRecording ? .red : .primary)
            .padding(.horizontal)

            if let error = model.errorMessage {
                Text(error)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Screen Recorder")
    }
}
