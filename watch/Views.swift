import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @State private var confirmReset = false

    var body: some View {
        NavigationStack {
            if store.halle == nil {
                List(halles, id: \.key) { h in
                    Button("\(h.label) · \(h.wagons)") { store.start(h) }
                }
                .navigationTitle("Halle")
            } else {
                List {
                    ForEach($store.wagons) { $w in
                        NavigationLink {
                            WagonView(wagon: $w)
                        } label: {
                            let total = w.bobines.count * 2
                            let done = w.bobines.reduce(0) { $0 + ($1.gauche.isEmpty ? 0 : 1) + ($1.droite.isEmpty ? 0 : 1) }
                            HStack {
                                Text("Wagon \(w.numero)")
                                Spacer()
                                Text("\(done)/\(total)").foregroundStyle(done == total ? .green : .secondary)
                            }
                        }
                    }
                    Button("+ Wagon") { store.addWagon() }
                    Button("Nouveau check", role: .destructive) { confirmReset = true }
                }
                .navigationTitle("Halle \(store.halle ?? "")")
                .confirmationDialog("Tout effacer ?", isPresented: $confirmReset) {
                    Button("Effacer", role: .destructive) { store.reset() }
                }
            }
        }
    }
}

struct WagonView: View {
    @Binding var wagon: Wagon

    var body: some View {
        List {
            TextField("Wagon", text: $wagon.numero)
            ForEach(wagon.bobines.indices, id: \.self) { i in
                VStack(alignment: .leading) {
                    Text(berceLabel(count: wagon.bobines.count, position: i + 1)).font(.caption)
                    HStack {
                        ValueButton(title: "G", value: $wagon.bobines[i].gauche)
                        ValueButton(title: "D", value: $wagon.bobines[i].droite)
                    }
                }
            }
            Stepper("Bobines : \(wagon.bobines.count)", onIncrement: {
                if wagon.bobines.count < 5 { wagon.bobines.append(Bobine()) }
            }, onDecrement: {
                if wagon.bobines.count > 1 { wagon.bobines.removeLast() }
            })
        }
        .navigationTitle("Wagon \(wagon.numero)")
    }
}

struct ValueButton: View {
    let title: String
    @Binding var value: String
    @State private var showPad = false

    var body: some View {
        Button { showPad = true } label: {
            Text("\(title) \(value.isEmpty ? "—" : value)")
        }
        .buttonStyle(.bordered)
        .sheet(isPresented: $showPad) { Keypad(value: $value, title: title) }
    }
}

// Pavé numérique : les valeurs sont en cm, une décimale (ex. 12.3)
struct Keypad: View {
    @Binding var value: String
    let title: String
    @Environment(\.dismiss) private var dismiss

    private let rows = [["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"], [".", "0", "⌫"]]

    var body: some View {
        VStack(spacing: 2) {
            Text("\(title) : \(value.isEmpty ? "—" : value) cm").font(.headline)
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 2) {
                    ForEach(row, id: \.self) { k in
                        Button { tap(k) } label: { Text(k == "." ? "," : k).frame(maxWidth: .infinity) }
                            .buttonStyle(.bordered)
                    }
                }
            }
        }
        .toolbar { ToolbarItem(placement: .confirmationAction) { Button("OK") { dismiss() } } }
    }

    private func tap(_ k: String) {
        switch k {
        case "⌫": if !value.isEmpty { value.removeLast() }
        case ".": if !value.contains(".") { value += value.isEmpty ? "0." : "." }
        default: if value.count < 6 { value += k }
        }
    }
}
