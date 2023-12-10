import peasy.*;
import controlP5.*;

ArrayList<Polygon> polygons;

int horizontalSections = 36; // 椭球体水平细分数
int verticalSections = 72; // 椭球体垂直细分数
float radiusX = 200; // 椭球体X轴半径
float radiusY = 150; // 椭球体Y轴半径
float radiusZ = 100; // 椭球体Z轴半径
float twist = 0; // 每层三角形的轴向扭曲弧度值

float ProbOfShowShape = 0.75; // 每个多边形单元的显示概率

ControlP5 cp5;
PeasyCam cam;

void setup() {
  size(1200, 1200, P3D);
  cam = new PeasyCam(this, 800);
  cp5 = new ControlP5(this);

  setSystem();
  UI();
}

void setSystem() {
  polygons = new ArrayList<Polygon>();
  buildSphereMesh(radiusX, radiusY, radiusZ, twist, horizontalSections, verticalSections);
  
  for (Polygon p : polygons) {
    if (random(1) < ProbOfShowShape) {
      p.show = true;
    }
  }
}

void draw() {
  background(102);
  lights();
  
  for (Polygon p : polygons) {
    if (p.show) {
      p.display();
    }
  }
  
  cam.beginHUD();
  cp5.draw();
  cam.endHUD();
  
  saveFrame();
}

void buildSphereMesh(float rX, float rY, float rZ, float twist, int hSect, int vSect) {
  polygons.clear(); // 清除当前所有多边形以便重新生成
  for (int i = 0; i < vSect; i++) {
    float phi1 = map(i, 0, vSect, 0, PI);
    float phi2 = map(i+1, 0, vSect, 0, PI);
    
    for (int j = 0; j < hSect; j++) {
      float theta1 = map(j, 0, hSect, 0, TWO_PI) + twist * phi1;
      float theta2 = map(j+1, 0, hSect, 0, TWO_PI) + twist * phi1;
      float theta3 = map(j, 0, hSect, 0, TWO_PI) + twist * phi2;
      float theta4 = map(j+1, 0, hSect, 0, TWO_PI) + twist * phi2;
      
      PVector[] vertices = new PVector[4];
      vertices[0] = sphericalToCartesian(rX, rY, rZ, theta1, phi1);
      vertices[1] = sphericalToCartesian(rX, rY, rZ, theta2, phi1);
      vertices[2] = sphericalToCartesian(rX, rY, rZ, theta4, phi2);
      vertices[3] = sphericalToCartesian(rX, rY, rZ, theta3, phi2);
      
      polygons.add(new Polygon(vertices));
    }
  }
}

PVector sphericalToCartesian(float rX, float rY, float rZ, float theta, float phi) {
  float x = rX * sin(phi) * cos(theta);
  float y = rY * sin(phi) * sin(theta);
  float z = rZ * cos(phi);
  return new PVector(x, y, z);
}

class Polygon {
  PVector[] vertices;
  boolean show = false;
  
  Polygon(PVector[] verts) {
    vertices = verts;
  }
  
  void display() {
    beginShape(TRIANGLE_STRIP);
    for (PVector v : vertices) {
      vertex(v.x, v.y, v.z);
    }
    endShape(CLOSE);
  }
}

void UI() {
  cp5.addSlider("ProbOfShowShape")
    .setPosition(20, 20)
    .setSize(300, 30)
    .setRange(0, 1)
    .setValue(ProbOfShowShape)
    ;

  cp5.addSlider("radiusX")
    .setPosition(20, 60)
    .setSize(300, 30)
    .setRange(50, 400)
    .setValue(radiusX)
    ;
  
  cp5.addSlider("radiusY")
    .setPosition(20, 100)
    .setSize(300, 30)
    .setRange(50, 400)
    .setValue(radiusY)
    ;

  cp5.addSlider("radiusZ")
    .setPosition(20, 140)
    .setSize(300, 30)
    .setRange(50, 400)
    .setValue(radiusZ)
    ;

  cp5.addSlider("twist")
    .setPosition(20, 180)
    .setSize(300, 30)
    .setRange(-PI, PI)
    .setValue(twist)
    ;

  cp5.setAutoDraw(false);
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isController()) {
    switch(theEvent.getController().getName()) {
      case "ProbOfShowShape":
        ProbOfShowShape = theEvent.getController().getValue();
        break;
      case "radiusX":
        radiusX = theEvent.getController().getValue();
        break;
      case "radiusY":
        radiusY = theEvent.getController().getValue();
        break;
      case "radiusZ":
        radiusZ = theEvent.getController().getValue();
        break;
      case "twist":
        twist = theEvent.getController().getValue();
        break;
    }
    setSystem(); // 更新系统设置以重建椭球体
  }
}
