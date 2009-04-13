//
//  GRController.m
//  Gravity
//
//  Created by Daniel Rodríguez Troitiño on 13/04/09.
//  Copyright 2009 Daniel Rodríguez Troitiño. All rights reserved.
//

#import "GRController.h"

#define kAccelerometerFrequency 100.0
#define kRenderingFrequency 60.0
#define kFilteringFactor 0.1

#define D2R(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)

static void GRCollisionPairFunc(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normalCoef, void *data) {
  GRController *controller = (GRController *)data;
  
  [controller collisionBetween:a
                           and:b
                      contacts:contacts
                   numContacts:numContacts
                    normalCoef:normalCoef]; 
}

static void
drawCircle(cpFloat x, cpFloat y, cpFloat r, cpFloat a)
{
	const int segs = 15;
	const cpFloat coef = 2.0*M_PI/(cpFloat)segs;
	cpFloat *v = malloc(sizeof(cpFloat)*2*(segs+1));
  
  int n;
  for (n = 0; n <= segs; n++) {
    cpFloat rads = n*coef;
    v[2*n] = r*cos(rads + a) + x;
    v[2*n + 1] = r*sin(rads + a) + y;
  }
  v[2*n] = x;
  v[2*n+1] = y;
  
  glVertexPointer(2, GL_FLOAT, 0, v);
  glDrawArrays(GL_LINE_STRIP, 0, segs+1);
  
  free(v);
}

static void
drawCircleShape(cpShape *shape)
{
	cpBody *body = shape->body;
	cpCircleShape *circle = (cpCircleShape *)shape;
	cpVect c = cpvadd(body->p, cpvrotate(circle->c, body->rot));
	drawCircle(c.x, c.y, circle->r, body->a);
}

static void
drawSegmentShape(cpShape *shape)
{
	cpBody *body = shape->body;
	cpSegmentShape *seg = (cpSegmentShape *)shape;
	cpVect a = cpvadd(body->p, cpvrotate(seg->a, body->rot));
	cpVect b = cpvadd(body->p, cpvrotate(seg->b, body->rot));
	
  GLfloat *v = malloc(sizeof(GLfloat)*2*2);
  v[0] = a.x;
  v[1] = a.y;
  v[2] = b.x;
  v[3] = b.y;
  
  glVertexPointer(2, GL_FLOAT, 0, v);
  glDrawArrays(GL_LINES, 0, 2);
  
  free(v);
}

static void
drawPolyShape(cpShape *shape)
{
	cpBody *body = shape->body;
	cpPolyShape *poly = (cpPolyShape *)shape;
	
	int num = poly->numVerts;
	cpVect *verts = poly->verts;
	
  GLfloat *v = malloc(sizeof(GLfloat)*2*num);
  
  int i;
	for(i=0; i<num; i++){
		cpVect p = cpvadd(body->p, cpvrotate(verts[i], body->rot));
    v[2*i] = p.x;
    v[2*i+1] = p.y;
	}
  
  glVertexPointer(2, GL_FLOAT, 0, v);
  glDrawArrays(GL_LINE_LOOP, 0, num);
  
  free(v);
}

static void
drawObject(void *ptr, void *unused)
{
	cpShape *shape = (cpShape *)ptr;
	switch(shape->klass->type){
		case CP_CIRCLE_SHAPE:
			drawCircleShape(shape);
			break;
		case CP_SEGMENT_SHAPE:
			drawSegmentShape(shape);
			break;
		case CP_POLY_SHAPE:
			drawPolyShape(shape);
			break;
		default:
			NSLog(@"Bad enumeration in drawObject().");
	}
}

/* static void
drawCollisions(void *ptr, void *data)
{
	cpArbiter *arb = (cpArbiter *)ptr;
	for(int i=0; i<arb->numContacts; i++){
		cpVect v = arb->contacts[i].p;
		glVertex2f(v.x, v.y);
	}
} */

@implementation GRController

- (void)awakeFromNib {
  staticBody = cpBodyNew(INFINITY, INFINITY);
  
  cpResetShapeIdCounter();
  
  space = cpSpaceNew();
  cpSpaceResizeStaticHash(space, 20.0, 999);
  space->gravity = cpv(0, -100);
  
  cpBody *body;
  cpShape *shape;
  
  int num = 4;
  cpVect verts[] = {
    cpv(-15, -15),
    cpv(-15, 15),
    cpv(15, 15),
    cpv(15, -15),
  };
  
  shape = cpSegmentShapeNew(staticBody, cpv(-160, -230), cpv(-160, 230), 0.0f);
  shape->e = 1.0; shape->u = 1.0;
  cpSpaceAddStaticShape(space, shape);
  
  shape = cpSegmentShapeNew(staticBody, cpv(160, -230), cpv(160, 230), 0.0f);
  shape->e = 1.0; shape->u = 1.0;
  cpSpaceAddStaticShape(space, shape);
  
  shape = cpSegmentShapeNew(staticBody, cpv(-160, -230), cpv(160, -230), 0.0f);
  shape->e = 1.0; shape->u = 1.0;
  cpSpaceAddStaticShape(space, shape);
  
  shape = cpSegmentShapeNew(staticBody, cpv(-160, 230), cpv(160, 230), 0.0f);
  shape->e = 1.0; shape->u = 1.0;
  cpSpaceAddStaticShape(space, shape);
  
  for (int i = 0; i < 50; i++) {
    int j = i+1;
    cpVect a = cpv(i*10 - 230, i*-10 + 160);
    cpVect b = cpv(j*10 - 230, i*-10 + 160);
    cpVect c = cpv(j*10 - 230, j*-10 + 160);
    
    shape = cpSegmentShapeNew(staticBody, a, b, 0.0f);
		shape->e = 1.0; shape->u = 1.0;
		cpSpaceAddStaticShape(space, shape);
		
		shape = cpSegmentShapeNew(staticBody, b, c, 0.0f);
		shape->e = 1.0; shape->u = 1.0;
		cpSpaceAddStaticShape(space, shape);
  }
  
  body = cpBodyNew(1.0, cpMomentForPoly(1.0, num, verts, cpvzero));
	body->p = cpv(-135, 200);
	cpSpaceAddBody(space, body);
	shape = cpPolyShapeNew(body, num, verts, cpvzero);
	shape->e = 0.0; shape->u = 1.5;
	shape->collision_type = 1;
	cpSpaceAddShape(space, shape);
  
  // cpSpaceAddCollisionPairFunc(space, 1, 0, &GRCollisionPairFunc, self);
  
  [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
  [[UIAccelerometer sharedAccelerometer] setDelegate:self];
}

- (void)drawView:(GREAGLView *)view {
  glClear(GL_COLOR_BUFFER_BIT);
  
  glColor4f(0.0, 0.0, 0.0, 1.0);
	cpSpaceHashEach(space->activeShapes, &drawObject, NULL);
	cpSpaceHashEach(space->staticShapes, &drawObject, NULL);
		
	/* cpArray *bodies = space->bodies;
	int num = bodies->num;
	
	glBegin(GL_POINTS); {
		glColor3f(0.0, 0.0, 1.0);
		for(int i=0; i<num; i++){
			cpBody *body = (cpBody *)bodies->arr[i];
			glVertex2f(body->p.x, body->p.y);
		}
		
		glColor3f(1.0, 0.0, 0.0);
		cpArrayEach(space->arbiters, &drawCollisions, NULL);
	} glEnd(); */
  
  const GLfloat squareVertices[] = {
          -0.5f, -0.5f,
          0.5f,  -0.5f,
          -0.5f,  0.5f,
          0.5f,   0.5f,
    };
  glVertexPointer(2, GL_FLOAT, 0, squareVertices);
  glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
  
  space->gravity = cpv(accel[0], accel[1]);
#if TARGET_IPHONE_SIMULATOR
  static cpFloat a = 0.0;
  space->gravity = cpv(100.0*cos(-a), 100.0*sin(-a));
  a += 0.01;
#endif
  cpSpaceStep(space, 1.0/60.0);
}

- (void)setupView:(GREAGLView *)view {
  CGRect rect = view.bounds;
  glViewport(0, 0, rect.size.width, rect.size.height);
  // const GLfloat matAmbient[] = {0.0, 0.0, 0.0, 1.0};
  
  glEnableClientState(GL_VERTEX_ARRAY);
  
  // glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, matAmbient);
  
  glClearColor(1.0, 1.0, 1.0, 0.0);
  
  // glPointSize(3.0);
  
  // glEnable(GL_LINE_SMOOTH);
	// glEnable(GL_POINT_SMOOTH);
	// glEnable(GL_BLEND);
	// glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	// glHint(GL_LINE_SMOOTH_HINT, GL_DONT_CARE);
	// glHint(GL_POINT_SMOOTH_HINT, GL_DONT_CARE);
	// glLineWidth(2.5f);
  
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
  
  const GLfloat left = -160.0, right = 160.0;
  const GLfloat top = 230.0, bottom = -230.0;
  const GLfloat zNear = -1.0, zFar = 1.0;
  
  glOrthof(left, right, bottom, top, zNear, zFar);
	glTranslatef(0.5, 0.5, 0.0);
  
  glMatrixMode(GL_MODELVIEW);
}

- (void)collisionBetween:(cpShape *)a
                     and:(cpShape *)b
                contacts:(cpContact *)contacts
             numContacts:(int)numContacts
              normalCoef:(cpFloat)normalCoef {
  NSLog(@"collision!");
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
  //Use a basic low-pass filter to only keep the gravity in the accelerometer values
  accel[0] = acceleration.x * kFilteringFactor + accel[0] * (1.0 - kFilteringFactor);
  accel[1] = acceleration.y * kFilteringFactor + accel[1] * (1.0 - kFilteringFactor);
  accel[2] = acceleration.z * kFilteringFactor + accel[2] * (1.0 - kFilteringFactor);
}

@end
