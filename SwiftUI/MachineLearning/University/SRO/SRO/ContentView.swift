import SwiftUI

struct Pet: Identifiable {
    let id = UUID()
    let name: String
    let weight: Double
    
    init(name: String, weight: Double) {
        self.name = name
        self.weight = weight
    }
}

struct ContentView: View {
    @State private var pets: [Pet] = [
        Pet(name: "Whiskers", weight: 5.2),
        Pet(name: "Rex", weight: 8.7),
        Pet(name: "Fluffy", weight: 6.9)
    ]
    
    @State private var newPetName: String = ""
    @State private var newPetWeight: String = ""
    
    @State private var median: Double = 0
    @State private var deviation: Double = 0
    @State private var variance: Double = 0
    @State private var skewness: Double = 0
    @State private var correlation: Double = 0
    @State private var mean: Double = 0 // Added mean
    @State private var mode: Double = 0 // Added mode
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter pet name", text: $newPetName)
                    .padding()
                TextField("Enter pet weight", text: $newPetWeight)
                    .padding()
                Button("Add", action: addPet)
                    .padding()
            }
            
            Button("Calculate", action: calculateData)
                .padding()
            Text("Медиана: \(median)")
            Text("Стандартное отклонение: \(deviation)")
            Text("Дисперсия: \(variance)")
            Text("Асимметрия: \(skewness)")
            Text("Среднее арифметическое: \(mean)") // Display mean
            Text("Мода: \(mode)") // Display mode
            
            Graph(pets: pets)
                .frame(height: 300)
                .padding()
        }
        .onAppear {
            // Add some existing data
            pets.append(Pet(name: "Snowball", weight: 4.5))
            pets.append(Pet(name: "Max", weight: 9.1))
        }
    }
    
    func addPet() {
        guard let weight = Double(newPetWeight) else { return }
        let newPet = Pet(name: newPetName, weight: weight)
        pets.append(newPet)
        newPetName = ""
        newPetWeight = ""
    }
    
    func calculateData() {
        let weights = pets.map { $0.weight }
        median = calculateMedian(weights)
        deviation = calculateStandardDeviation(weights)
        variance = calculateVariance(weights)
        skewness = calculateSkewness(weights)
        mean = calculateMean(weights) // Calculate mean
        mode = calculateMode(weights) // Calculate mode
        correlation = calculateCorrelation(weights)
    }

    func calculateMedian(_ data: [Double]) -> Double {
        let sortedData = data.sorted()
        let count = sortedData.count
        if count % 2 == 0 {
            return (sortedData[count / 2 - 1] + sortedData[count / 2]) / 2
        } else {
            return sortedData[count / 2]
        }
    }

    func calculateStandardDeviation(_ data: [Double]) -> Double {
        let mean = calculateMean(data)
        let squaredDifferences = data.map { pow($0 - mean, 2) }
        let variance = squaredDifferences.reduce(0, +) / Double(data.count)
        return sqrt(variance)
    }

    func calculateVariance(_ data: [Double]) -> Double {
        let mean = calculateMean(data)
        let squaredDifferences = data.map { pow($0 - mean, 2) }
        return squaredDifferences.reduce(0, +) / Double(data.count)
    }

    func calculateSkewness(_ data: [Double]) -> Double {
        let mean = calculateMean(data) 
        let variance = calculateVariance(data)
        let cubedDifferences = data.map { pow($0 - mean, 3) }
        let skewness = cubedDifferences.reduce(0, +) / Double(data.count)
        return skewness / pow(variance, 1.5)
    }

    func calculateMean(_ data: [Double]) -> Double {
        let sum = data.reduce(0, +)
        return sum / Double(data.count)
    }

    func calculateMode(_ data: [Double]) -> Double {
        var occurrences: [Double: Int] = [:]
        data.forEach { occurrences[$0, default: 0] += 1 }
        let mode = occurrences.max { $0.value < $1.value }?.key ?? 0
        return mode
    }

    func calculateCorrelation(_ data: [Double]) -> Double {
        // Implement correlation calculation logic here
        return 0 // Placeholder, replace with actual calculation
    }
}

struct Graph: View {
    let pets: [Pet]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Animal names and weights
                ForEach(pets) { pet in
                    let index = pets.firstIndex(where: { $0.id == pet.id })!
                    let x = geometry.size.width / CGFloat(self.pets.count - 1) * CGFloat(index)
                    let y = geometry.size.height * (1 - CGFloat(pet.weight) / CGFloat(self.pets.map { $0.weight }.max() ?? 1))
                    Text(pet.name)
                        .position(x: x, y: y) // Adjust position
                        .font(.footnote)
                    Text("\(pet.weight, specifier: "%.1f")")
                        .position(x: x, y: y - 20) // Adjust position
                        .font(.footnote)
                }
                
                // Graph
                Path { path in
                    path.move(to: CGPoint(x: 0, y: geometry.size.height))
                    for i in 0..<self.pets.count {
                        let x = geometry.size.width / CGFloat(self.pets.count - 1) * CGFloat(i)
                        let y = geometry.size.height * (1 - CGFloat(self.pets[i].weight) / CGFloat(self.pets.map { $0.weight }.max() ?? 1))
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                .stroke(Color.blue, lineWidth: 2)
                
                // Border
                Rectangle()
                    .stroke(Color.gray, lineWidth: 1)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .padding(10) // Add padding inside GeometryReader
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
