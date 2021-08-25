import websockets.*;

WebsocketClient wsc;
ColorPicker cp;

int Mode;
color BGCOLOR = #2B2B2B;
color SCOLOR = #FFFFFF;
color LINECOLOR = #AAAAAA;
color[][] BLOCK = new color[8][8];
String WSURL="ws://192.168.4.1:81/";
String Text[] = new String[]{"Draw", "Reset", "Stars", "Chase", "Cross", "Water", "Rotate", "Rect", "Text", "IP"};

void setup() {
  size(900, 600);
  textSize(30);
  wsc = new WebsocketClient(this, WSURL);
  cp=new ColorPicker(600, 20, 350, 300);
  for (int x=0; x<8; x++)
    for (int y=0; y<8; y++)
      BLOCK[x][y]=BGCOLOR;
}

void draw() {
  background(BGCOLOR);
  drawFrame();
}

void mousePressed() {
  GetMode();
  GetColor();
  GetPos();
}

void GetMode() {
  for (int i=0; i<5; i++)
    for (int j=0; j<2; j++)
      if (mouseX>600+130*j&&mouseX<700+130*j&&mouseY>330+50*i&&mouseY<370+50*i) {
        if (j+i*2==1)
          if (Mode==0)Mode=0;
          else return;
        else Mode=j+i*2;
        if (Mode!=0||Mode!=1)
          for (int x=0; x<8; x++)
            for (int y=0; y<8; y++)
              BLOCK[x][y]=BGCOLOR;
        String MYJSON = "{\"Mode\":"+Mode+'}';
        wsc.sendMessage(MYJSON);
        if (Mode==1)
          for (int x=0; x<8; x++)
            for (int y=0; y<8; y++)
              BLOCK[x][y]=BGCOLOR;
        return;
      }
}

void GetColor() {
  if (mouseX >= 600 &&mouseX < 890 &&mouseY >= 20 &&mouseY <= 320 ) {
    SCOLOR = get( mouseX, mouseY );
    String MYJSON = "{\"R\":"+(SCOLOR >> 16 & 0xFF)+",\"G\":"+(SCOLOR >> 8 & 0xFF)+",\"B\":"+(SCOLOR & 0xFF)+'}';
    wsc.sendMessage(MYJSON);
  }
}

void GetPos() {
  if (Mode==0||Mode==1)
    for (int x=0; x<8; x++)
      for (int y=0; y<8; y++) {
        if (mouseX>20+x*70&&mouseX<90+x*70&&mouseY>20+y*70&&mouseY<90+y*70) {
          if (mouseButton == LEFT) {
            BLOCK[x][y]=SCOLOR;
            String MYJSON = "{\"x\":"+x+",\"y\":"+y+",\"LED\":\"ON\"}";
            wsc.sendMessage(MYJSON);
            return;
          } else if (mouseButton == RIGHT) {
            String MYJSON = "{\"x\":"+x+",\"y\":"+y+",\"LED\":\"OFF\"}";
            BLOCK[x][y]=BGCOLOR;
            wsc.sendMessage(MYJSON);
            return;
          }
        }
      }
}

void drawFrame() {
  cp.render();
  strokeWeight(5);
  for (int x=0; x<8; x++)
    for (int y=0; y<8; y++) {
      fill(BLOCK[x][y]);
      rect(20+x*70, 20+y*70, 70, 70);
    }
  fill(BGCOLOR);
  for (int i=0; i<5; i++)
    for (int j=0; j<2; j++)
      rect(600+130*j, 330+50*i, 100, 40);
  fill(#AAAAAA);
  for (int i=0; i<5; i++)
    for (int j=0; j<2; j++)
      text(Text[j+i*2], 615+130*j, 360+50*i);
  strokeWeight(1);
  fill(SCOLOR);
  rect(850, 330, 40, 40);
}

void webSocketEvent(String message) {
  println("Received: " + message);
}
