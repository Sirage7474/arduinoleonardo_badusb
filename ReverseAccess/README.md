
# Rᴇᴠᴇʀsᴇ-Sʜᴇʟʟ-Aʀᴅᴜɪɴᴏ

### Adapted from Rᴇᴠᴇʀsᴇ-Sʜᴇʟʟ-Aʀᴅᴜɪɴᴏ Written by @Sirage7474
### Original is made by @b00stfr3ak

This ruby script will:</br>
1. Generates a shell script based on Windows Powershell</br>
2. Uploads the shell script to default root of Apache webserver: <b>/var/www/html/shell.txt</b></br>
3. Generates a complete Arduino sketch that will download and execute the shell script</br>
4. Run a default Apache webserver</br>
5. Open a meterpreter listener</br>

## 📥 How to Install?

Clone The Repository
```
https://github.com/Sirage7474/arduinoleonardo_badusb.git
```

Run
```
cd Reverse-Shell-Arduino
```

```
sudo ruby reverse-shell-arduino.rb
```

If your on Termux
```
ruby reverse-shell-arduino-termux.rb
```

### Tested on Kali Linux


If you want to use other webserver, you can modify the arduino script later. Just change the URL.<br/>

This basic setup only works on LAN. If you want to try it using Internet, you need to configure a <b>Port Forwarding</b> or <b>DMZ</b> on your modem.

## ❗ Disclaimer ❗

## ⚠️ This project is intended for educational and legal security testing only. Misuse is strictly prohibited. The authors are not responsible for any unauthorized use.


