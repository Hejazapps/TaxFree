/// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#ifndef RTR_API_LINKAGE

/* RTR_API_IMPORT_SPECIFICATION definition */
#define RTR_API_IMPORT_SPECIFICATION __attribute__((visibility("default")))

/* RTR_API_LINKAGE definition */
#ifdef __cplusplus
#define RTR_API_LINKAGE extern "C" RTR_API_IMPORT_SPECIFICATION
#else
#define RTR_API_LINKAGE extern RTR_API_IMPORT_SPECIFICATION
#endif

#endif /* RTR_API_LINKAGE */
