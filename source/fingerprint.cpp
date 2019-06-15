#include "fingerprint.h"

#include<stdio.h>

UINT32 DLL_EXPORT fingerprint(const LPCSTR filename)
{
    FILE * ptr_file;

    ptr_file = fopen(filename, "rb");

    if (!ptr_file)
    {
        return 0;
    }

    fseek(ptr_file, 0, SEEK_END);

    long flen = ftell(ptr_file);

    fseek(ptr_file, 0, SEEK_SET);

    byte *buffer;

    buffer = (byte*) calloc(flen, sizeof(byte));

    fread(buffer, flen, 1, ptr_file);

    fclose(ptr_file);

    byte b;

    // Get length of data that will be used to calculate the hash
    // tab, cr, lf, and space are ignored
    // This value is used to initialize the hash to a 'random' value

    UINT32 len = 0;

    for(int i = 0; i < flen; i = i + 1)
    {
        b = buffer[i];

        if (b == 0x9 || b == 0xa || b == 0xd || b == 0x20)
        {
            continue;
        }

        len = len + 1;
    }

    const UINT32 seed = 1;

    UINT32 h = seed ^ len;

    UINT32 k = 0x0;

    const UINT32 m = 0x5bd1e995;

    const INT32 r = 24;

    INT32 shift = 0x0;

    for (int i = 0; i < flen;  i = i + 1)
    {
        b = buffer[i];

        if (b == 0x9 || b == 0xa || b == 0xd || b == 0x20)
        {
            continue;
        }

        k = k | (b << shift);

        shift = shift + 0x8;

        if (shift == 0x20)
        {
            k = k * m;

            k = k ^ (k >> r);

            k = k * m;

            h = h * m;

            h = h ^ k;

            k = 0x0;

            shift = 0x0;
        }
    }

    if (shift > 0)
    {
        h = h ^ k;

        h = h * 0x5bd1e995;
    }

    h = h ^ (h >> 13);

    h = h * 0x5bd1e995;

    h = h ^ (h >> 15);

    free(buffer);

    return h;
}

UINT32 DLL_EXPORT fingerprintold(const LPCSTR filename)
{
    FILE * ptr_file;

    ptr_file = fopen(filename, "rb");

    if (!ptr_file)
    {
        return 0;
    }

    byte b;

    UINT32 len = 0;

    while (fread( & b, 1, 1, ptr_file) > 0)
    {
        if (b == 0x9 || b == 0xa || b == 0xd || b == 0x20)
        {
            continue;
        }
        len = len + 1;
    }

    UINT32 h = 1 ^ len;

    UINT32 k = 0x0;

    INT32 shift = 0x0;

    fseek(ptr_file, 0, SEEK_SET);

    while (fread( & b, 1, 1, ptr_file) > 0)
    {
        if (b == 0x9 || b == 0xa || b == 0xd || b == 0x20)
        {
            continue;
        }

        k = k | (b << shift);

        shift = shift + 0x8;

        if (shift == 0x20)
        {
            k = k * 0x5bd1e995;

            k = k ^ (k >> 0x18);

            k = k * 0x5bd1e995;

            h = h * 0x5bd1e995;

            h = h ^ k;

            k = 0x0;

            shift = 0x0;
        }
    }

    fclose(ptr_file);

    if (shift > 0)
    {
        h = h ^ k;

        h = h * 0x5bd1e995;
    }

    h = h ^ (h >> 13);

    h = h * 0x5bd1e995;

    h = h ^ (h >> 15);

    return h;

}

extern "C"
DLL_EXPORT BOOL APIENTRY DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
{
    switch (fdwReason)
    {
    case DLL_PROCESS_ATTACH:
        // attach to process
        // return FALSE to fail DLL load
        break;

    case DLL_PROCESS_DETACH:
        // detach from process
        break;

    case DLL_THREAD_ATTACH:
        // attach to thread
        break;

    case DLL_THREAD_DETACH:
        // detach from thread
        break;
    }
    return TRUE; // succesful
}
