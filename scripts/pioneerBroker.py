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
  global tn
  try:
  	tn = telnetlib.Telnet(PIONEER_HOST, PIONEER_PORT)
	print 'Connected to Pioneer AVR'
	# Process info from Pioneer here ... TBC
	tn.close()
  except Exception, e:
	tn.close()
        time.sleep(interval)
        t2=thread.start_new_thread(processPioneer, ())
	
def processHttpAction( action ):
  if (action == 'on'):
	tn.write('PO\r\n')
  elif (action == 'off'):
	tn.write('PF\r\n')
  elif (action[:3] == 'vol'):
	goal = int(action[3:]) * 1.5
	if goal < 150
		tn.write('{:03}'.format(goal) + 'VL\r\n')
	else:
		print('Given volume is out of range')
  else:
	print('Command not recognized')
	
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
			processHttpAction(action)
  except Exception, e:
	time.sleep(interval);
	t1=thread.start_new_thread(runHttpServer, ())

if __name__=='__main__':
	t2=thread.start_new_thread(processPioneer, ())
	t1=thread.start_new_thread(runHttpServer, ())
	# Cause main prog to wait for threads
	while True:
		time.sleep(interval)
