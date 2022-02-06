import SwiftUI

enum APODAssetViewItem {
    case video(URL)
    case image(CGImage)
    case loading
    case placeholder
}

struct APODAssetView: View {

    let asset: APODAssetViewItem

    var body: some View {
        switch asset {
        case let .image(cgImage):
            Image(decorative: cgImage, scale: 1)
                .resizable()
                .aspectRatio(contentMode: .fit)
        case let .video(url):
            WebView(url: url)
                .aspectRatio(contentMode: .fit)
        case .loading:
            ProgressView()
        case .placeholder:
            Image("NASALogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct APODAssetView_Previews: PreviewProvider {
    static var previews: some View {
        APODAssetView(asset: .loading)
    }
}


