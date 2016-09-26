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

SERVER= sys.argv[1];
EMAIL_ACCOUNT = sys.argv[2];
EMAIL_PASS = sys.argv[3];
DOMO_HOST = "192.168.1.17"
DOMO_PORT = "5665"
interval=10;

pidfile = sys.argv[0] + '_' + sys.argv[1] + '.pid'
if os.path.isfile( pidfile ):
    print "Pid file exists"
    if (time.time() - os.path.getmtime(pidfile)) < (float(interval) * 3):
      print "Script seems to be still running, exiting"
      print "If this is not correct, please delete file " + pidfile
      sys.exit(0)
    else:
      print "Seems to be an old file, ignoring."
else:
    open(pidfile, 'w').close()

def domoticzTalkMessage(msgFrom, msgTo, msgText):
    msgFull = msgTo+". J'ai un message de " + msgFrom + ". Il dit: " + msgText;
    msgSend = urllib.quote(msgFull);
    urllib.urlopen("http://"+DOMO_HOST+":"+DOMO_PORT+"/json.htm?type=command&param=udevice&idx=179&nvalue=0&svalue="+msgSend);

def process_mailbox(M):
    """
    Do something with emails messages in the folder.  
    For the sake of this example, print some headers.
    """

    rv, data = M.search(None, "ALL")
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
				msg_text = part.get_payload();
	else:
		msg_text=msg.get_payload();
        print 'Message %s: %s' % (num, msg_text);
	if ("christophe.safra" in msg_from):
		domoticzTalkMessage("Christophe", "Cécile", msg_text);
	elif ("cecile.houel" in msg_from):
		domoticzTalkMessage("Cécile", "Christophe", msg_text);

	M.store(num, '+FLAGS', '\\Deleted');


M = imaplib.IMAP4(SERVER);
try:
    rv, data = M.login(EMAIL_ACCOUNT, EMAIL_PASS)
except imaplib.IMAP4.error:
    print ("LOGIN FAILED!!! ")
    sys.exit(1)

while (1==1):
	rv, data = M.select("INBOX")
	if rv == 'OK':
    		print("Processing inbox...\n")
    		process_mailbox(M)
    		M.expunge();
    		M.close()
	else:
    		print("ERROR: Unable to open mailbox ", rv)

	open(pidfile, 'w').close();
	time.sleep(interval);

M.logout()
