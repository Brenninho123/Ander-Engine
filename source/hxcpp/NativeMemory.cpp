#include <hxcpp.h>

#ifdef HX_WINDOWS
#include <windows.h>
#include <psapi.h>
#endif

extern "C" double getMemoryUsage()
{
#ifdef HX_WINDOWS
    PROCESS_MEMORY_COUNTERS info;
    GetProcessMemoryInfo(GetCurrentProcess(), &info, sizeof(info));
    return (double)info.WorkingSetSize / (1024.0 * 1024.0);
#else
    return 0.0;
#endif
}
