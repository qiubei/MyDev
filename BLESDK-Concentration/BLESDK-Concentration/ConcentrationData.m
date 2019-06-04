//
//  ConcentrationData.m
//  BLESDK-Concentration
//
//  Created by HyanCat on 2018/5/22.
//  Copyright © 2018 EnterTech. All rights reserved.
//

#import "ConcentrationData.h"

struct Array ArrayMake(NSInteger *point, NSUInteger length)
{
    struct Array array;
    array.point = point;
    array.length = length;
    return array;
}

@implementation ConcentrationData
@end
