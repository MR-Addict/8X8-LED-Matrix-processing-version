#include <WiFi.h>
#include <FastLED.h>
#include <ArduinoJson.h>
#include <WebSocketsServer.h>
#include "unities.h"

const char* ssid = "ESP32";
const char* password = "123456789";

const uint8_t LED_PIN = 32;
const uint8_t NUM_LEDS = 64;

boolean isShow;
uint8_t Pos_X, Pos_Y;
uint8_t Mode;
uint8_t BRIGHTNESS = 50;
uint8_t Palette_Mode;
uint8_t R = 255, G = 255, B = 255;
unsigned long Last_Time;

String SoftAPIP = "192.168.4.1";
String TEXT = "Hello world!";

CRGBPalette16 ColorPalette[] = {RainbowColors_p, CloudColors_p, OceanColors_p, LavaColors_p, ForestColors_p};

CRGB leds[NUM_LEDS];

WebSocketsServer websocket(81);

#include "WS_Function.h"
#include "LED_Function.h"

void setup() {
  delay(3000);
  Serial.begin(115200);
  FastLED.addLeds<WS2812, LED_PIN, GRB>(leds, NUM_LEDS);
  FastLED.setBrightness(BRIGHTNESS);
  WIFI_Init();
  Server_Init();
}

void loop() {
  Display();
  websocket.loop();
}
