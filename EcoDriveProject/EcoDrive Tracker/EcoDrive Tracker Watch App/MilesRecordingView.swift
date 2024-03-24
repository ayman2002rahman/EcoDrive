import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    @Published var distanceTraveled: CLLocationDistance = 0.0
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        // Handle location updates to calculate distance traveled
    }
}

struct MilesRecordingView: View {
    let selectedMake: String
    let selectedModel: String
    
    @ObservedObject var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            Text("Recording Miles for: \(selectedModel)")
            Text("Distance Traveled: \(String(format: "%.2f", locationManager.distanceTraveled)) miles")
            
            Button("End Recording") {
                // Action to end recording and navigate to a new view
                // You can perform navigation here using NavigationLink or NavigationStack
                // Example:
                // self.isPresentingNewView = true
            }
            .padding()
        }
    }
}



/*
struct MilesRecordingView_Previews: PreviewProvider {MV
    static var previews: some View {
        MilesRecordingView(selectedMake: "Honda", selectedModel: "ooga")
    }
}*/

