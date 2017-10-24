#!/usr/bin/python
# coding: latin-1
#
from socket import *
import thread
import time
import telnetlib

HTTPD_HOST = "127.0.0.1"
HTTPD_PORT = 8102

PIONEER_HOST = "192.168.1.3"
PIONEER_PORT = 8102

interval=10

def processPioneer():
  try:
  	tn = telnetlib.Telnet(PIONEER_HOST, PIONEER_PORT)
  except Exception, e:
	tn.close()
        time.sleep(interval)
        t2=thread.start_new_thread(processPioneer, ())

def runHttpServer():
  ADDR = (HTTPD_HOST, HTTPD_PORT)
  serversock = socket(AF_INET, SOCK_STREAM)
  serversock.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
  try:
  	serversock.bind(ADDR)
  	serversock.listen(5)
  	while 1:
		print 'Waiting for connection...'
        	clientsock, addr = serversock.accept()
        	print '...connected from:', addr
		data = clientsock.recv(2048)
        	if not data: break
		else:
			gen_response="HTTP/1.1 200 OK\n"
        		clientsock.send(gen_response)
	        	clientsock.close()
			string = bytes.decode(data)
			action = string.split(' ')[1].split('=')[1]
			print action
  except Exception, e:
	time.sleep(interval);
	t1=thread.start_new_thread(runHttpServer, ())

if __name__=='__main__':
	t1=thread.start_new_thread(runHttpServer, ())
        t2=thread.start_new_thread(processPioneer, ())
	# Cause main prog to wait for threads
	while True:
		time.sleep(interval)
