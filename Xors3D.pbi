; *=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D's low-level declarations.
; Converted in 2012 by Guevara-chan.
; *=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

IncludeFile "Xors3d[decls].pbi"

; Log levels
#LOG_NO            = 5
#LOG_FATAL         = 4
#LOG_ERROR         = 3
#LOG_WARNING       = 2
#LOG_MESSAGE       = 1
#LOG_INFO          = 0

; Log targets
#LOG_HTML             = 1
#LOG_COUT             = 2
#LOG_STRING           = 4

; Skinning types
#SKIN_SOFTWARE = 2
#SKIN_HARDWARE = 1

; Light sources types
#LIGHT_DIRECTIONAL = 1
#LIGHT_POINT       = 2
#LIGHT_SPOT        = 3

; Texture filtering
#TF_NONE           = 0
#TF_POINT          = 1
#TF_LINEAR         = 2
#TF_ANISOTROPIC    = 3
#TF_ANISOTROPICX4  = 4
#TF_ANISOTROPICX8  = 5
#TF_ANISOTROPICX16 = 6

; PixelShader versions
#PS_1_1 = 0
#PS_1_2 = 1
#PS_1_3 = 2
#PS_1_4 = 3
#PS_2_0 = 4
#PS_3_0 = 5

; VertexShader versions
#VS_1_1 = 0
#VS_2_0 = 1
#VS_3_0 = 2

; Matrix semantics
#WORLD                         = 0
#WORLDVIEWPROJ                 = 1
#VIEWPROJ                      = 2
#VIEW                          = 3
#PROJ                          = 4
#WORLDVIEW                     = 5
#VIEWINVERSE                   = 6
#WORLDINVERSETRANSPOSE         = 15
#WORLDINVERSE                  = 16
#WORLDTRANSPOSE                = 17
#VIEWPROJINVERSE               = 18
#VIEWPROJINVERSETRANSPOSE      = 19
#VIEWTRANSPOSE                 = 20
#VIEWINVRSETRANSPOSE           = 21
#PROJINVERSE                   = 22
#PROJTRANSPOSE                 = 23
#PROJINVRSETRANSPOSE           = 24
#WORLDVIEWPROJTRANSPOSE        = 25
#WORLDVIEWPROJINVERSE          = 26
#WORLDVIEWPROJINVERSETRANSPOSE = 27
#WORLDVIEWTRANSPOSE            = 28
#WORLDVIEWINVERSE              = 29
#WORLDVIEWINVERSETRANSPOSE     = 30

; Antialiasing types
#AANONE      = 0
#AA2SAMPLES  = 1
#AA3SAMPLES  = 2
#AA4SAMPLES  = 3
#AA5SAMPLES  = 4
#AA6SAMPLES  = 5
#AA7SAMPLES  = 6
#AA8SAMPLES  = 7
#AA9SAMPLES  = 8
#AA10SAMPLES = 9
#AA11SAMPLES = 10
#AA12SAMPLES = 11
#AA13SAMPLES = 12
#AA14SAMPLES = 13
#AA15SAMPLES = 14
#AA16SAMPLES = 15

; Camera fog mode
#FOG_NONE     = 0
#FOG_LINEAR   = 1

; Camera projection mode
#PROJ_DISABLE      = 0
#PROJ_PERSPECTIVE	= 1
#PROJ_ORTHOGRAPHIC = 2

; Entity FX flags
#FX_NOTHING        = 0
#FX_FULLBRIGHT     = 1
#FX_VERTEXCOLOR    = 2
#FX_FLATSHADED     = 4
#FX_DISABLEFOG     = 8
#FX_DISABLECULLING = 16
#FX_NOALPHABLEND   = 32

; Entity blending modes
#BLEND_ALPHA       = 1
#BLEND_MULTIPLY    = 2
#BLEND_ADD         = 3
#BLEND_PUREADD     = 4

; Compare Macros
#CMP_NEVER         = 1
#CMP_LESS          = 2
#CMP_EQUAL         = 3
#CMP_LESSEQUAL     = 4
#CMP_GREATER       = 5
#CMP_NOTEQUAL      = 6
#CMP_GREATEREQUAL  = 7
#CMP_ALWAYS        = 8

; Axis
#AXIS_X    = 1
#AXIS_Y    = 2
#AXIS_Z    = 3

; Texture loading flags
#FLAGS_COLOR             = 1
#FLAGS_ALPHA             = 2
#FLAGS_MASKED            = 4
#FLAGS_MIPMAPPED         = 8
#FLAGS_CLAMPU            = 16
#FLAGS_CLAMPV            = 32
#FLAGS_SPHERICALENVMAP   = 64
#FLAGS_CUBICENVMAP       = 128
#FLAGS_R32F              = 256
#FLAGS_SKIPCACHE         = 512
#FLAGS_VOLUMETEXTURE     = 1024
#FLAGS_ARBG16F           = 2048
#FLAGS_ARBG32F           = 4096

; Texture blending modes
#TEXBLEND_NONE          = 0
#TEXBLEND_ALPHA         = 1
#TEXBLEND_MULTIPLY      = 2
#TEXBLEND_ADD           = 3
#TEXBLEND_DOT3          = 4
#TEXBLEND_LIGHTMAP      = 5
#TEXBLEND_SEPARATEALPHA = 6

; Cube map faces
#FACE_LEFT     = 0
#FACE_FORWARD  = 1
#FACE_RIGHT    = 2
#FACE_BACKWARD = 3
#FACE_UP       = 4
#FACE_DOWN     = 5

; Entity animation types
#ANIMATION_STOP      = 0
#ANIMATION_LOOP      = 1
#ANIMATION_PINGPONG  = 2
#ANIMATION_ONE       = 3

; Collision types
#SPHERETOSPHERE  = 1
#SPHERETOBOX     = 3
#SPHERETOTRIMESH = 2

; Collision respones types
#RESPONSE_STOP             = 1
#RESPONSE_SLIDING          = 2
#RESPONSE_SLIDING_DOWNLOCK = 3

; Entity picking modes
#PICK_NONE     = 0
#PICK_SPHERE   = 1
#PICK_TRIMESH  = 2
#PICK_BOX      = 3

; Sprite view modes
#SPRITE_FIXED    = 1
#SPRITE_FREE     = 2
#SPRITE_FREEROLL = 3
#SPRITE_FIXEDYAW = 4

; Joystick types
#JOY_NONE    = 0
#JOY_DIGITAL = 1
#JOY_ANALOG  = 2

; Cubemap rendering modes
#CUBEMAP_SPECULAR   = 1
#CUBEMAP_DIFFUSE    = 2
#CUBEMAP_REFRACTION = 3

; Shadow's blur levels
#SHADOWS_BLUR_NONE  = 0
#SHADOWS_BLUR_3     = 1
#SHADOWS_BLUR_5     = 2
#SHADOWS_BLUR_7     = 3
#SHADOWS_BLUR_11    = 4
#SHADOWS_BLUR_13    = 5

; primitives types
#PRIMITIVE_POINTLIST     = 1
#PRIMITIVE_LINELIST      = 2
#PRIMITIVE_LINESTRIP     = 3
#PRIMITIVE_TRIANGLELIST  = 4
#PRIMITIVE_TRIANGLESTRIP = 5
#PRIMITIVE_TRIANGLEFAN   = 6

; line separator types
#LS_NUL	= 0
#LS_CR		= 1
#LS_LF		= 2
#LS_CRLF	= 3

; physics: joint types
#JOINT_POINT2POINT	= 0
#JOINT_6DOF		= 1
#JOINT_6DOFSPRING	= 2
#JOINT_HINGE		= 3

; physics: debug drawer modes
#PXDD_NO           = 0
#PXDD_WIREFRAME    = 1
#PXDD_AABB         = 2
#PXDD_CONTACTS     = 4
#PXDD_JOINTS       = 8
#PXDD_JOINT_LIMITS = 16
#PXDD_NO_AXIS      = 32

; physics: ray casting modes
#PXRC_SINGLE   = 0
#PXRC_MULTIPLE = 1

; 3dlines commands
Macro xCreateLine3D(fromX, fromY, fromZ, toX, toY, toZ, red = 255, green = 255, blue = 255, alpha = 255, useZBuffer = #True)
	 xCreateLine3D_(fromX, fromY, fromZ, toX, toY, toZ, red, green, blue, alpha, useZBuffer)
EndMacro

Macro xLine3DOrigin(line3d, x, y, z, isGlobal = #False)
	xLine3DOrigin_(line3d, x, y, z, isGlobal)
EndMacro

Macro xLine3DAddNode(line3d, x, y, z, isGlobal = #False)
	xLine3DAddNode_(line3d, x, y, z, isGlobal)
EndMacro

Macro xLine3DOriginX(line3d, isGlobal = #False)
	 xLine3DOriginX_(line3d, isGlobal)
EndMacro

Macro xLine3DOriginY(line3d, isGlobal = #False)
	 xLine3DOriginY_(line3d, isGlobal)
EndMacro

Macro xLine3DOriginZ(line3d, isGlobal = #False)
	 xLine3DOriginZ_(line3d, isGlobal)
EndMacro

Macro xLine3DNodePosition(line3d, index, x, y, z, isGlobal = #False)
	xLine3DNodePosition_(line3d, index, x, y, z, isGlobal)
EndMacro

Macro xLine3DNodeX(line3d, index, isGlobal = #False)
	 xLine3DNodeX_(line3d, index, isGlobal)
EndMacro

Macro xLine3DNodeY(line3d, index, isGlobal = #False)
	 xLine3DNodeY_(line3d, index, isGlobal)
EndMacro

Macro xLine3DNodeZ(line3d, index, isGlobal = #False)
	 xLine3DNodeZ_(line3d, index, isGlobal)
EndMacro


; brushes commands
Macro xLoadBrush(path, flags = 9, xScale = 1.0, yScale = 1.0)
	 xLoadBrush_(path, flags, xScale, yScale)
EndMacro

Macro xCreateBrush(red = 255.0, green = 255.0, blue = 255.0)
	 xCreateBrush_(red, green, blue)
EndMacro

Macro xGetBrushTexture(brush, index = 0)
	 xGetBrushTexture_(brush, index)
EndMacro

Macro xBrushTexture(brush, texture, frame = 0, index = 0)
	xBrushTexture_(brush, texture, frame, index)
EndMacro


; cameras commands
Macro xCameraClsColor(camera, red, green, blue, alpha = 255)
	xCameraClsColor_(camera, red, green, blue, alpha)
EndMacro

Macro xCreateCamera(parent = 0)
	 xCreateCamera_(parent)
EndMacro


; collisions commands
Macro xEntityRadius(entity, xRadius, yRadius = 0.0)
	xEntityRadius_(entity, xRadius, yRadius)
EndMacro

Macro xEntityType(entity, typeID, recurse = #False)
	xEntityType_(entity, typeID, recurse)
EndMacro


; constants commands

; effects commands
Macro xSetEntityEffect(entity, effect, index = -1)
	xSetEntityEffect_(entity, effect, index)
EndMacro

Macro xSetSurfaceEffect(surface, effect, index = -1)
	xSetSurfaceEffect_(surface, effect, index)
EndMacro

Macro xSetBonesArrayName(entity, arrayName, layer = -1)
	xSetBonesArrayName_(entity, arrayName, layer)
EndMacro

Macro xSurfaceBonesArrayName(surface, arrayName, layer = -1)
	xSurfaceBonesArrayName_(surface, arrayName, layer)
EndMacro

Macro xSetEffectInt(entity, name, value, layer = -1)
	xSetEffectInt_(entity, name, value, layer)
EndMacro

Macro xSurfaceEffectInt(surface, name, value, layer = -1)
	xSurfaceEffectInt_(surface, name, value, layer)
EndMacro

Macro xSetEffectFloat(entity, name, value, layer = -1)
	xSetEffectFloat_(entity, name, value, layer)
EndMacro

Macro xSurfaceEffectFloat(surface, name, value, layer = -1)
	xSurfaceEffectFloat_(surface, name, value, layer)
EndMacro

Macro xSetEffectBool(entity, name, value, layer = -1)
	xSetEffectBool_(entity, name, value, layer)
EndMacro

Macro xSurfaceEffectBool(surface, name, value, layer = -1)
	xSurfaceEffectBool_(surface, name, value, layer)
EndMacro

Macro xSetEffectVector(entity, name, x, y, z, w = 0.0, layer = -1)
	xSetEffectVector_(entity, name, x, y, z, w, layer)
EndMacro

Macro xSurfaceEffectVector(surface, name, x, y, z, w = 0.0, layer = -1)
	xSurfaceEffectVector_(surface, name, x, y, z, w, layer)
EndMacro

Macro xSetEffectVectorArray(entity, name, value, count, layer = -1)
	xSetEffectVectorArray_(entity, name, value, count, layer)
EndMacro

Macro xSurfaceEffectVectorArray(surface, name, value, count, layer = -1)
	xSurfaceEffectVectorArray_(surface, name, value, count, layer)
EndMacro

Macro xSurfaceEffectMatrixArray(surface, name, value, count, layer = -1)
	xSurfaceEffectMatrixArray_(surface, name, value, count, layer)
EndMacro

Macro xSurfaceEffectFloatArray(surface, name, value, count, layer = -1)
	xSurfaceEffectFloatArray_(surface, name, value, count, layer)
EndMacro

Macro xSurfaceEffectIntArray(surface, name, value, count, layer = -1)
	xSurfaceEffectIntArray_(surface, name, value, count, layer)
EndMacro

Macro xSetEffectMatrixArray(entity, name, value, count, layer = -1)
	xSetEffectMatrixArray_(entity, name, value, count, layer)
EndMacro

Macro xSetEffectFloatArray(entity, name, value, count, layer = -1)
	xSetEffectFloatArray_(entity, name, value, count, layer)
EndMacro

Macro xSetEffectIntArray(entity, name, value, count, layer = -1)
	xSetEffectIntArray_(entity, name, value, count, layer)
EndMacro

Macro xSetEffectMatrixWithElements(entity, name, m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44, layer = -1)
	xSetEffectMatrixWithElements_(entity, name, m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44, layer)
EndMacro

Macro xSetEffectMatrix(entity, name, matrix, layer = -1)
	xSetEffectMatrix_(entity, name, matrix, layer)
EndMacro

Macro xSurfaceEffectMatrix(surface, name, matrix, layer = -1)
	xSurfaceEffectMatrix_(surface, name, matrix, layer)
EndMacro

Macro xSurfaceEffectMatrixWithElements(surface, name, m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44, layer = -1)
	xSurfaceEffectMatrixWithElements_(surface, name, m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44, layer)
EndMacro

Macro xSetEffectEntityTexture(entity, name, index = 0, layer = -1)
	xSetEffectEntityTexture_(entity, name, index, layer)
EndMacro

Macro xSetEffectTexture(entity, name, texture, frame = 0, layer = -1, isRecursive = 1)
	xSetEffectTexture_(entity, name, texture, frame, layer, isRecursive)
EndMacro

Macro xSurfaceEffectTexture(surface, name, texture, frame = 0, layer = -1)
	xSurfaceEffectTexture_(surface, name, texture, frame, layer)
EndMacro

Macro xSurfaceEffectMatrixSemantic(surface, name, value, layer = -1)
	xSurfaceEffectMatrixSemantic_(surface, name, value, layer)
EndMacro

Macro xSetEffectMatrixSemantic(entity, name, value, layer = -1)
	xSetEffectMatrixSemantic_(entity, name, value, layer)
EndMacro

Macro xDeleteSurfaceConstant(surface, name, layer = -1)
	xDeleteSurfaceConstant_(surface, name, layer)
EndMacro

Macro xDeleteEffectConstant(entity, name, layer = -1)
	xDeleteEffectConstant_(entity, name, layer)
EndMacro

Macro xClearSurfaceConstants(surface, layer = -1)
	xClearSurfaceConstants_(surface, layer)
EndMacro

Macro xClearEffectConstants(entity, layer = -1)
	xClearEffectConstants_(entity, layer)
EndMacro

Macro xSetEffectTechnique(entity, name, layer = -1)
	xSetEffectTechnique_(entity, name, layer)
EndMacro

Macro xSurfaceTechnique(surface, name, layer = -1)
	xSurfaceTechnique_(surface, name, layer)
EndMacro

Macro xSetFXVector(effect, name, x, y, z, w = 0.0)
	xSetFXVector_(effect, name, x, y, z, w)
EndMacro

Macro xSetFXTexture(effect, name, texture, frame = 0)
	xSetFXTexture_(effect, name, texture, frame)
EndMacro


; emitters commands
Macro xCreateEmitter(psystem, parent = 0)
	 xCreateEmitter_(psystem, parent)
EndMacro


; entity_animation commands
Macro xExtractAnimSeq(entity, firstFrame, lastFrame, sequence = 0)
	 xExtractAnimSeq_(entity, firstFrame, lastFrame, sequence)
EndMacro

Macro xSetAnimSpeed(entity, speed, rootBone = "")
	xSetAnimSpeed_(entity, speed, rootBone)
EndMacro

Macro xAnimSpeed(entity, rootBone = "")
	 xAnimSpeed_(entity, rootBone)
EndMacro

Macro xAnimating(entity, rootBone = "")
	 xAnimating_(entity, rootBone)
EndMacro

Macro xAnimTime(entity, rootBone = "")
	 xAnimTime_(entity, rootBone)
EndMacro

Macro xAnimate(entity, mode = 1, speed = 1.0, sequence = 0, translate = 0.0, rootBone = "")
	xAnimate_(entity, mode, speed, sequence, translate, rootBone)
EndMacro

Macro xAnimSeq(entity, rootBone = "")
	 xAnimSeq_(entity, rootBone)
EndMacro

Macro xAnimLength(entity, rootBone = "")
	 xAnimLength_(entity, rootBone)
EndMacro

Macro xSetAnimTime(entity, time, sequence, rootBone = "")
	xSetAnimTime_(entity, time, sequence, rootBone)
EndMacro

Macro xSetAnimFrame(entity, frame, sequence, rootBone = "")
	xSetAnimFrame_(entity, frame, sequence, rootBone)
EndMacro


; entity_control commands
Macro xCopyEntity(entity, parent = 0, cloneBuffers = 0)
	 xCopyEntity_(entity, parent, cloneBuffers)
EndMacro

Macro xEntityPickMode(entity, mode, obscurer = #True, recursive = #True)
	xEntityPickMode_(entity, mode, obscurer, recursive)
EndMacro

Macro xEntityTexture(entity, texture, frame = 0, index = 0, isRecursive = 1)
	xEntityTexture_(entity, texture, frame, index, isRecursive)
EndMacro

Macro xEntityParent(entity, parent = 0, isGlobal = #True)
	xEntityParent_(entity, parent, isGlobal)
EndMacro

Macro xCreateInstance(entity, parent = 0)
	 xCreateInstance_(entity, parent)
EndMacro

Macro xFreezeInstances(entity, enable = #True)
	xFreezeInstances_(entity, enable)
EndMacro


; entity_movement commands
Macro xScaleEntity(entity, x, y, z, isGlobal = #False)
	xScaleEntity_(entity, x, y, z, isGlobal)
EndMacro

Macro xPositionEntity(entity, x, y, z, isGlobal = #False)
	xPositionEntity_(entity, x, y, z, isGlobal)
EndMacro

Macro xMoveEntity(entity, x, y, z, isGlobal = #False)
	xMoveEntity_(entity, x, y, z, isGlobal)
EndMacro

Macro xTranslateEntity(entity, x, y, z, isGlobal = #False)
	xTranslateEntity_(entity, x, y, z, isGlobal)
EndMacro

Macro xRotateEntity(entity, x, y, z, isGlobal = #False)
	xRotateEntity_(entity, x, y, z, isGlobal)
EndMacro

Macro xTurnEntity(entity, x, y, z, isGlobal = #False)
	xTurnEntity_(entity, x, y, z, isGlobal)
EndMacro

Macro xPointEntity(entity1, entity2, roll = 0.0)
	xPointEntity_(entity1, entity2, roll)
EndMacro

Macro xAlignToVector(entity, x, y, z, axis, factor = 1.0)
	xAlignToVector_(entity, x, y, z, axis, factor)
EndMacro


; entity_state commands
Macro xEntityX(entity, isGlobal = #False)
	 xEntityX_(entity, isGlobal)
EndMacro

Macro xEntityY(entity, isGlobal = #False)
	 xEntityY_(entity, isGlobal)
EndMacro

Macro xEntityZ(entity, isGlobal = #False)
	 xEntityZ_(entity, isGlobal)
EndMacro

Macro xEntityRoll(entity, isGlobal = #False)
	 xEntityRoll_(entity, isGlobal)
EndMacro

Macro xEntityYaw(entity, isGlobal = #False)
	 xEntityYaw_(entity, isGlobal)
EndMacro

Macro xEntityPitch(entity, isGlobal = #False)
	 xEntityPitch_(entity, isGlobal)
EndMacro


; filesystems commands
Macro xMountPackFile(path, mountpoint = "", password = "")
	 xMountPackFile_(path, mountpoint, password)
EndMacro

Macro xReadLine(file, ls_flag = 0)
	 xReadLine_(file, ls_flag)
EndMacro

Macro xWriteLine(file, value, ls_flag = 0)
	xWriteLine_(file, value, ls_flag)
EndMacro


; fonts commands
Macro xLoadFont(name, height, bold = #False, italic = #False, underline = #False, fontface = "")
	 xLoadFont_(name, height, bold, italic, underline, fontface)
EndMacro

Macro xText(x, y, textString, centerx = #False, centery = #False)
	xText_(x, y, textString, centerx, centery)
EndMacro


; graphics commands
Macro xRect(x, y, width, height, solid = #False)
	xRect_(x, y, width, height, solid)
EndMacro

Macro xOval(x, y, width, height, solid = #False)
	xOval_(x, y, width, height, solid)
EndMacro

Macro xLockBuffer(buffer = 0)
	xLockBuffer_(buffer)
EndMacro

Macro xUnlockBuffer(buffer = 0)
	xUnlockBuffer_(buffer)
EndMacro

Macro xWritePixelFast(x, y, argb, buffer = -1)
	xWritePixelFast_(x, y, argb, buffer)
EndMacro

Macro xReadPixelFast(x, y, buffer = -1)
	 xReadPixelFast_(x, y, buffer)
EndMacro

Macro xGetPixels(buffer = -1)
	 xGetPixels_(buffer)
EndMacro

Macro xBufferWidth(buffer = 0)
	 xBufferWidth_(buffer)
EndMacro

Macro xBufferHeight(buffer = 0)
	 xBufferHeight_(buffer)
EndMacro

Macro xSetBuffer(buffer = 0)
	xSetBuffer_(buffer)
EndMacro

Macro xTextureBuffer(texture, frame = 0)
	 xTextureBuffer_(texture, frame)
EndMacro

Macro xWritePixel(x, y, argb, buffer = 0)
	xWritePixel_(x, y, argb, buffer)
EndMacro

Macro xReadPixel(x, y, buffer = 0)
	 xReadPixel_(x, y, buffer)
EndMacro

Macro xGraphicsWidth(isVirtual = #True)
	 xGraphicsWidth_(isVirtual)
EndMacro

Macro xGraphicsHeight(isVirtual = #True)
	 xGraphicsHeight_(isVirtual)
EndMacro

Macro xClsColor(red, green, blue, alpha = 255)
	xClsColor_(red, green, blue, alpha)
EndMacro

Macro xClearWorld(entities = #True, brushes = #True, textures = #True)
	xClearWorld_(entities, brushes, textures)
EndMacro

Macro xColor(red, green, blue, alpha = 255)
	xColor_(red, green, blue, alpha)
EndMacro

Macro xUpdateWorld(speed = 1.0)
	xUpdateWorld_(speed)
EndMacro

Macro xRenderEntity(camera, entity, tween = 1.0)
	xRenderEntity_(camera, entity, tween)
EndMacro

Macro xRenderWorld(tween = 1.0, renderShadows = #False)
	xRenderWorld_(tween, renderShadows)
EndMacro

Macro xAmbientLight(red, green, blue, world = 0)
	xAmbientLight_(red, green, blue, world)
EndMacro

Macro xGraphics3D(width = 1024, height = 768, depth = 0, mode = 0, vsync = 1)
	
	xGraphics3D_(width, height, depth, mode, vsync)
EndMacro

Macro xDrawMovementGizmo(x, y, z, selectMask = 0)
	xDrawMovementGizmo_(x, y, z, selectMask)
EndMacro

Macro xDrawScaleGizmo(x, y, z, selectMask = 0, sx = 1.0, sy = 1.0, sz = 1.0)
	xDrawScaleGizmo_(x, y, z, selectMask, sx, sy, sz)
EndMacro

Macro xDrawRotationGizmo(x, y, z, selectMask = 0, pitch = 0.0, yaw = 0.0, roll = 0.0)
	xDrawRotationGizmo_(x, y, z, selectMask, pitch, yaw, roll)
EndMacro

Macro xDeltaTime(fromInit = #False)
	 xDeltaTime_(fromInit)
EndMacro

Macro xDeltaValue(value, time = 0)
	 xDeltaValue_(value, time)
EndMacro


; images commands
Macro xImageBuffer(image, frame = 0)
	 xImageBuffer_(image, frame)
EndMacro

Macro xCreateImage(width, height, frame = 1)
	 xCreateImage_(width, height, frame)
EndMacro

Macro xGrabImage(image, x, y, frame = 0)
	xGrabImage_(image, x, y, frame)
EndMacro

Macro xSaveImage(image, path, frame = 0)
	xSaveImage_(image, path, frame)
EndMacro

Macro xDrawImage(image, x, y, frame = 0)
	xDrawImage_(image, x, y, frame)
EndMacro

Macro xDrawImageRect(image, x, y, rectx, recty, rectWidth, rectHeight, frame = 0)
	xDrawImageRect_(image, x, y, rectx, recty, rectWidth, rectHeight, frame)
EndMacro

Macro xTileImage(image, x, y, frame = 0)
	xTileImage_(image, x, y, frame)
EndMacro

Macro xDrawBlock(image, x, y, frame = 0)
	xDrawBlock_(image, x, y, frame)
EndMacro

Macro xDrawBlockRect(image, x, y, rectx, recty, rectWidth, rectHeight, frame = 0)
	xDrawBlockRect_(image, x, y, rectx, recty, rectWidth, rectHeight, frame)
EndMacro


; inputs commands

; joysticks commands
Macro xJoyType(portID = 0)
	 xJoyType_(portID)
EndMacro

Macro xJoyDown(key, portID = 0)
	 xJoyDown_(key, portID)
EndMacro

Macro xJoyHit(key, portID = 0)
	 xJoyHit_(key, portID)
EndMacro

Macro xGetJoy(portID = 0)
	 xGetJoy_(portID)
EndMacro

Macro xWaitJoy(portID = 0)
	 xWaitJoy_(portID)
EndMacro

Macro xJoyX(portID = 0)
	 xJoyX_(portID)
EndMacro

Macro xJoyY(portID = 0)
	 xJoyY_(portID)
EndMacro

Macro xJoyZ(portID = 0)
	 xJoyZ_(portID)
EndMacro

Macro xJoyU(portID = 0)
	 xJoyU_(portID)
EndMacro

Macro xJoyV(portID = 0)
	 xJoyV_(portID)
EndMacro

Macro xJoyPitch(portID = 0)
	 xJoyPitch_(portID)
EndMacro

Macro xJoyYaw(portID = 0)
	 xJoyYaw_(portID)
EndMacro

Macro xJoyRoll(portID = 0)
	 xJoyRoll_(portID)
EndMacro

Macro xJoyHat(portID = 0)
	 xJoyHat_(portID)
EndMacro

Macro xJoyXDir(portID = 0)
	 xJoyXDir_(portID)
EndMacro

Macro xJoyYDir(portID = 0)
	 xJoyYDir_(portID)
EndMacro

Macro xJoyZDir(portID = 0)
	 xJoyZDir_(portID)
EndMacro

Macro xJoyUDir(portID = 0)
	 xJoyUDir_(portID)
EndMacro

Macro xJoyVDir(portID = 0)
	 xJoyVDir_(portID)
EndMacro


; lights commands
Macro xCreateLight(typeID = 1)
	 xCreateLight_(typeID)
EndMacro


; logging commands
Macro xCreateLog(target = 1, level = 0, filename = "xors_log.html", cssfilename = "")
	 xCreateLog_(target, level, filename, cssfilename)
EndMacro

Macro xSetLogLevel(level = 2)
	xSetLogLevel_(level)
EndMacro

Macro xSetLogTarget(target = 1)
	xSetLogTarget_(target)
EndMacro

Macro xLogInfo(message, func = "", file = "", line = -1)
	xLogInfo_(message, func, file, line)
EndMacro

Macro xLogMessage(message, func = "", file = "", line = -1)
	xLogMessage_(message, func, file, line)
EndMacro

Macro xLogWarning(message, func = "", file = "", line = -1)
	xLogWarning_(message, func, file, line)
EndMacro

Macro xLogError(message, func = "", file = "", line = -1)
	xLogError_(message, func, file, line)
EndMacro

Macro xLogFatal(message, func = "", file = "", line = -1)
	xLogFatal_(message, func, file, line)
EndMacro


; meshes commands
Macro xCreateMesh(parent = 0)
	 xCreateMesh_(parent)
EndMacro

Macro xLoadMesh(path, parent = 0)
	 xLoadMesh_(path, parent)
EndMacro

Macro xLoadMeshWithChild(path, parent = 0)
	 xLoadMeshWithChild_(path, parent)
EndMacro

Macro xLoadAnimMesh(path, parent = 0)
	 xLoadAnimMesh_(path, parent)
EndMacro

Macro xCreateCube(parent = 0)
	 xCreateCube_(parent)
EndMacro

Macro xCreateSphere(segments = 16, parent = 0)
	 xCreateSphere_(segments, parent)
EndMacro

Macro xCreateCylinder(segments = 16, solid = #True, parent = 0)
	 xCreateCylinder_(segments, solid, parent)
EndMacro

Macro xCreateTorus(segments = 16, R = 1.0, r_tube = 0.025, parent = 0)
	 xCreateTorus_(segments, R, r_tube, parent)
EndMacro

Macro xCreateCone(segments = 16, solid = #True, parent = 0)
	 xCreateCone_(segments, solid, parent)
EndMacro

Macro xCopyMesh(entity, parent = 0)
	 xCopyMesh_(entity, parent)
EndMacro

Macro xFitMesh(entity, x, y, z, width, height, depth, uniform = #False)
	xFitMesh_(entity, x, y, z, width, height, depth, uniform)
EndMacro

Macro xMeshWidth(entity, recursive = #False)
	 xMeshWidth_(entity, recursive)
EndMacro

Macro xMeshHeight(entity, recursive = #False)
	 xMeshHeight_(entity, recursive)
EndMacro

Macro xMeshDepth(entity, recursive = #False)
	 xMeshDepth_(entity, recursive)
EndMacro

Macro xCreatePivot(parent = 0)
	 xCreatePivot_(parent)
EndMacro

Macro xCreatePoly(sides = 0, parent = 0)
	 xCreatePoly_(sides, parent)
EndMacro

Macro xLightMesh(entity, red, green, blue, range = 0.0, lightX = 0.0, lightY = 0.0, lightZ = 0.0)
	xLightMesh_(entity, red, green, blue, range, lightX, lightY, lightZ)
EndMacro


; particles commands

; physics commands
Macro xEntityAddBoxShape(entity, mass, width = 0.0, height = 0.0, depth = 0.0)
	xEntityAddBoxShape_(entity, mass, width, height, depth)
EndMacro

Macro xEntityAddSphereShape(entity, mass, radius = 0.0)
	xEntityAddSphereShape_(entity, mass, radius)
EndMacro

Macro xEntityAddCapsuleShape(entity, mass, radius = 0.0, height = 0.0)
	xEntityAddCapsuleShape_(entity, mass, radius, height)
EndMacro

Macro xEntityAddConeShape(entity, mass, radius = 0.0, height = 0.0)
	xEntityAddConeShape_(entity, mass, radius, height)
EndMacro

Macro xEntityAddCylinderShape(entity, mass, width = 0.0, height = 0.0, depth = 0.0)
	xEntityAddCylinderShape_(entity, mass, width, height, depth)
EndMacro

Macro xCreateHingeJoint(firstBody, secondBody, pivotX, pivotY, pivotZ, axisX, axisY, axisZ, isGlobal = #False)
	 xCreateHingeJoint_(firstBody, secondBody, pivotX, pivotY, pivotZ, axisX, axisY, axisZ, isGlobal)
EndMacro

Macro xCreateBallJoint(firstBody, secondBody, pivotX, pivotY, pivotZ, isGlobal = #False)
	 xCreateBallJoint_(firstBody, secondBody, pivotX, pivotY, pivotZ, isGlobal)
EndMacro

Macro xCreateD6Joint(firstBody, secondBody, pivot1X, pivot1Y, pivot1Z, pivot2X, pivot2Y, pivot2Z, isGlobal1 = #False, isGlobal2 = #False)
	 xCreateD6Joint_(firstBody, secondBody, pivot1X, pivot1Y, pivot1Z, pivot2X, pivot2Y, pivot2Z, isGlobal1, isGlobal2)
EndMacro

Macro xCreateD6SpringJoint(firstBody, secondBody, pivot1X, pivot1Y, pivot1Z, pivot2X, pivot2Y, pivot2Z, isGlobal1 = #False, isGlobal2 = #False)
	 xCreateD6SpringJoint_(firstBody, secondBody, pivot1X, pivot1Y, pivot1Z, pivot2X, pivot2Y, pivot2Z, isGlobal1, isGlobal2)
EndMacro

Macro xJointD6GetAngle(joint, axis = 0)
	 xJointD6GetAngle_(joint, axis)
EndMacro

Macro xJointBallSetPivot(joint, x, y, z, isGlobal = #False)
	xJointBallSetPivot_(joint, x, y, z, isGlobal)
EndMacro

Macro xJointBallGetPivotX(joint, isGlobal = #False)
	 xJointBallGetPivotX_(joint, isGlobal)
EndMacro

Macro xJointBallGetPivotY(joint, isGlobal = #False)
	 xJointBallGetPivotY_(joint, isGlobal)
EndMacro

Macro xJointBallGetPivotZ(joint, isGlobal = #False)
	 xJointBallGetPivotZ_(joint, isGlobal)
EndMacro

Macro xJointD6SpringSetParam(joint, index, enabled, damping = 1.0, stiffness = 1.0)
	xJointD6SpringSetParam_(joint, index, enabled, damping, stiffness)
EndMacro

Macro xJointHingeSetLimits(joint, lowerLimit, upperLimit, softness = 0.9, biasFactor = 0.3, relaxationFactor = 1.0)
	xJointHingeSetLimits_(joint, lowerLimit, upperLimit, softness, biasFactor, relaxationFactor)
EndMacro

Macro xJointEnableMotor(joint, enabled, targetVelocity, maxForce, index = 0)
	xJointEnableMotor_(joint, enabled, targetVelocity, maxForce, index)
EndMacro

Macro xEntityApplyCentralForce(entity, x, y, z, isGlobal = #True)
	xEntityApplyCentralForce_(entity, x, y, z, isGlobal)
EndMacro

Macro xEntityApplyCentralImpulse(entity, x, y, z, isGlobal = #True)
	xEntityApplyCentralImpulse_(entity, x, y, z, isGlobal)
EndMacro

Macro xEntityApplyTorque(entity, x, y, z, isGlobal = #True)
	xEntityApplyTorque_(entity, x, y, z, isGlobal)
EndMacro

Macro xEntityApplyTorqueImpulse(entity, x, y, z, isGlobal = #True)
	xEntityApplyTorqueImpulse_(entity, x, y, z, isGlobal)
EndMacro

Macro xEntityApplyForce(entity, x, y, z, pointx, pointy, pointz, isGlobal = #True, globalPoint = #True)
	xEntityApplyForce_(entity, x, y, z, pointx, pointy, pointz, isGlobal, globalPoint)
EndMacro

Macro xEntityApplyImpulse(entity, x, y, z, pointx, pointy, pointz, isGlobal = #True, globalPoint = #True)
	xEntityApplyImpulse_(entity, x, y, z, pointx, pointy, pointz, isGlobal, globalPoint)
EndMacro

Macro xWorldSetGravity(x, y, z, world = 0)
	xWorldSetGravity_(x, y, z, world)
EndMacro

Macro xWorldGetGravityX(world = 0)
	 xWorldGetGravityX_(world)
EndMacro

Macro xWorldGetGravityY(world = 0)
	 xWorldGetGravityY_(world)
EndMacro

Macro xWorldGetGravityZ(world = 0)
	 xWorldGetGravityZ_(world)
EndMacro

Macro xEntitySetLinearVelocity(entity, x, y, z, isGlobal = #True)
	xEntitySetLinearVelocity_(entity, x, y, z, isGlobal)
EndMacro

Macro xEntityGetLinearVelocityX(entity, isGlobal = #True)
	 xEntityGetLinearVelocityX_(entity, isGlobal)
EndMacro

Macro xEntityGetLinearVelocityY(entity, isGlobal = #True)
	 xEntityGetLinearVelocityY_(entity, isGlobal)
EndMacro

Macro xEntityGetLinearVelocityZ(entity, isGlobal = #True)
	 xEntityGetLinearVelocityZ_(entity, isGlobal)
EndMacro

Macro xEntitySetAngularVelocity(entity, x, y, z, isGlobal = #True)
	xEntitySetAngularVelocity_(entity, x, y, z, isGlobal)
EndMacro

Macro xEntityGetAngularVelocityX(entity, isGlobal = #True)
	 xEntityGetAngularVelocityX_(entity, isGlobal)
EndMacro

Macro xEntityGetAngularVelocityY(entity, isGlobal = #True)
	 xEntityGetAngularVelocityY_(entity, isGlobal)
EndMacro

Macro xEntityGetAngularVelocityZ(entity, isGlobal = #True)
	 xEntityGetAngularVelocityZ_(entity, isGlobal)
EndMacro

Macro xEntityDisableSleeping(entity, state = 1)
	xEntityDisableSleeping_(entity, state)
EndMacro

Macro xPhysicsRayCast(fromX, fromY, fromZ, toX, toY, toZ, rcType = 0, rayGroup = 0)
	xPhysicsRayCast_(fromX, fromY, fromZ, toX, toY, toZ, rcType, rayGroup)
EndMacro

Macro xPhysicsGetHitEntity(index = 0)
	 xPhysicsGetHitEntity_(index)
EndMacro

Macro xPhysicsGetHitPointX(index = 0)
	 xPhysicsGetHitPointX_(index)
EndMacro

Macro xPhysicsGetHitPointY(index = 0)
	 xPhysicsGetHitPointY_(index)
EndMacro

Macro xPhysicsGetHitPointZ(index = 0)
	 xPhysicsGetHitPointZ_(index)
EndMacro

Macro xPhysicsGetHitNormalX(index = 0)
	 xPhysicsGetHitNormalX_(index)
EndMacro

Macro xPhysicsGetHitNormalY(index = 0)
	 xPhysicsGetHitNormalY_(index)
EndMacro

Macro xPhysicsGetHitNormalZ(index = 0)
	 xPhysicsGetHitNormalZ_(index)
EndMacro

Macro xPhysicsGetHitDistance(index = 0)
	 xPhysicsGetHitDistance_(index)
EndMacro

Macro xWorldSetFrequency(frequency, world = 0)
	xWorldSetFrequency_(frequency, world)
EndMacro

Macro xEntityWheelSetConnectionPoint(chassisEntity, index, x, y, z, isGlobal = #False)
	xEntityWheelSetConnectionPoint_(chassisEntity, index, x, y, z, isGlobal)
EndMacro


; posteffects commands
Macro xSetPostEffect(index, postEffect, technique = "MainTechnique")
	xSetPostEffect_(index, postEffect, technique)
EndMacro

Macro xSetPostEffectVector(postEffect, name, x, y, z, w = 1.0)
	xSetPostEffectVector_(postEffect, name, x, y, z, w)
EndMacro

Macro xSetPostEffectTexture(postEffect, name, texture, frame = 0)
	xSetPostEffectTexture_(postEffect, name, texture, frame)
EndMacro


; psystems commands
Macro xCreatePSystem(pointSprites = #False)
	 xCreatePSystem_(pointSprites)
EndMacro


; raypicks commands
Macro xLinePick(x, y, z, dx, dy, dz, distance = 0.0)
	 xLinePick_(x, y, z, dx, dy, dz, distance)
EndMacro

Macro xEntityPick(entity, range = 0.0)
	 xEntityPick_(entity, range)
EndMacro


; shadows commands
Macro xSetShadowParams(splitPlanes = 4, splitLambda = 0.95, useOrtho = #True, lightDist = 300.0)
	xSetShadowParams_(splitPlanes, splitLambda, useOrtho, lightDist)
EndMacro


; sounds commands
Macro xCreateListener(parent = 0, roFactor = 1.0, doplerFactor = 1.0, distFactor = 1.0)
	 xCreateListener_(parent, roFactor, doplerFactor, distFactor)
EndMacro


; sprites commands
Macro xCreateSprite(parent = 0)
	 xCreateSprite_(parent)
EndMacro

Macro xLoadSprite(path, flags = 9, parent = 0)
	 xLoadSprite_(path, flags, parent)
EndMacro


; surfaces commands
Macro xCreateSurface(entity, brush = 0, dynamic = #False)
	 xCreateSurface_(entity, brush, dynamic)
EndMacro

Macro xAddVertex(surface, x, y, z, u = 0.0, v = 0.0, w = 0.0)
	 xAddVertex_(surface, x, y, z, u, v, w)
EndMacro

Macro xVertexColor(surface, vertex, red, green, blue, alpha = 1.0)
	xVertexColor_(surface, vertex, red, green, blue, alpha)
EndMacro

Macro xVertexTexCoords(surface, vertex, u, v, w = 1.0, textureSet = 0)
	xVertexTexCoords_(surface, vertex, u, v, w, textureSet)
EndMacro

Macro xVertexU(surface, vertex, textureSet = 0)
	 xVertexU_(surface, vertex, textureSet)
EndMacro

Macro xVertexV(surface, vertex, textureSet = 0)
	 xVertexV_(surface, vertex, textureSet)
EndMacro

Macro xVertexW(surface, vertex, textureSet = 0)
	 xVertexW_(surface, vertex, textureSet)
EndMacro

Macro xClearSurface(surface, vertices = #True, triangles = #True)
	xClearSurface_(surface, vertices, triangles)
EndMacro

Macro xGetSurfaceTexture(surface, index = 0)
	 xGetSurfaceTexture_(surface, index)
EndMacro


; sysinfos commands

; terrains commands
Macro xLoadTerrain(path, parent = 0)
	 xLoadTerrain_(path, parent)
EndMacro

Macro xCreateTerrain(size, parent = 0)
	 xCreateTerrain_(size, parent)
EndMacro

Macro xTerrainShading(terrain, state = #False)
	xTerrainShading_(terrain, state)
EndMacro

Macro xModifyTerrain(terrain, x, y, height, realtime = #False)
	xModifyTerrain_(terrain, x, y, height, realtime)
EndMacro

Macro xTerrainViewZone(terrain, viewZone, texturingZone = -1)
	xTerrainViewZone_(terrain, viewZone, texturingZone)
EndMacro


; textures commands
Macro xCreateTexture(width, height, flags = 9, frames = 1)
	 xCreateTexture_(width, height, flags, frames)
EndMacro

Macro xLoadTexture(path, flags = 9)
	 xLoadTexture_(path, flags)
EndMacro

Macro xCreateTextureFromData(pixelsData, width, height, flags = 9, frames = 1)
	 xCreateTextureFromData_(pixelsData, width, height, flags, frames)
EndMacro

Macro xGetTextureData(texture, frame = 0)
	 xGetTextureData_(texture, frame)
EndMacro

Macro xGetTextureDataPitch(texture, frame = 0)
	 xGetTextureDataPitch_(texture, frame)
EndMacro

Macro xGetTextureSurface(texture, frame = 0)
	 xGetTextureSurface_(texture, frame)
EndMacro


; transforms commands

; videos commands
Macro xDrawMovie(video, x = 0, y = 0, width = -1, height = -1)
	xDrawMovie_(video, x, y, width, height)
EndMacro

Macro xMovieSeek(video, time, relative = #False)
	xMovieSeek_(video, time, relative)
EndMacro


; worlds commands
; Scancodes for keyboard and mouse
#MOUSE_LEFT         = 1
#MOUSE_RIGHT        = 2
#MOUSE_MIDDLE       = 3
#MOUSE4             = 4
#MOUSE5             = 5
#MOUSE6             = 6
#MOUSE7             = 7
#MOUSE8             = 8

#xMOUSE_LEFT        = 1
#xMOUSE_RIGHT       = 2
#xMOUSE_MIDDLE      = 3
#xMOUSE4            = 4
#xMOUSE5            = 5
#xMOUSE6            = 6
#xMOUSE7            = 7
#xMOUSE8            = 8

#KEY_ESCAPE         = 1
#KEY_1              = 2
#KEY_2              = 3
#KEY_3              = 4
#KEY_4              = 5
#KEY_5              = 6
#KEY_6              = 7
#KEY_7              = 8
#KEY_8              = 9
#KEY_9              = 10
#KEY_0              = 11
#KEY_MINUS          = 12
#KEY_EQUALS         = 13
#KEY_BACK           = 14
#KEY_TAB            = 15
#KEY_Q              = 16
#KEY_W              = 17
#KEY_E              = 18
#KEY_R              = 19
#KEY_T              = 20
#KEY_Y              = 21
#KEY_U              = 22
#KEY_I              = 23
#KEY_O              = 24
#KEY_P              = 25
#KEY_LBRACKET       = 26
#KEY_RBRACKET       = 27
#KEY_         = 28
#KEY_ENTER          = #KEY_
#KEY_LCONTROL       = 29
#KEY_RCONTROL       = 157
#KEY_A              = 30
#KEY_S              = 31
#KEY_D              = 32
#KEY_F              = 33
#KEY_G              = 34
#KEY_H              = 35
#KEY_J              = 36
#KEY_K              = 37
#KEY_L              = 38
#KEY_SEMICOLON      = 39
#KEY_APOSTROPHE     = 40
#KEY_GRAVE          = 41
#KEY_LSHIFT         = 42
#KEY_BACKSLASH      = 43
#KEY_Z              = 44
#KEY_X              = 45
#KEY_C              = 46
#KEY_V              = 47
#KEY_B              = 48
#KEY_N              = 49
#KEY_M              = 50
#KEY_COMMA          = 51
#KEY_PERIOD         = 52
#KEY_SLASH          = 53
#KEY_RSHIFT         = 54
#KEY_MULTIPLY       = 55
#KEY_MENU           = 56
#KEY_SPACE          = 57
#KEY_F1             = 59
#KEY_F2             = 60
#KEY_F3             = 61
#KEY_F4             = 62
#KEY_F5             = 63
#KEY_F6             = 64
#KEY_F7             = 65
#KEY_F8             = 66
#KEY_F9             = 67
#KEY_F10            = 68
#KEY_NUMLOCK        = 69
#KEY_SCROLL         = 70
#KEY_NUMPAD7        = 71
#KEY_NUMPAD8        = 72
#KEY_NUMPAD9        = 73
#KEY_SUBTRACT       = 74
#KEY_NUMPAD4        = 75
#KEY_NUMPAD5        = 76
#KEY_NUMPAD6        = 77
#KEY_ADD            = 78
#KEY_NUMPAD1        = 79
#KEY_NUMPAD2        = 80
#KEY_NUMPAD3        = 81
#KEY_NUMPAD0        = 82
#KEY_DECIMAL        = 83
#KEY_TILD           = 86
#KEY_F11            = 87
#KEY_F12            = 88
#KEY_NUMPADENTER    = 156
#KEY_RMENU          = 221
#KEY_PAUSE          = 197
#KEY_HOME           = 199
#KEY_UP             = 200
#KEY_PRIOR          = 201
#KEY_LEFT           = 203
#KEY_RIGHT          = 205
#KEY_END            = 207
#KEY_DOWN           = 208
#KEY_NEXT           = 209
#KEY_INSERT         = 210
#KEY_DELETE         = 211
#KEY_LWIN           = 219
#KEY_RWIN           = 220
#KEY_BACKSPACE      = #KEY_BACK
#KEY_NUMPADSTAR     = #KEY_MULTIPLY
#KEY_CAPSLOCK       = 58
#KEY_NUMPADMINUS    = #KEY_SUBTRACT
#KEY_NUMPADPLUS     = #KEY_ADD
#KEY_NUMPADPERIOD   = #KEY_DECIMAL
#KEY_DIVIDE         = 181
#KEY_NUMPADSLASH    = #KEY_DIVIDE
#KEY_LALT           = 56
#KEY_RALT           = 184
#KEY_UPARROW        = #KEY_UP
#KEY_PGUP           = #KEY_PRIOR
#KEY_LEFTARROW      = #KEY_LEFT
#KEY_RIGHTARROW     = #KEY_RIGHT
#KEY_DOWNARROW      = #KEY_DOWN
#KEY_PGDN           = #KEY_NEXT

#xKEY_ESCAPE        = 1
#xKEY_1             = 2
#xKEY_2             = 3
#xKEY_3             = 4
#xKEY_4             = 5
#xKEY_5             = 6
#xKEY_6             = 7
#xKEY_7             = 8
#xKEY_8             = 9
#xKEY_9             = 10
#xKEY_0             = 11
#xKEY_MINUS         = 12
#xKEY_EQUALS        = 13
#xKEY_BACK          = 14
#xKEY_TAB           = 15
#xKEY_Q             = 16
#xKEY_W             = 17
#xKEY_E             = 18
#xKEY_R             = 19
#xKEY_T             = 20
#xKEY_Y             = 21
#xKEY_U             = 22
#xKEY_I             = 23
#xKEY_O             = 24
#xKEY_P             = 25
#xKEY_LBRACKET      = 26
#xKEY_RBRACKET      = 27
#xKEY_        = 28
#xKEY_ENTER         = #KEY_
#xKEY_LCONTROL      = 29
#xKEY_RCONTROL      = 157
#xKEY_A             = 30
#xKEY_S             = 31
#xKEY_D             = 32
#xKEY_F             = 33
#xKEY_G             = 34
#xKEY_H             = 35
#xKEY_J             = 36
#xKEY_K             = 37
#xKEY_L             = 38
#xKEY_SEMICOLON     = 39
#xKEY_APOSTROPHE    = 40
#xKEY_GRAVE         = 41
#xKEY_LSHIFT        = 42
#xKEY_BACKSLASH     = 43
#xKEY_Z             = 44
#xKEY_X             = 45
#xKEY_C             = 46
#xKEY_V             = 47
#xKEY_B             = 48
#xKEY_N             = 49
#xKEY_M             = 50
#xKEY_COMMA         = 51
#xKEY_PERIOD        = 52
#xKEY_SLASH         = 53
#xKEY_RSHIFT        = 54
#xKEY_MULTIPLY      = 55
#xKEY_MENU          = 56
#xKEY_SPACE         = 57
#xKEY_F1            = 59
#xKEY_F2            = 60
#xKEY_F3            = 61
#xKEY_F4            = 62
#xKEY_F5            = 63
#xKEY_F6            = 64
#xKEY_F7            = 65
#xKEY_F8            = 66
#xKEY_F9            = 67
#xKEY_F10           = 68
#xKEY_NUMLOCK       = 69
#xKEY_SCROLL        = 70
#xKEY_NUMPAD7       = 71
#xKEY_NUMPAD8       = 72
#xKEY_NUMPAD9       = 73
#xKEY_SUBTRACT      = 74
#xKEY_NUMPAD4       = 75
#xKEY_NUMPAD5       = 76
#xKEY_NUMPAD6       = 77
#xKEY_ADD           = 78
#xKEY_NUMPAD1       = 79
#xKEY_NUMPAD2       = 80
#xKEY_NUMPAD3       = 81
#xKEY_NUMPAD0       = 82
#xKEY_DECIMAL       = 83
#xKEY_TILD          = 86
#xKEY_F11           = 87
#xKEY_F12           = 88
#xKEY_NUMPADENTER   = 156
#xKEY_RMENU         = 221
#xKEY_PAUSE         = 197
#xKEY_HOME          = 199
#xKEY_UP            = 200
#xKEY_PRIOR         = 201
#xKEY_LEFT          = 203
#xKEY_RIGHT         = 205
#xKEY_END           = 207
#xKEY_DOWN          = 208
#xKEY_NEXT          = 209
#xKEY_INSERT        = 210
#xKEY_DELETE        = 211
#xKEY_LWIN          = 219
#xKEY_RWIN          = 220
#xKEY_BACKSPACE     = #KEY_BACK
#xKEY_NUMPADSTAR    = #KEY_MULTIPLY
#xKEY_CAPSLOCK      = 58
#xKEY_NUMPADMINUS   = #KEY_SUBTRACT
#xKEY_NUMPADPLUS    = #KEY_ADD
#xKEY_NUMPADPERIOD  = #KEY_DECIMAL
#xKEY_DIVIDE        = 181
#xKEY_NUMPADSLASH   = #KEY_DIVIDE
#xKEY_LALT          = 56
#xKEY_RALT          = 184
#xKEY_UPARROW       = #KEY_UP
#xKEY_PGUP          = #KEY_PRIOR
#xKEY_LEFTARROW     = #KEY_LEFT
#xKEY_RIGHTARROW    = #KEY_RIGHT
#xKEY_DOWNARROW     = #KEY_DOWN
#xKEY_PGDN          = #KEY_NEXT
; IDE Options = PureBasic 5.30 (Windows - x86)
; EnableUnicode
; EnableXP