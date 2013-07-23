MODULE WMGLDemo7;  (** AUTHOR "fnecati"; PURPOSE "opengl mirroring effect "; *)

IMPORT
	WMRectangles, WMGraphics, Strings, Kernel,
	WM := WMWindowManager,  WMMessages, WMDialogs,
	gl := OpenGL, glc := OpenGLConst, GLU, WMGL := WMGLWindow;

TYPE
	KillerMsg = OBJECT
	END KillerMsg;


	GLWindow* =  OBJECT(WMGL.Window)
	VAR
		timer: Kernel.MilliTimer;
		alive,  animated: BOOLEAN;
		xrot : REAL;
 		quad: GLU.QuadricObj;
		drawMode: LONGINT;
		font: WMGraphics.Font;
		frames: LONGINT;
		fpsstr: ARRAY 30 OF CHAR;

	PROCEDURE &New(w, h: LONGINT);
	BEGIN
		Init(w, h, FALSE); (* use alpha, for 32bpp img *)
		WM.DefaultAddWindow(SELF);

		SetTitle(Strings.NewString("WMGLDemo7- Mirroring"));

		canvas.SetColor(WMGraphics.Green);
		font := canvas.GetFont();
		fpsstr := "FPS: ";

		xrot := 0.0;
		drawMode:= 0;
		initGL;
		Reshape(w, h);
		DrawMode(0);
		UpdateImage;
		animated := FALSE;
		alive := TRUE;
	END New;

	PROCEDURE KeyEvent (ucs: LONGINT; flags: SET; keysym: LONGINT);
	BEGIN
		CASE CHR(ucs) OF
			"a", "A": animated := ~ animated;

			| "d": drawMode := (drawMode+1) MOD 3; DrawMode(drawMode);   UpdateImage;

			| "-" : xrot := xrot - 1.0;   UpdateImage;
			| "+" : xrot := xrot + 1.0;  UpdateImage;

			| "s": SaveImage;
			| "q" : Close; RETURN;
		ELSE

		END;
	END KeyEvent;

	PROCEDURE Handle(VAR m: WMMessages.Message);
	BEGIN
		IF (m.msgType = WMMessages.MsgExt) & (m.ext # NIL) & (m.ext IS KillerMsg) THEN
			Close;
		ELSE Handle^(m)
		END
	END Handle;

	PROCEDURE Close*;
	BEGIN {EXCLUSIVE}
		alive := FALSE;
		Close^;
	END Close;

	PROCEDURE UpdateImage;
	VAR
		textWidth, textHeight: LONGINT;
		rect: WMRectangles.Rectangle;
	BEGIN
		MakeCurrent();
			Display;
			SwapGLBuffer();
		DeActivate();

		canvas.SetColor(WMGraphics.Green);
		font.GetStringSize(fpsstr, textWidth, textHeight);
		canvas.DrawString(4, textHeight, fpsstr);
		Swap();

		Invalidate(WMRectangles.MakeRect(0, 0, GetWidth(), GetHeight()));
	END UpdateImage;

	PROCEDURE SaveImage;
	VAR res: LONGINT;
		fname: ARRAY 128 OF CHAR;
	BEGIN
		fname:="mywmgltest.bmp";
		IF WMDialogs.QueryString(" Save File name: ",fname)=WMDialogs.ResOk THEN
				WMGraphics.StoreImage(img, fname,res);
		END;
	END SaveImage;

	PROCEDURE DrawMode(dm: LONGINT);
	VAR drawMode: LONGINT;
	BEGIN
		drawMode := dm;
		MakeCurrent();
	        IF drawMode = 0 THEN       (* fill mode*)
	            gl.PolygonMode(glc.GL_FRONT_AND_BACK, glc.GL_FILL);
	            gl.Enable(glc.GL_DEPTH_TEST);
	            gl.Enable(glc.GL_CULL_FACE);
	        ELSIF drawMode = 1 THEN  (* wireframe mode *)
	            gl.PolygonMode(glc.GL_FRONT_AND_BACK, glc.GL_LINE);
	            gl.Disable(glc.GL_DEPTH_TEST);
	            gl.Disable(glc.GL_CULL_FACE);
	        ELSE                    (* point mode *)

	            gl.PolygonMode(glc.GL_FRONT_AND_BACK, glc.GL_POINT);
	            gl.Disable(glc.GL_DEPTH_TEST);
	            gl.Disable(glc.GL_CULL_FACE);
		  END;
		 DeActivate();;
	END DrawMode;

	PROCEDURE initGL;
	VAR
		white, black: ARRAY[4] OF gl.Float;
	BEGIN
		MakeCurrent();
		gl.Disable (glc.GL_DITHER);
		gl.Enable (glc.GL_DEPTH_TEST);
		white[0] := 1.0; white[1] := 1.0; white[2] := 1.0; white[3] := 1.0;
		black[0] := 0.0; black[1] := 0.0; black[2] := 0.0; black[3] := 0.0;

		(* Set up light1 *)
	 	gl.Enable (glc.GL_LIGHTING);
	 	gl.Enable (glc.GL_LIGHT1);
		gl.Lightfv (glc.GL_LIGHT1, glc.GL_DIFFUSE, white);
		gl.Lightfv (glc.GL_LIGHT1, glc.GL_SPECULAR, white);

		(* ambient and diffuse will track glColor *)
		gl.Enable (glc.GL_COLOR_MATERIAL);
		gl.ColorMaterial (glc.GL_FRONT, glc.GL_AMBIENT_AND_DIFFUSE);
		gl.Materialfv (glc.GL_FRONT, glc.GL_SPECULAR, white);
		gl.Materialf (glc.GL_FRONT, glc.GL_SHININESS, 20.);
		quad := GLU.NewQuadric ();
		DeActivate();
	END initGL;

	PROCEDURE drawScene (order: gl.Enum);
	VAR
		pos: ARRAY [4] OF gl.Float;
	BEGIN
	 	pos[0] := -2.8; pos[1] := 5.0; pos[2] := 1.8; pos[3] := 1.0;
	 	gl.Lightfv (glc.GL_LIGHT1, glc.GL_POSITION, pos);
		gl.PushMatrix();

		gl.Enable (glc.GL_CULL_FACE);
		gl.CullFace (glc.GL_BACK);
		gl.FrontFace (order);

		(* Draw the walls *)
	 	gl.Color3f (1., 1., 1.);
		gl.Begin(glc.GL_QUADS);
		gl.Normal3f (1., 0., 0.);
			gl.Vertex3f (-3., 3., 4.);
			gl.Vertex3f (-3., -3., 4.);
			gl.Vertex3f (-3., -3., -3.);
			gl.Vertex3f (-3., 3., -3.);
		gl.Normal3f (0., 0., 1.);
			gl.Vertex3f (-3., 3., -3.);
			gl.Vertex3f (-3., -3., -3.);
			gl.Vertex3f (3., -3., -3.);
			gl.Vertex3f (3., 3., -3.);
		  gl.Normal3f (-1., 0., 0.);
			gl.Vertex3f (3., 3., -3.);
			gl.Vertex3f (3., -3., -3.);
			gl.Vertex3f (3., -3., 3.);
			gl.Vertex3f (3., 3., 3.);
		gl.End();
		gl.Disable (glc.GL_CULL_FACE);

		(* Draw the cylinder *)
	 	gl.Rotatef (xrot, 1., 0., 0.);
	 	gl.Translatef (0.0, 0.0, -1.0);

	 	gl.Color3f (0.5, 0.5, 1.0);
	 	gl.PushMatrix ();
	 	gl.Translatef (0.0, 0.0, 2.0);
	 	GLU.Disk (quad, 0.0, 0.25, 18, 1);
	 	gl.PopMatrix ();

	 	GLU.Cylinder (quad, 0.25, 0.25, 2.0, 18, 8);

	 	gl.PushMatrix ();
	 	gl.Scalef (1., 1., -1.);
	 	GLU.Disk (quad, 0.0, 0.25, 18, 1);
	 	gl.PopMatrix ();

		gl.PopMatrix();
	END drawScene;

	PROCEDURE Display();
	BEGIN
		gl.Clear (glc.GL_COLOR_BUFFER_BIT + glc.GL_DEPTH_BUFFER_BIT);
		gl.MatrixMode(glc.GL_MODELVIEW);
		gl.LoadIdentity ();

			GLU.LookAt (0.0, 1.0, 7.0, -1.0, 0.0, 0.0,  0.0, 1.0, 0.0);

			gl.Rotatef (-xrot*0.35, 0.0, 1.0, 0.0);


		(*gl.Rotatef (-xrot*0.35, 0.0, 1.0, 0.0);*)
		(* Draw reflected scene first *)

		gl.PushMatrix ();
		(* Mirrors lies in YZ plane, so scale by -1.0 in X axis *)

		gl.Scalef (-1.0, 1.0, 1.0);
		(* Mirror is 2.0 units from origin, so translate by 4.0 *)
		gl.Translatef (4.0, 0.0, 0.0);


		drawScene(glc.GL_CW);
		gl.PopMatrix ();

		(* draw mirror *)
		gl.Clear (glc.GL_DEPTH_BUFFER_BIT);
		gl.PushAttrib (SHORT(0FFFFFFFFH));
		gl.Disable (glc.GL_LIGHTING);
		(* Create imperfect reflector effect by blending a black
		   mirror over the reflected scene with alpha of 0.05 *)
		gl.Enable (glc.GL_BLEND);
		gl.BlendFunc (glc.GL_SRC_ALPHA, glc.GL_ONE_MINUS_SRC_ALPHA);
		gl.Color4f (0., 0., 0., 0.05);
		gl.Begin (glc.GL_QUADS);
			gl.Vertex3f (-2., 1., 3.);
			gl.Vertex3f (-2., -1., 3.);
			gl.Vertex3f (-2., -1., -2.5);
			gl.Vertex3f (-2., 1., -2.5);
		gl.End ();
		gl.PopAttrib();

		(* Draw the real scene *)
		drawScene(glc.GL_CCW);
	END Display;

	PROCEDURE Reshape(w, h: LONGINT);
	BEGIN
		MakeCurrent();
		gl.Viewport (0, 0, w, h);
		gl.MatrixMode (glc.GL_PROJECTION);
		gl.LoadIdentity ();
		GLU.Perspective (50.0, 1.0, 1.0, 20.0);
		DeActivate();
	END Reshape;

BEGIN  {ACTIVE}
	Kernel.SetTimer(timer, 10);
	WHILE alive DO
		BEGIN {EXCLUSIVE} AWAIT(animated) END;
	 		UpdateImage();
	 		xrot := xrot + 1.0;

			INC(frames);
			IF Kernel.Expired(timer) THEN
				Strings.FloatToStr(frames/5.0, 0, 2, 0, fpsstr);
				Strings.Concat("FPS:", fpsstr, fpsstr);
				Kernel.SetTimer(timer, 5000);
				frames := 0;
			END;

(*		END; *)
	END;
END GLWindow;

PROCEDURE Open*;
VAR
	window: GLWindow;
BEGIN
	NEW(window, 256, 256);
END Open;

BEGIN

END WMGLDemo7.

SystemTools.Free  WMGLDemo7 WMGLWindow ~  OpenGL OpenGLConst ~

WMGLDemo7.Open ~

SystemTools.FreeDownTo OpenGL ~ 