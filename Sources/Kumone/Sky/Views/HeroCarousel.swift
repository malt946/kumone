import SwiftUI

/// 首页顶部轮播图数据。
struct HeroBanner: Identifiable, Hashable {
    let id: String
    let assetName: String

    static let all: [HeroBanner] = [
        HeroBanner(id: "custom", assetName: "HeroBanner1"),
        HeroBanner(id: "weekday", assetName: "HeroBanner2"),
    ]
}

/// 首页顶部轮播：自动切换 + 分页指示点。
struct HeroCarousel: View {
    let banners: [HeroBanner]
    var height: CGFloat = 168
    var interval: TimeInterval = 4

    @State private var index = 0

    var body: some View {
        TabView(selection: $index) {
            ForEach(Array(banners.enumerated()), id: \.element.id) { offset, banner in
                Image(banner.assetName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: height)
                    .clipped()
                    .tag(offset)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: banners.count > 1 ? .always : .never))
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.panel, style: .continuous))
        .task {
            guard banners.count > 1 else { return }
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(interval))
                guard !Task.isCancelled else { break }
                withAnimation(.easeInOut(duration: 0.5)) {
                    index = (index + 1) % banners.count
                }
            }
        }
    }
}
