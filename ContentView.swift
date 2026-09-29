import SwiftUI

struct ContentView: View {
    let modules = [
        Module(name: "AI", icon: "sparkles", color: .purple),
        Module(name: "Tools", icon: "wrench.and.screwdriver", color: .blue),
        Module(name: "Notes", icon: "note.text", color: .orange),
        Module(name: "Tasks", icon: "checklist", color: .green),
        Module(name: "Files", icon: "folder", color: .yellow),
        Module(name: "Developer", icon: "chevron.left.forwardslash.chevron.right", color: .indigo),
        Module(name: "Study", icon: "book", color: .cyan),
        Module(name: "Screen Recorder", icon: "record.circle", color: .red)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Musa Hub")
                            .font(.largeTitle.bold())
                        Text("Your all-in-one iPhone toolbox")
                            .foregroundStyle(.secondary)
                    }

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        ForEach(modules) { module in
                            NavigationLink {
                                destination(for: module)
                            } label: {
                                ModuleCard(module: module)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Home")
        }
    }

    @ViewBuilder
    private func destination(for module: Module) -> some View {
        switch module.name {
        case "Screen Recorder":
            ScreenRecorderView()
        default:
            PlaceholderView(title: module.name, icon: module.icon)
        }
    }
}

struct Module: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
}

struct ModuleCard: View {
    let module: Module

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: module.icon)
                .font(.title2)
                .foregroundStyle(module.color)
            Text(module.name)
                .font(.headline)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, minHeight: 115, alignment: .topLeading)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 22))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(.quaternary)
        }
    }
}

struct PlaceholderView: View {
    let title: String
    let icon: String

    var body: some View {
        ContentUnavailableView(
            title,
            systemImage: icon,
            description: Text("Bu modül Musa Hub'ın sonraki sürümlerinde genişletilecek.")
        )
        .navigationTitle(title)
    }
}
