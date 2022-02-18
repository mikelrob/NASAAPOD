import SwiftUI
import Combine
import APODKit

public struct ContentView: View {

    @EnvironmentObject var model: APODModel

    public init() {}
    
    public var body: some View {
        ScrollView {
            APODInfoView(apodInfo: model.apodItem)
                .redacted(reason: shouldRedact ? .placeholder : [] )
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    model.selectPreviousDay()
                } label: {
                    Image(systemName: "chevron.backward")
                }

            }
            ToolbarItem(placement: .bottomBar) {
                DatePicker("Select a Date",
                           selection: $model.date,
                           in: ...Date(),
                           displayedComponents: .date)
            }
            ToolbarItem(placement: .bottomBar) {
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
