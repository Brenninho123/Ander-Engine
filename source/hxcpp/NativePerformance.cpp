#include <hxcpp.h>
#include <chrono>

extern "C" double getHighPrecisionTime()
{
    using namespace std::chrono;
    auto now = high_resolution_clock::now();
    auto duration = now.time_since_epoch();
    return duration_cast<duration<double>>(duration).count();
}
