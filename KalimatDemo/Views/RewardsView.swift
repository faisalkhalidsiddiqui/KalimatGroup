//
//  RewardsView.swift
//  katibaJoystic
//
//  Created by FAISAL KHALID on 13/02/2020.
//  Copyright © 2020 Faisal Khalid. All rights reserved.
//

import UIKit

import UIKit

class RewardsView: UIView {

    let nibName = "RewardsView"
    var contentView: UIView?



    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }

    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
