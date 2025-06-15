import Foundation
import SwiftUI

struct WrapHStack: View {
    let tags: [String]
    let spacing: CGFloat = 8

    var body: some View {
        VStack(alignment: .leading) {
            var width = CGFloat.zero
            var height = CGFloat.zero

            GeometryReader { geometry in
                ZStack(alignment: .topLeading) {
                    ForEach(tags, id: \.self) { tag in
                        Text(tag)
                            .padding(8)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                            .font(.caption)
                            .alignmentGuide(.leading) { d in
                                if abs(width - d.width) > geometry.size.width {
                                    width = 0
                                    height -= d.height + spacing
                                }
                                let result = width
                                if tag == tags.last! {
                                    width = 0 
                                } else {
                                    width -= d.width + spacing
                                }
                                return result
                            }
                            .alignmentGuide(.top) { _ in
                                let result = height
                                if tag == tags.last! {
                                    height = 0
                                }
                                return result
                            }
                    }
                }
            }
            .frame(height: CGFloat(tags.count) * 30)
        }
    }
}
