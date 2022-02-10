import SwiftUI

struct APODViewItem: Equatable {    
    var title: String
    var asset: APODAssetViewItem
    var explanation: String
}

extension APODViewItem {
    static let placeholder = APODViewItem(title: "Placeholder",
                                          asset: APODAssetViewItem.placeholder,
                                          explanation: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
}

struct APODInfoView: View {

    let apodInfo: APODViewItem

    var body: some View {
        VStack(alignment: .leading) {
            APODAssetView(asset: apodInfo.asset)
                .unredacted()
            Text(apodInfo.title)
                .fontWeight(.heavy)
                .padding()
            Text(apodInfo.explanation)
                .padding()
        }
    }
}

//struct APODInfoView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        APODInfoView(apodInfo: nil)
//    }
//}
