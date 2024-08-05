//
//  SegmentedContentConfiguration.swift
//  CardManagementSDKSwiftSample
//
//  Created by Aleksei Kiselev on 06.12.2023.
//

import UIKit

class SegmentedContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var segments: [String]? = nil
        var selectedIndex: Int = 0
        var segmentSelected: ((String) -> Void)?

        func makeContentView() -> UIView & UIContentView {
            return SegmentedContentView(configuration: self)
        }

        func updated(for state: UIConfigurationState) -> Configuration {
            return self
        }
    }
    
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: segmentedControl.intrinsicContentSize.height)
    }

    private let segmentedControl: UISegmentedControl

    required init(configuration: Configuration) {
        self.configuration = configuration
        segmentedControl = UISegmentedControl(frame: .zero)
        super.init(frame: .zero)
        addPinnedSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        configure(configuration: configuration)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        segmentedControl.removeAllSegments()
        for title in (configuration.segments ?? []) {
            segmentedControl.insertSegment(withTitle: title, at: segmentedControl.numberOfSegments, animated: false)
        }
        segmentedControl.selectedSegmentIndex = configuration.selectedIndex
    }
    
    @objc private func segmentChanged() {
        guard 
            let conf = configuration as? Configuration,
            let segments = conf.segments,
            segments.count > segmentedControl.selectedSegmentIndex
        else { return }
        conf.segmentSelected?(segments[segmentedControl.selectedSegmentIndex])
    }
}

extension UICollectionViewListCell {
    func segmentedConfiguration() -> SegmentedContentView.Configuration {
        SegmentedContentView.Configuration()
    }
}
