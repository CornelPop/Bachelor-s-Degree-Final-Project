#include <WiFi.h>

const char* ssid = "Cluj - G2 - Et.1 - Ap.17";       // Replace with your network SSID (name)
const char* password = "romania-cluj";   // Replace with your network password

WiFiServer server(80);

void setup() {
  Serial.begin(9600);
  WiFi.begin(ssid, password);
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  
  Serial.println("Connected to WiFi");
  Serial.println(WiFi.localIP());

  server.begin();
  
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, LOW);
}

void loop() {
  WiFiClient client = server.available();
  if (client) {
    Serial.println("New Client.");
    String currentLine = "";
    
    while (client.connected()) {
      if (client.available()) {
        char c = client.read();
        Serial.write(c);
        if (c == '\n') {
          if (currentLine.length() == 0) {
            client.println("HTTP/1.1 200 OK");
            client.println("Content-type:text/html");
            client.println();

            client.print("Click <a href=\"/LED=ON\">here</a> to turn the LED on<br>");
            client.print("Click <a href=\"/LED=OFF\">here</a> to turn the LED off<br>");
            
            client.println();
            break;
          } else {
            currentLine = "";
          }
        } else if (c != '\r') {
          currentLine += c;
        }

        if (currentLine.endsWith("GET /LED=ON")) {
          digitalWrite(LED_BUILTIN, HIGH);
        }
        if (currentLine.endsWith("GET /LED=OFF")) {
          digitalWrite(LED_BUILTIN, LOW);
        }
      }
    }
    client.stop();
    Serial.println("Client Disconnected.");
  }
}
