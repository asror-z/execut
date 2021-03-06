#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <ScreenCapture.au3>
#include <WinAPI.au3>

Example()

Func Example()
	Local $hBitmap1, $hBitmap2, $hImage1, $hImage2, $hGraphics

	; Initialize GDI+ library
	_GDIPlus_Startup()

	; Capture full screen
	$hBitmap1 = _ScreenCapture_Capture("")
	$hImage1 = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap1)

	; Capture screen region
	$hBitmap2 = _ScreenCapture_Capture("", 0, 0, 400, 300)
	$hImage2 = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap2)

	; Draw one image in another
	$hGraphics = _GDIPlus_ImageGetGraphicsContext($hImage1)
	_GDIPlus_GraphicsDrawImage($hGraphics, $hImage2, 100, 100)

	; Draw a frame around the inserted image
	_GDIPlus_GraphicsDrawRect($hGraphics, 100, 100, 400, 300)

	; Save resultant image
	_GDIPlus_ImageSaveToFile($hImage1, @MyDocumentsDir & "\GDIPlus_Image.jpg")

	; Clean up resources
	_GDIPlus_GraphicsDispose($hGraphics)
	_GDIPlus_ImageDispose($hImage1)
	_GDIPlus_ImageDispose($hImage2)
	_WinAPI_DeleteObject($hBitmap1)
	_WinAPI_DeleteObject($hBitmap2)

	; Shut down GDI+ library
	_GDIPlus_Shutdown()

	ShellExecute(@MyDocumentsDir & "\GDIPlus_Image.jpg")
EndFunc   ;==>Example
