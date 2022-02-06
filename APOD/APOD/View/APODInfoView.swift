import SwiftUI

struct APODViewItem {
    var title: String
    var asset: APODAssetViewItem
    var explanation: String
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
