/* 
 * Parts of this code is taken from miguelbalboa @ gitgithub.com/miguelbalboa
 * who has made the MFRC522 library
 *
 * version 0.2
 */
#include <SPI.h>
#include <MFRC522.h>

/* define pin numbers */
constexpr uint8_t RST_PIN = 9;
constexpr uint8_t SS_PIN = 10;

constexpr uint8_t BAKOVER_PIN = 2;
constexpr uint8_t PAUSE_STOP_PIN = 3;
constexpr uint8_t FREMOVER_PIN = 4;

/* define rf reader class */
MFRC522 rfid(SS_PIN, RST_PIN);
MFRC522::MIFARE_Key key; 

/* byte array that will hold the rfid */
byte nuidPICC[4] = {0xFF};

void setup()
{
  Serial.begin(9600);
  SPI.begin();
  rfid.PCD_Init();

  /* initialize the pushbutton pin as an inputs */
  pinMode(BAKOVER_PIN,INPUT);
  pinMode(PAUSE_STOP_PIN,INPUT);
  pinMode(FREMOVER_PIN,INPUT);
}

void loop()
{
  check_buttons();

  read_rfid();

}

void read_rfid()
{
  /* Look for new cards, if there are none exit function */
  if ( ! rfid.PICC_IsNewCardPresent()) {
    return;
  }

  /* Verify that the NUID has been read, if not exit the function */
  if ( ! rfid.PICC_ReadCardSerial()) {
    return;
  }

  for (byte i = 0; i < 4; i++) {
    nuidPICC[i] = rfid.uid.uidByte[i];
  }

  printHex(rfid.uid.uidByte, rfid.uid.size);
  Serial.println();
  
  rfid.PICC_HaltA();

  rfid.PCD_StopCrypto1();
}

void check_buttons()
{
  /* check if buttons has been pressed */
  if (digitalRead(FREMOVER_PIN) == HIGH) {
    Serial.println("fremover");
    delay(500);
  }
  if (digitalRead(PAUSE_STOP_PIN) == HIGH) {
    Serial.println("pauseStopp");
    delay(500);
  }
  if (digitalRead(BAKOVER_PIN) == HIGH) {
    Serial.println("bakover");
    delay(500);
  }
}

void printHex(byte *buffer, byte bufferSize)
{
  for (byte i = 0; i < bufferSize; i++) {
    Serial.print(buffer[i] < 0x10 ? "0" : "");
    Serial.print(buffer[i], HEX);
  }
}

