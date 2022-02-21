import SwiftUI

struct APODViewItem {
    let date: String
    var title: String
    var asset: APODAssetViewItem
    var explanation: String
}

extension APODViewItem: Identifiable {

    var id: String { title }
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
