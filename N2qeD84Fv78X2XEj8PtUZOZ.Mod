MODULE N2qeD84Fv78X2XEj8PtUZOQ;(*anonymous module created by saboteur*)
  
IMPORT Base,   FRep, TexVox;

TYPE Ray = Base.Ray;
	Voxel = Base.Voxel;  
	PT =Base.PT;
VAR 
	ball: FRep.sphere;
	cyl: FRep.cyl;
	v,vu: Voxel;
	sc,s1,s2,star: Voxel;
	sgtp: TexVox.TexVox;
	red,blue:Voxel;
	center,q,qq:  PT;
	p:ARRAY 7 OF PT;
	i,j,k:INTEGER;
	
PROCEDURE thisvox*():Base.Voxel;
BEGIN
	RETURN s1
END thisvox;

BEGIN
	v:=Base.VoxelFromName("NXOT"); 	
	NEW(red);
	red.setcolor(1,0.9,2/3,1,1,1);
	NEW(blue);
	blue.setcolor(0.9,2/3,1,1,1,1);
	NEW(sgtp,"sgtpepper.png");
	s1:=Base.VoxelFromName("NM2"); 	
	s2:=Base.VoxelFromName("NM2"); 	
	sc:=Base.VoxelFromName("NM2"); 	
	s1.imposter:=red;
	s1.setcolor(0,0,0,1,1,1);
	Base.setPT(center,1/2,1/2,1/2);
	Base.setPT(q,1/2,1/2,0);
	Base.setPT(qq,1/2,1/2,1);
	NEW(ball,center,23/50);
(*	ball.setvoxel(v); *)
	ball.setcolor(1,1,1,1,0);
	ball.cxf:=TRUE;
	NEW(cyl,q,qq,1/6);
	s1.FRasterSolid(ball,28);
	s1.copyonstroke:=TRUE;


	sc.lockTF:=TRUE;	
	
	sc.copyonstroke:=TRUE;
	
	sc.passable:=FALSE;
	



 END N2qeD84Fv78X2XEj8PtUZOQ. 