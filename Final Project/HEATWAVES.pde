import controlP5.*;
import com.hamoid.*;

// 声明变量
boolean isRecording = false;
VideoExport videoExport;
PFont f;
ControlP5 cp5;
String inputText = "HEAT-WAVE";
int fSize = 80;
float angle;
float maxJAngle = 180;
float speed = 0.5;
color textColor = color(230, 100, 40);

void setup() {
  fullScreen(P2D);
  f = createFont("Arial Black", fSize, true);

  // 设置文本属性
  textFont(f);
  textSize(fSize);
  textAlign(CENTER, CENTER);

  // 初始化控件
  cp5 = new ControlP5(this);

  // 添加输入文本、字体大小、速度、最大角度和颜色控制器
  cp5.addTextfield("inputText")
     .setPosition(width * 0.01, height * 0.02)
     .setSize(width * 0.1, height * 0.02)
     .setFont(createFont("Arial", 20))
     .setText("HEAT-WAVE")
     .setColor(color(255, 255, 255))
     .setLabel("Input Text");

  cp5.addSlider("fontSize")
     .setPosition(width * 0.01, height * 0.06)
     .setSize(width * 0.1, height * 0.02)
     .setFont(createFont("Arial", 20))
     .setRange(30, 150)
     .setValue(80)
     .setLabel("Font Size");

  cp5.addSlider("speed")
     .setPosition(width * 0.01, height * 0.09)
     .setSize(width * 0.1, height * 0.02)
     .setFont(createFont("Arial", 20))
     .setRange(0, 3)
     .setValue(0.5)
     .setLabel("Animation Speed");

  cp5.addSlider("maxJAngle")
     .setPosition(width * 0.01, height * 0.12)
     .setSize(width * 0.1, height * 0.02)
     .setFont(createFont("Arial", 20))
     .setRange(0, 1440)
     .setValue(180)
     .setLabel("Max Angle");

  cp5.addColorPicker("textColor")
     .setPosition(width * 0.01, height * 0.15)
     .setSize(width * 0.1, height * 0.1)
     .setFont(createFont("Arial", 20))
     .setColorValue(textColor)
     .setLabel("Text Color");

  // 添加帧保存和视频录制控制按钮
  cp5.addButton("saveCurrentFrame")
     .setLabel("Save Current Frame")
     .setPosition(width * 0.01, height * 0.2)
     .setSize(width * 0.1, height * 0.02)
     .setFont(createFont("Arial", 20));

  cp5.addButton("startRecording")
     .setLabel("Start Recording")
     .setPosition(width * 0.01, height * 0.23)
     .setSize(width * 0.1, height * 0.02)
     .setFont(createFont("Arial", 20));

  cp5.addButton("stopRecording")
     .setLabel("Stop Recording")
     .setPosition(width * 0.01, height * 0.26)
     .setSize(width * 0.1, height * 0.02)
     .setFont(createFont("Arial", 20));

  // 初始化视频导出对象
  videoExport = new VideoExport(this);
  videoExport.setFrameRate(30);
}

void draw() {
  background(0);
  f = createFont("Arial Black", fSize, true);
  textFont(f);
  textSize(fSize);

  int fWidth = int(textWidth(inputText));
  int fHeight = int(textAscent());

  // 如果正在录制，则保存帧
  if (isRecording) {
    videoExport.saveFrame();
  }

  // 绘制波形文字
  for (int i = -fWidth; i < width + fWidth; i += fWidth) {
    float alphaAngle = map(i, 0, width, 0, 720);
    float alpha = map(sin(radians(alphaAngle + angle * 4)), -1, 1, 0, 200);

    for (int j = -fHeight; j < height + fHeight; j += fHeight) {
      float jAngle = map(j, 0, height, 0, maxJAngle);
      float x = map(sin(radians(jAngle + angle)), -1, 1, -width / 2, width / 2);
      fill(textColor, 255 - alpha);
      text(inputText, i + x, j);
    }
  }
  angle += speed;
}

// 控制事件回调
public void controlEvent(ControlEvent event) {
  if (event.getController().getName().equals("inputText")) {
    inputText = event.getController().getStringValue();
  }
}

// 字体大小调整回调
public void fontSize(float newSize) {
  fSize = int(newSize);
}

// 动画速度调整回调
public void speed(float newSpeed) {
  speed = newSpeed;
}

// 文字颜色调整回调
public void textColor(int newColor) {
  textColor = newColor;
}

// 保存当前帧
public void saveCurrentFrame() {
  saveFrame("frame-######.png");
}

// 开始录制视频
public void startRecording() {
  if (!isRecording) {
    videoExport.setMovieFileName("output/video.mp4");
    videoExport.startMovie();
    isRecording = true;
  }
}

// 停止录制视频
public void stopRecording() {
  if (isRecording) {
    videoExport.endMovie();
    isRecording = false;
  }
}

// 确保在程序结束时结束录制
void stop() {
  if (isRecording) {
    videoExport.endMovie();
  }
  super.stop();
}
