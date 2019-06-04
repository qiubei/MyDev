//
//  NapDefines.m
//  BLESDK-NapMusic
//
//  Created by HyanCat on 2018/6/7.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

#import "NapDefines.h"

@implementation NPAnalyzeProcessData

- (instancetype)initWithMLPDegree:(double)mlpDegree
                        napDegree:(Byte)napDegree
                       sleepState:(Byte)sleepState
                      dataQuality:(Byte)dataQuality
                     soundControl:(Byte)soundControl
                    smoothRawData:(NSData *)smoothRawData {
    self = [super init];
    if (self) {
        self.mlpDegree = mlpDegree;
        self.napDegree = napDegree;
        self.sleepState = sleepState;
        self.dataQuality = dataQuality;
        self.soundControl = soundControl;
        self.smoothRawData = smoothRawData;
    }
    return self;
}

@end

@implementation NPFinishedResult

@end
