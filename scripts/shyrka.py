#!/usr/bin/python
# coding: latin-1
#

import sys
import imaplib
import email
import email.header
import urllib;
import time;
import os;
import urllib2 
import json
from socket import *
import thread

SERVER= sys.argv[1];
EMAIL_ACCOUNT = sys.argv[2];
EMAIL_PASS = sys.argv[3];
DOMO_HOST = "192.168.1.20"
DOMO_PORT = "5665"
interval=10;
HTTPD_HOST = "127.0.0.1"
HTTPD_PORT = 4567 

# Usefull functions
def domoticzStatus (switchid):
  url = "http://"+DOMO_HOST+":"+DOMO_PORT+"/json.htm?type=devices&filter=all&used=true&order=Name"
  request = urllib2.Request(url)
  response = urllib2.urlopen(request)
  json_object = json.loads(response.read())
  status = 0
  switchfound = False
  if json_object["status"] == "OK":
    for i, v in enumerate(json_object["result"]):
      if json_object["result"][i]["idx"] == switchid:
        switchfound = True
        if json_object["result"][i]["Status"] == "On": 
          status = 1
        if json_object["result"][i]["Status"] == "Off": 
          status = 0
  if switchfound == False: print "Error. Could not find switch idx in Domoticz response. Defaulting to switch off."
  return status

def domoticzTalkMessage(msgFrom, msgTo, msgText):
    if ("Shyrka" in msgFrom):
	msgSend = urllib.quote(msgTo+". ")+msgText;
    else:
        msgFull = msgTo+". J'ai un message de " + msgFrom + ". Il dit: " + msgText;
    	msgSend = urllib.quote(msgFull);
    urllib.urlopen("http://"+DOMO_HOST+":"+DOMO_PORT+"/json.htm?type=command&param=udevice&idx=106&nvalue=0&svalue="+msgSend);

def handleMessage(msgFrom, msgSubj, msgText, unSeenMode=True):
	if ("christophe." in msgFrom):
		orig="Christophe"
	elif ("cecile." in msgFrom):
		orig="Cécile"
	elif ("Shyrka@" in msgFrom):
		orig="Shyrka"
	else :
		orig=msgFrom

	if (domoticzStatus("114")):
		domoticzTalkMessage(orig, "Christophe", msgSubj+msgText)
		return 1
	elif (domoticzStatus("115")):
		domoticzTalkMessage(orig, "Cécile", msgSubj+msgText)
		return 1
	else :
		return 0

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
			message = string.split(' ')[1].split('=')[1]
			print message
			handleMessage("Shyrka@", message, "", True)
  except Exception, e:
	time.sleep(interval);
	t1=thread.start_new_thread(runHttpServer, ())	
	
def process_mailbox(M, unSeenMode=True):
    if (unSeenMode):
    	rv, data = M.search(None, "UNSEEN")
    else:
    	rv, data = M.search(None, "SEEN")

    if rv != 'OK':
        print("No messages found!")
        return

    for num in data[0].split():
        rv, data = M.fetch(num, '(RFC822)')
        if rv != 'OK':
            print("ERROR getting message", num)
            return

	msg = email.message_from_string(data[0][1])
	msg_from = msg.get('From');
	msg_subj = msg.get('Subject');  
	msg_text = "";
	if msg.is_multipart():
    		for part in msg.walk():
			if ("text/plain" in part.get_content_type()):
				msg_text = part.get_payload(decode=True);
	else:
		msg_text=msg.get_payload(decode=True);
        print 'Message %s: %s : %s' % (num, msg_subj, msg_text);
	if (handleMessage(msg_from, msg_subj, msg_text, unSeenMode)==1):
		M.store(num, '+FLAGS', '\\Deleted');
		print 'Deleted'
	else:
	    if (unSeenMode):
		M.store(num, '+FLAGS', '\\Seen');
		print 'Flagged seen'

def runImapClient():
	M = imaplib.IMAP4(SERVER);
	try:
    		rv, data = M.login(EMAIL_ACCOUNT, EMAIL_PASS)
	except imaplib.IMAP4.error:
    		print ("LOGIN FAILED!!! ")
    		sys.exit(1)

	while (1==1):
		rv, data = M.select("INBOX")
		if rv == 'OK':
    			print("Processing inbox for queued messages ...\n")
    			process_mailbox(M, False)
    			print("Processing inbox for unseen messages ...\n")
    			process_mailbox(M, True)
    			M.expunge();
    			M.close()
		else:
    			print("ERROR: Unable to open mailbox ", rv)

		time.sleep(interval);

	M.logout()

if __name__=='__main__':

	# Test that script is not already running
	pidfile = sys.argv[0] + '_' + sys.argv[1] + '.pid'
	if os.path.isfile( pidfile ):
    		print "Pid file exists"
    		if (time.time() - os.path.getmtime(pidfile)) < 60*float(interval):
      			print "Script seems to be still running, exiting"
      			print "If this is not correct, please delete file " + pidfile
      			sys.exit(0)
    		else:
      			print "Seems to be an old file, ignoring."
	else:
    		open(pidfile, 'w').close()

	# Run notif server for Domoticz
	t1=thread.start_new_thread(runHttpServer, ())

	# Run Imap client continuously
	t2=thread.start_new_thread(runImapClient, ())
	
	# Cause main prog to wait for threads
	while True:
		open(pidfile, 'w').close();
		time.sleep(interval)
