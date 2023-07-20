//
//  WCAG-Colors
//
//  Copyright (c) 2021 Christoph Wendt
//

#if os(OSX)

    import AppKit

    extension CIImage {
        convenience init?(image: NSImage) {
            guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
                return nil
            }

            self.init(cgImage: cgImage)
        }
    }

#endif
