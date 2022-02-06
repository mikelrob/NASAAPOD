import SwiftUI
import Combine
import APODKit
import AVKit

struct ContentView: View {

    @EnvironmentObject var model: APODModel

    var body: some View {
        ScrollView {
            APODInfoView(apodInfo: model.apodItem)
                .redacted(reason: model.apodItem == nil ? .placeholder : [] )
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                DatePicker("Select a Date",
                           selection: $model.date,
                           in: ...Date(),
                           displayedComponents: .date)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(APODModel(dependencies: DependencyInjectionContainer()))

    }
}
