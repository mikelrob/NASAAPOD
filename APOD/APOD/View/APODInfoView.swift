import SwiftUI

struct APODViewItem {
    var title: String
    var asset: APODAssetViewItem
    var explanation: String
}
extension APODViewItem: Equatable { }

extension APODViewItem {
     static let loading = APODViewItem(title: "Placeholder",
                                       asset: APODAssetViewItem.loading,
                                       explanation: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
 }

extension APODViewItem {
     static let placeholder = APODViewItem(title: "Placeholder",
                                           asset: APODAssetViewItem.placeholder,
                                           explanation: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
 }

struct APODInfoView: View {

    let apodInfo: APODViewItem?

    var body: some View {
        VStack(alignment: .leading) {
            APODAssetView(asset: apodInfo?.asset ?? .loading)
                .unredacted()
            Text(apodInfo?.title ?? "Title")
                .fontWeight(.heavy)
                .padding()

            Text(apodInfo?.explanation ?? "Explanation")
                .padding()
        }
    }
}

struct APODInfoView_Previews: PreviewProvider {

    static var previews: some View {
        APODInfoView(apodInfo: nil)
    }
}
