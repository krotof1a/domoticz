#!/usr/bin/python
# coding: latin-1
#
from socket import *
import thread
import time
import telnetlib
import urllib2

HTTPD_HOST = "127.0.0.1"
HTTPD_PORT = 8102

DOMO_HOST = "192.168.1.20"
DOMO_PORT = "5665"
VOL_IDX="1056"

PIONEER_HOST = "192.168.1.3"
PIONEER_PORT = 8102

interval=1
tn=0
lastTelnetAnswer=''

def processPioneer():
  global tn, lastTelnetAnswer
  try:
  	tn = telnetlib.Telnet(PIONEER_HOST, PIONEER_PORT)
	print 'Connected to Pioneer AVR'
	while 1:
		lastTelnetAnswer = tn.read_until("\r\n")
		print(lastTelnetAnswer)
		if (lastTelnetAnswer[:4] == 'PWR0'):
			url = "http://"+DOMO_HOST+":"+DOMO_PORT+"/json.htm?type=command&param=udevice&idx="+VOL_IDX+"&nvalue=1"
  			request = urllib2.Request(url)
			urllib2.urlopen(request)
			print 'Updated Domoticz volume switch to ON'
		if (lastTelnetAnswer[:4] == 'PWR2'):
			url = "http://"+DOMO_HOST+":"+DOMO_PORT+"/json.htm?type=command&param=udevice&idx="+VOL_IDX+"&nvalue=0"
  			request = urllib2.Request(url)
			urllib2.urlopen(request)
			print 'Updated Domoticz volume switch to OFF'
		if (lastTelnetAnswer[:3] == 'VOL'):
			value = int(round(int(lastTelnetAnswer[3:6])/1.5))
			url = "http://"+DOMO_HOST+":"+DOMO_PORT+"/json.htm?type=command&param=udevice&idx="+VOL_IDX+"&svalue="+str(value)
  			request = urllib2.Request(url)
			urllib2.urlopen(request)
			print 'Updated Domoticz volume switch to '+str(value)

  except Exception, e:
	tn.close()
        time.sleep(interval)
        t2=thread.start_new_thread(processPioneer, ())
	
def processHttpAction( action ):
  global tn, lastTelnetAnswer
  if (action == 'on'):
	print ('Power on')
	tn.write('PO\r\n')
  elif (action == 'off'):
	print ('Power off')
	tn.write('PF\r\n')
  elif (action[:3] == 'vol'):
	goal = int(round(int(action[3:]) * 1.5))
	tn.write("?V\r\n")
	time.sleep(0.2)
	currentlevel = int(lastTelnetAnswer[3:])
	print ('Set volume from '+str(currentlevel)+' to '+str(goal))
	if goal < 150:
		if currentlevel > goal:
    			for x in range(currentlevel, goal, -2):
      				tn.write("VD\r\n")
  		else:
    			for x in range(currentlevel, goal, 2):
      				tn.write("VU\r\n")
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
		#print 'Waiting for connection...'
        	clientsock, addr = serversock.accept()
        	#print '...connected from:', addr
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
