import Foundation

struct Bobine: Codable { var gauche = ""; var droite = "" }

struct Wagon: Codable, Identifiable {
    var id = UUID()
    var numero: String
    var bobines = [Bobine()]
}

let halles: [(key: String, label: String, wagons: Int)] = [
    ("46", "Halle 46", 10), ("43", "Halle 43", 7), ("03", "Halle 03", 14)
]

// Même table que l'app web (BERCE_MAP)
func berceLabel(count: Int, position: Int) -> String {
    let map: [Int: [Int]] = [1: [12], 2: [12, 52], 3: [12, 32, 52], 4: [12, 22, 42, 52], 5: [12, 22, 32, 42, 52]]
    let arr = map[count] ?? map[5]!
    return "Berce \(arr[position - 1])"
}

final class Store: ObservableObject {
    private struct Saved: Codable { var halle: String?; var wagons: [Wagon] }
    private let key = "finalCheck"

    @Published var halle: String? { didSet { save() } }
    @Published var wagons: [Wagon] { didSet { save() } }

    init() {
        let s = UserDefaults.standard.data(forKey: key).flatMap { try? JSONDecoder().decode(Saved.self, from: $0) }
        halle = s?.halle
        wagons = s?.wagons ?? []
    }

    private func save() {
        if let d = try? JSONEncoder().encode(Saved(halle: halle, wagons: wagons)) {
            UserDefaults.standard.set(d, forKey: key)
        }
    }

    func start(_ h: (key: String, label: String, wagons: Int)) {
        wagons = (1...h.wagons).map { Wagon(numero: String($0)) }
        halle = h.key
    }

    func addWagon() { wagons.append(Wagon(numero: String(wagons.count + 1))) }

    func reset() { halle = nil; wagons = [] }
}
