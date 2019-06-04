//
// Created by 雷京颢 on 2018/6/8.
//

#ifndef ENTEREEG_ENTEREEG_H
#define ENTEREEG_ENTEREEG_H

#include "define/Data.h"
#include "define/Device.h"
#include "dsp/Preprocessor.h"
#include "dsp/Processor.h"
#include "numpy/Basic.h"
#include "network/keras.h"
#include "legacy/Basic.h"
#include "legacy/Curvefit.h"
#include "legacy/FFT.h"
#include "legacy/Number.h"
#include "legacy/Polyfun.h"
#include "legacy/Wavelet.h"
#include "legacy/Windowfun.h"
#include "io/Basic.h"
#include "io/FileHeader.h"
#include "io/NapAnalyzedData.h"
#include "io/NapReportData.h"

#include <string>

namespace EnterTech {
namespace EnterEEG {

const std::string VERSION = "1.1.2";

}
}

#endif //ENTEREEG_ENTEREEG_H
