#include <hxcpp.h>

#ifdef HX_WINDOWS
#include <windows.h>
#include <shellapi.h>
#endif

extern "C" void openFolder(const char* path)
{
#ifdef HX_WINDOWS
    ShellExecuteA(NULL, "open", path, NULL, NULL, SW_SHOWDEFAULT);
#endif
}

extern "C" void showMessageBox(const char* title, const char* message)
{
#ifdef HX_WINDOWS
    MessageBoxA(NULL, message, title, MB_OK | MB_ICONINFORMATION);
#endif
}
