FFMpegBuildScript
=================

A ffmpeg build script for Android


If you want build for x86, you should make change like this:
=================
```
diff --git a/libavcodec/x86/mpegvideoenc.c b/libavcodec/x86/mpegvideoenc.c
index b410511..5144f42 100644
--- a/libavcodec/x86/mpegvideoenc.c
+++ b/libavcodec/x86/mpegvideoenc.c
@@ -210,26 +210,26 @@ av_cold void ff_dct_encode_init_x86(MpegEncContext *s)
         int cpu_flags = av_get_cpu_flags();
         if (INLINE_MMX(cpu_flags)) {
 #if HAVE_6REGS
-            s->dct_quantize = dct_quantize_mmx;
+//            s->dct_quantize = dct_quantize_mmx;
 #endif
             s->denoise_dct  = denoise_dct_mmx;
         }
 #endif
 #if HAVE_6REGS && HAVE_MMXEXT_INLINE
-        if (INLINE_MMXEXT(cpu_flags))
-            s->dct_quantize = dct_quantize_mmxext;
+//        if (INLINE_MMXEXT(cpu_flags))
+//            s->dct_quantize = dct_quantize_mmxext;
 #endif
-#if HAVE_SSE2_INLINE
+//#if HAVE_SSE2_INLINE
         if (INLINE_SSE2(cpu_flags)) {
-#if HAVE_6REGS
-            s->dct_quantize = dct_quantize_sse2;
-#endif
+//#if HAVE_6REGS
+//            s->dct_quantize = dct_quantize_sse2;
+//#endif
             s->denoise_dct  = denoise_dct_sse2;
         }
-#endif
+//#endif
 #if HAVE_6REGS && HAVE_SSSE3_INLINE
-        if (INLINE_SSSE3(cpu_flags))
-            s->dct_quantize = dct_quantize_ssse3;
+//        if (INLINE_SSSE3(cpu_flags))
+//            s->dct_quantize = dct_quantize_ssse3;
 #endif
     }
 }
```
