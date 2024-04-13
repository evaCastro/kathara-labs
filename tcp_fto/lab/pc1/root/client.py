import socket

addr = ("13.0.0.20", 9000)
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.setsockopt(socket.SOL_TCP, 23, 5)

#s.connect(addr)
#s.sendall(b"Hola mundo")
s.sendto(b"Hola mundo!",536870912,addr)

print(s.recv(1024))

