import SwiftUI
import Combine
import APODKit
import AVKit

struct ContentView: View {

    @EnvironmentObject var model: APODModel

    var body: some View {
        ScrollView {
            APODInfoView(apodInfo: model.apodItem)
                .redacted(reason: shouldRedact ? .placeholder : [] )
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    model.selectPreviousDay()
                } label: {
                    Image(systemName: "chevron.backward")
                }
                
                DatePicker("Select a Date",
                           selection: $model.date,
                           in: ...Date(),
                           displayedComponents: .date)
                Button {
                    model.selectNextDay()
                } label: {
                    Image(systemName: "chevron.forward")
                }
            }
        }
    }
    
    private var shouldRedact: Bool {
             model.apodItem == .placeholder || model.apodItem == .loading
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(APODModel(dependencies: DependencyInjectionContainer()))

    }
}
