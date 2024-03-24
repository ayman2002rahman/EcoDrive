import SwiftUI

struct CarMakeView: View {
    @State private var selectedMakeIndex = 0
    let carMakes: [String]
    let carMakesAndModels: [(String, [String])]
    
    var body: some View {
        VStack {
            Picker("Select Make", selection: $selectedMakeIndex) {
                ForEach(carMakes.indices, id: \.self) { index in
                    Text(self.carMakes[index]).tag(index)
                }
            }
            .pickerStyle(DefaultPickerStyle())
            
            NavigationLink(destination: CarModelSelectionView(selectedMake: carMakes[selectedMakeIndex], carMakesAndModels: carMakesAndModels)) {
                Text("Next")
            }
        }
        .padding()
    }
}

struct CarModelSelectionView: View {
    let selectedMake: String
    let carMakesAndModels: [(String, [String])]
    @State private var selectedModel: String? // State variable to store the selected model
    
    var body: some View {
        VStack {
            Text("Select Model for \(selectedMake)")
                .font(.headline)
                .padding()
            
            List {
                ForEach(carMakesAndModels, id: \.0) { make, models in
                    if make == selectedMake {
                        ForEach(models, id: \.self) { model in
                            Button(action: {
                                self.selectedModel = model // Update selectedModel when a model is selected
                            }) {
                                Text(model)
                            }
                        }
                    }
                }
            }
            // Pass selectedMake and selectedModel to MilesRecordingView if a model is selected
            NavigationLink(destination: selectedModel.map { MilesRecordingView(selectedMake: selectedMake, selectedModel: $0) }) {
                Text("Start Recording Miles")
            }
            .disabled(selectedModel == nil) // Disable the navigation if no model is selected
        }
        .navigationBarTitle("Car Model Selection")
    }
}

struct ContentView: View {
    @State private var carMakesAndModels: [(String, [String])] = []
    
    var body: some View {
        NavigationView {
            if carMakesAndModels.isEmpty {
                Text("Loading...")
                    .onAppear(perform: loadData)
            } else {
                CarMakeView(carMakes: carMakesAndModels.map { $0.0 }, carMakesAndModels: carMakesAndModels)
                    .navigationBarTitle("Car Selection")
            }
        }
    }
    
    func loadData() {
        print("hello world")
        if let jsonURL = Bundle.main.url(forResource: "car_models", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: jsonURL)
                carMakesAndModels = processJSONData(jsonData)
            } catch {
                print("Error reading JSON file: \(error.localizedDescription)")
            }
        } else {
            print("JSON file not found in bundle.")
        }
    }
    
    func processJSONData(_ jsonData: Data) -> [(String, [String])] {
        do {
            guard let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] else {
                print("Error: Invalid JSON format")
                return []
            }
            
            var carMakesAndModels: [(String, [String])] = []
            
            for item in json {
                if let make = item["Make"] as? String, let models = item["Model"] as? [String] {
                    carMakesAndModels.append((make, models))
                }
            }
            
            return carMakesAndModels
        } catch {
            print("Error decoding JSON data: \(error.localizedDescription)")
            return []
        }
    }
}

struct CarMakeModel: Codable {
    let make: String
    let models: [String]
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

