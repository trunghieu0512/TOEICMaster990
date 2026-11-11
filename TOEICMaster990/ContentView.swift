import SwiftUI
import AVFoundation

@main
struct TOEICMaster990App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - 1. DATA MODELS
struct RoadmapStage: Identifiable {
    let id = UUID()
    let band: String
    let title: String
    let focus: String
    let teacherTip: String
    let modules: [String]
}

struct TOEICQuestion: Identifiable {
    let id = UUID()
    let part: String
    let transcriptOrQuestion: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
    let trapNote: String
}

struct VocabItem: Identifiable {
    let id = UUID()
    let word: String
    let ipa: String
    let meaning: String
    let synonym: String
    let example: String
}

// MARK: - 2. SPEECH ENGINE (US & UK ACCENTS)
class SpeechService: ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()
    @Published var accent: String = "en-US"
    @Published var rate: Float = 0.48

    func speak(_ text: String) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: accent)
        utterance.rate = rate
        synthesizer.speak(utterance)
    }
}

// MARK: - 3. MAIN TAB VIEW
struct ContentView: View {
    @StateObject private var speech = SpeechService()

    var body: some View {
        TabView {
            RoadmapView()
                .tabItem {
                    Label("Lộ trình 990", systemImage: "map.fill")
                }
            PracticeRoomView(speech: speech)
                .tabItem {
                    Label("Luyện 7 Parts", systemImage: "headphones")
                }
            FlashcardView(speech: speech)
                .tabItem {
                    Label("600+ Từ vựng", systemImage: "rectangle.stack.fill")
                }
        }
        .tint(.indigo)
    }
}

// MARK: - TAB 1: ROADMAP 0 -> 990
struct RoadmapView: View {
    let stages: [RoadmapStage] = [
        RoadmapStage(
            band: "Chặng 1: 0 - 350+",
            title: "Xây nền Ngữ âm & Ngữ pháp cốt lõi",
            focus: "Làm chủ bảng IPA, nghe bắt từ khóa Part 1-2 và 6 thì cơ bản",
            teacherTip: "Tuyệt đối không dịch từng chữ. Hãy tập trung nghe Động từ chính và Danh từ trong tranh Part 1.",
            modules: ["44 Âm IPA & Nối âm Mỹ - Anh", "Từ loại (Danh - Động - Tính - Trạng)", "150 Từ vựng văn phòng cơ bản"]
        ),
        RoadmapStage(
            band: "Chặng 2: 350 - 650+",
            title: "Tăng tốc Kỹ năng & Phá bẫy ETS",
            focus: "Nắm trọn bẫy Part 2, Skimming Part 3-4 và giải Part 5 trong 15 giây/câu",
            teacherTip: "Ở Part 2, câu trả lời lặp lại y hệt từ trong câu hỏi 90% là bẫy sai. Hãy chọn câu trả lời gián tiếp!",
            modules: ["Phản xạ câu hỏi Wh- & Yes/No gián tiếp", "Đọc trước 3 câu hỏi Part 3-4 trong 8 giây", "Collocations thương mại高频"]
        ),
        RoadmapStage(
            band: "Chặng 3: 650 - 850+",
            title: "Bứt phá Paraphrasing & Đọc ghép đoạn",
            focus: "Xử lý biểu đồ/lịch trình Part 3-4 và nối thông tin 2-3 đoạn văn Part 7",
            teacherTip: "Đáp án đúng trên giấy luôn là từ đồng nghĩa (Paraphrase) với từ trong băng nghe hoặc bài đọc.",
            modules: ["Bảng 300 cặp từ đồng nghĩa ETS", "Kỹ thuật suy luận ngầm (Implied Meaning)", "Quản lý 75 phút Reading không cháy giờ"]
        ),
        RoadmapStage(
            band: "Chặng 4: 850 - 990",
            title: "Đỉnh cao Thực chiến & Từ vựng C1/C2",
            focus: "Xử lý câu điền câu vào đoạn (Part 6) và 5% câu từ vựng khó nhất đề thi",
            teacherTip: "Để đạt 990, bạn không được phép sai bất kỳ câu ngữ pháp Part 5 nào và phải hoàn thành Part 7 dư 5 phút.",
            modules: ["Đề Full Test ETS tốc độ 1.15x", "Bẫy ngữ cảnh đa nghĩa thương mại", "Chiến thuật phân bổ sức bền 120 phút"]
        )
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(stages) { stage in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(stage.band)
                                .font(.caption.bold())
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.indigo.opacity(0.15))
                                .foregroundColor(.indigo)
                                .cornerRadius(8)

                            Text(stage.title)
                                .font(.headline)

                            Text(stage.focus)
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            Divider()

                            ForEach(stage.modules, id: \.self) { mod in
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text(mod)
                                        .font(.subheadline)
                                }
                            }

                            Text("💡 Lời khuyên Giảng viên: \(stage.teacherTip)")
                                .font(.caption)
                                .padding(10)
                                .background(Color.orange.opacity(0.12))
                                .cornerRadius(8)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(14)
                    }
                }
                .padding()
            }
            .navigationTitle("Lộ trình 0 → 990 TOEIC")
        }
    }
}

// MARK: - TAB 2: PRACTICE ROOM (7 PARTS)
struct PracticeRoomView: View {
    @ObservedObject var speech: SpeechService
    @State private var currentIdx = 0
    @State private var selectedOption: Int? = nil

    let questions: [TOEICQuestion] = [
        TOEICQuestion(
            part: "Part 2: Hỏi - Đáp (Bẫy lặp từ)",
            transcriptOrQuestion: "When will the quarterly financial report be finalized?",
            options: [
                "(A) In the main conference room.",
                "(B) We are still waiting for the sales figures from the Tokyo branch.",
                "(C) Yes, the finance department is on the third floor."
            ],
            correctIndex: 1,
            explanation: "Câu hỏi 'When' (Khi nào) nhưng được trả lời gián tiếp bằng lý do trì hoãn: 'Chúng tôi vẫn đang đợi số liệu bán hàng từ chi nhánh Tokyo'.",
            trapNote: "Câu (C) chứa bẫy âm gần giống 'financial' -> 'finance' và dùng Yes/No cho câu hỏi When (Sai hoàn toàn)."
        ),
        TOEICQuestion(
            part: "Part 5: Ngữ pháp 5 Giây (Từ loại)",
            transcriptOrQuestion: "All assembly line technicians must wear ------- protective gear before entering the paint shop.",
            options: [
                "(A) appropriate",
                "(B) appropriately",
                "(C) appropriateness",
                "(D) appropriated"
            ],
            correctIndex: 0,
            explanation: "Trước cụm danh từ 'protective gear' cần một Tính từ (Adjective) bổ nghĩa cho danh từ 'gear'. Đáp án (A) appropriate (phù hợp) là tính từ.",
            trapNote: "Không nhìn nghĩa cả câu! Chỉ nhìn khoảng trống trước danh từ -> Chọn ngay tính từ trong 5 giây."
        ),
        TOEICQuestion(
            part: "Part 7: Đọc hiểu Paraphrasing",
            transcriptOrQuestion: "[Thông báo nội bộ]: Due to scheduled maintenance on the main server this Sunday, employees are advised to save all documents locally before leaving on Friday.\n\nHỏi: What are staff members instructed to do?",
            options: [
                "(A) Work overtime on Sunday.",
                "(B) Back up their files on their own computers.",
                "(C) Replace the main office server."
            ],
            correctIndex: 1,
            explanation: "Cụm 'save all documents locally' (lưu tài liệu vào máy cục bộ) được paraphrase thành 'Back up their files on their own computers'.",
            trapNote: "Đáp án (A) và (C) lấy các từ có trong bài (Sunday, main server) nhưng ghép sai hành động."
        )
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                let q = questions[currentIdx]
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(q.part)
                            .font(.caption.bold())
                            .padding(8)
                            .background(Color.indigo.opacity(0.15))
                            .foregroundColor(.indigo)
                            .cornerRadius(8)
                        Spacer()
                        Picker("Giọng", selection: $speech.accent) {
                            Text("🇺🇸 US").tag("en-US")
                            Text("🇬🇧 UK").tag("en-GB")
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 130)
                    }

                    Text(q.transcriptOrQuestion)
                        .font(.body.weight(.medium))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)

                    Button {
                        speech.speak(q.transcriptOrQuestion)
                    } label: {
                        Label("Nghe phát âm chuẩn bài thi", systemImage: "speaker.wave.2.fill")
                            .font(.subheadline.bold())
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color.indigo)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    ForEach(0..<q.options.count, id: \.self) { idx in
                        Button {
                            selectedOption = idx
                        } label: {
                            HStack {
                                Text(q.options[idx])
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                if selectedOption == idx {
                                    Image(systemName: idx == q.correctIndex ? "checkmark.circle.fill" : "xmark.circle.fill")
                                }
                            }
                            .padding()
                            .background(
                                selectedOption == idx
                                ? (idx == q.correctIndex ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                                : Color(.secondarySystemBackground)
                            )
                            .foregroundColor(.primary)
                            .cornerRadius(10)
                        }
                    }

                    if selectedOption != nil {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("✅ Giải thích chuyên sâu:")
                                .font(.subheadline.bold())
                                .foregroundColor(.green)
                            Text(q.explanation)
                                .font(.subheadline)
                            Divider()
                            Text("⚠️ Bẫy ETS cần nhớ:")
                                .font(.subheadline.bold())
                                .foregroundColor(.orange)
                            Text(q.trapNote)
                                .font(.caption)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    }

                    HStack {
                        Button("Câu trước") {
                            if currentIdx > 0 {
                                currentIdx -= 1
                                selectedOption = nil
                            }
                        }
                        .disabled(currentIdx == 0)
                        Spacer()
                        Text("Câu \(currentIdx + 1)/\(questions.count)")
                            .font(.caption)
                        Spacer()
                        Button("Câu tiếp theo") {
                            if currentIdx + 1 < questions.count {
                                currentIdx += 1
                                selectedOption = nil
                            }
                        }
                        .disabled(currentIdx + 1 == questions.count)
                    }
                    .padding(.top, 8)
                }
                .padding()
            }
            .navigationTitle("Phòng luyện 7 Parts")
        }
    }
}

// MARK: - TAB 3: FLASHCARDS 600+ VOCAB
struct FlashcardView: View {
    @ObservedObject var speech: SpeechService
    @State private var index = 0
    @State private var isFlipped = false

    let cards: [VocabItem] = [
        VocabItem(word: "Tentative", ipa: "/ˈtentətɪv/", meaning: "Dự kiến, tạm thời (chưa chốt)", synonym: "Provisional / Subject to change", example: "We have set a tentative schedule for the staff training."),
        VocabItem(word: "Mandatory", ipa: "/ˈmændətɔːri/", meaning: "Bắt buộc (theo quy định)", synonym: "Compulsory / Required / Obligatory", example: "Attendance at the safety briefing is mandatory for all personnel."),
        VocabItem(word: "Reimburse", ipa: "/ˌriːɪmˈbɜːrs/", meaning: "Hoàn trả lại tiền (công tác phí)", synonym: "Refund / Compensate", example: "The HR department will reimburse your travel expenses.")
    ]

    var body: some View {
        NavigationStack {
            let item = cards[index]
            VStack(spacing: 20) {
                VStack(spacing: 14) {
                    Text(item.word)
                        .font(.largeTitle.bold())
                        .foregroundColor(.indigo)
                    Text(item.ipa)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Button {
                        speech.speak(item.word + ". " + item.example)
                    } label: {
                        Label("Phát âm từ & câu ví dụ", systemImage: "speaker.wave.3.fill")
                            .font(.caption.bold())
                            .padding(8)
                            .background(Color.indigo.opacity(0.15))
                            .cornerRadius(8)
                    }

                    if isFlipped {
                        Divider()
                        Text(item.meaning)
                            .font(.title3.bold())
                        Text("Đồng nghĩa Part 7: \(item.synonym)")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                        Text("\"\(item.example)\"")
                            .font(.footnote.italic())
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                    } else {
                        Text("Chạm vào thẻ để lật xem nghĩa & từ đồng nghĩa")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 20)
                    }
                }
                .padding(28)
                .frame(maxWidth: .infinity, minHeight: 280)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(20)
                .onTapGesture {
                    withAnimation { isFlipped.toggle() }
                }

                HStack(spacing: 20) {
                    Button("Từ trước") {
                        if index > 0 { index -= 1; isFlipped = false }
                    }
                    .buttonStyle(.bordered)

                    Button("Từ tiếp theo") {
                        if index + 1 < cards.count { index += 1; isFlipped = false }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .navigationTitle("600+ Từ vựng ETS")
        }
    }
}
