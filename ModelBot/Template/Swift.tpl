//
//  {$filename}.m
//  Generate by ModelBot
//
//  Created by {$author} on {$date}.
//  Copyright (c) {$year}年 {$copyright}. All rights reserved.
//

class {$filename}: NSObject {
{$hook0}

    init(${hook1}) {
        super.init()

        ${hook2}
    }

    func encodeWithCoder(aCoder: NSCoder) {
        ${hook3}
    }

    required convenience init?(coder aDecoder: NSCoder) {
        ${hook4}

        self.init(
            ${hook5}
        )
    }
}
