/// ABBYY Mobile Capture © 2020 ABBYY Development, Inc.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#ifndef ABBYYUI_EXTERN

/* ABBYYUI_API_IMPORT_SPECIFICATION definition */
#define ABBYYUI_API_IMPORT_SPECIFICATION __attribute__((visibility("default")))

/* ABBYYUI_EXTERN definition */
#ifdef __cplusplus
#define ABBYYUI_EXTERN extern "C" ABBYYUI_API_IMPORT_SPECIFICATION
#else
#define ABBYYUI_EXTERN extern ABBYYUI_API_IMPORT_SPECIFICATION
#endif

#endif /* ABBYYUI_EXTERN */
