#         Pioneer AVR
#
#         Author: Krotof1a based on dnpwwo/artemgy work for Denon/Marrantz AVR
#
#   Mode3 ("Sources") needs to have '|' delimited names of sources that the Denon knows about. 
#
"""
<plugin key="Pioneer" name="Pioneer AVR Amplifier" author="krotof1a" version="1.0.0" wikilink="" externallink="">
    <params>
        <param field="Address" label="IP Address" width="200px" required="true" default="192.168.1.3"/>
        <param field="Port" label="Port" width="30px" required="true" default="8102"/>
        <param field="Mode3" label="Sources" width="550px" required="true" default="Off|BD|DVD|Sat|HDMI|Game|iPod|CD|BT|Net|Tuner|TV"/>
    </params>
</plugin>
"""
import Domoticz

class BasePlugin:
    myConn = None
    isConnected = False
    nextConnect = 3

    SourceOptions = {}
    selectorMap = {}
    inputDict = {"BD":"25FN","DVD":"04FN","Sat":"06FN","HDMI":"19FN","Game":"49FN","iPod":"17FN","CD":"01FN","BT":"56FN","Net":"26FN","Tuner":"02FN","TV":"05FN"}
    revInDict = {"FN25":"BD","FN04":"DVD","FN06":"Sat","FN19":"HDMI","FN49":"Game","FN17":"iPod","FN01":"CD","FN56":"BT","FN26":"Net","FN02":"Tuner","FN05":"TV"}

    powerOn = False
    mainOn = False
    mainSource = 0
    mainVolume1 = 0

    ignoreMessages = "|R|"

    def __init__(self):
        return

    def onStart(self):
        self.SourceOptions = {'LevelActions': '|'*Parameters["Mode3"].count('|'),
                             'LevelNames': Parameters["Mode3"],
                             'LevelOffHidden': 'false',
                             'SelectorStyle': '1'}
        if (len(Devices) == 0):
            Domoticz.Device(Name="Power", Unit=1, TypeName="Switch",  Image=5).Create()
            Domoticz.Device(Name="Main Zone", Unit=2, TypeName="Selector Switch", Switchtype=18, Image=5, Options=self.SourceOptions).Create()
            Domoticz.Device(Name="Main Volume", Unit=3, Type=244, Subtype=73, Switchtype=7, Image=8).Create()
        else:
            if (2 in Devices and (len(Devices[2].sValue) > 0)):
                self.mainSource = int(Devices[2].sValue)
                self.mainOn = (Devices[2].nValue != 0)
            if (3 in Devices and (len(Devices[3].sValue) > 0)):
                self.mainVolume1 = int(Devices[3].sValue) if (Devices[3].nValue != 0) else int(Devices[3].sValue)*-1
        DumpConfigToLog()
        dictValue=0
        for item in Parameters["Mode3"].split('|'):
            self.selectorMap[dictValue] = item
            dictValue = dictValue + 10
        self.myConn = Domoticz.Connection(Name="Pioneer", Transport="TCP/IP", Protocol="Line", Address=Parameters["Address"], Port=Parameters["Port"])
        self.myConn.Connect()

    def onStop(self):
        return

    def onConnect(self, Connection, Status, Description):
        if (Status == 0):
            self.isConnected = True
            Domoticz.Log("Connected successfully to: "+Parameters["Address"]+":"+Parameters["Port"])
            Connection.Send('?P\r')
            Connection.Send('?V\r')
            Connection.Send('?F\r')
        else:
            self.isConnected = False
            self.powerOn = False
            Domoticz.Log("Failed to connect ("+str(Status)+") to: "+Parameters["Address"]+":"+Parameters["Port"])
            self.SyncDevices()
        return

    def onMessage(self, Connection, Data, Status, Extra):
        strData = Data.decode("utf-8", "ignore")
        strData = strData.strip()
        action = strData[0:3]
        detail = strData[3:]
        if (action == "PWR"):        # Power Status
            if (detail == "2"):
                self.powerOn = False
                self.mainOn=False
            elif (detail == "1"):
                self.powerOn = False
                self.mainOn=False
            elif (detail == "0"):
                self.powerOn = True
                self.mainOn=True
            else: Domoticz.Debug("Unknown: Action "+action+", Detail '"+detail+"' ignored.")
        elif (action == "MUT"):      # Overall Mute
            if (detail == "0"):         self.mainVolume1 = abs(self.mainVolume1)*-1
            elif (detail == "1"):       self.mainVolume1 = abs(self.mainVolume1)
            else: Domoticz.Debug("Unknown: Action "+action+", Detail '"+detail+"' ignored.")
        elif (action == "VOL"):      # Master Volume
            if (detail.isdigit()):
                compValue = int(round(int(detail[0:3])/1.5))
                if (abs(self.mainVolume1) != compValue): self.mainVolume1 = compValue
            else: Domoticz.Log("Unknown: Action "+action+", Detail '"+detail+"' ignored.")
        elif (action[:2] == "FN"):
            fullCode=action+detail[:1]
            itemName=self.revInDict[fullCode]
            for key, value in self.selectorMap.items():
                if (itemName == value):      self.mainSource = key
        else:
            if (self.ignoreMessages.find(action) < 0):
                Domoticz.Debug("Unknown message '"+action+"' ignored.")
        self.SyncDevices()
        return

    def onCommand(self, Unit, Command, Level, Hue):
        Command = Command.strip()
        action, sep, params = Command.partition(' ')
        action = action.capitalize()
        params = params.capitalize()
        if (Unit == 1):      # Main power switch
            if (action == "On"):
                self.myConn.Send(Message='PO\r')
                self.myConn.Send(Message='?V\r')
                self.myConn.Send(Message='?F\r')
            elif (action == "Off"):
                self.myConn.Send(Message='PF\r')
        elif (Unit == 2):     # Main selector
            if (action == "Set"):
                if (self.powerOn == False): 
                    self.myConn.Send(Message='PO\r')
                    self.myConn.Send(Message='?V\r')
                inputCode=self.inputDict[self.selectorMap[Level]]
                self.myConn.Send(Message=inputCode+'\r')
        elif (Unit == 3):     # Main Volume control
            if (self.powerOn == False): 
                self.myConn.Send(Message='PO\r')
                self.myConn.Send(Message='?V\r')
                self.myConn.Send(Message='?F\r')
            if (action == "On"):
                self.myConn.Send(Message='MF\r')
            elif (action == "Set"):
                # Workaround with VD/VU as xxxVL command not working on VSX-824
                goal = int(round(int(Level)*1.5))
                currentlevel = int(round(int(self.mainVolume1)*1.5))
                if currentlevel > goal:
                        for x in range(currentlevel, goal, -2):
                                self.myConn.Send(Message='VD\r')
                else:
                        for x in range(currentlevel, goal, 2):
                                self.myConn.Send(Message='VU\r')
            elif (action == "Off"):
                self.myConn.Send(Message='MO\r')
        return

    def onNotification(self, Name, Subject, Text, Status, Priority, Sound, ImageFile):
        return

    def onDisconnect(self, Connection):
        self.isConnected = False
        Domoticz.Log("Pioneer device has disconnected.")
        return

    def onHeartbeat(self):
        if (self.isConnected == False):
            # if not connected try and reconnected every 3 heartbeats
            self.nextConnect = self.nextConnect - 1
            if (self.nextConnect <= 0):
                self.nextConnect = 3
                self.myConn.Connect()
        return

    def SyncDevices(self):
        if (self.powerOn == False):
            UpdateDevice(1, 0, "Off")
            UpdateDevice(2, 0, "0")
            UpdateDevice(3, 0, str(abs(self.mainVolume1)))
        else:
            UpdateDevice(1, 1, "On")
            UpdateDevice(2, self.mainSource if self.mainOn else 0, str(self.mainSource if self.mainOn else 0))
            if (self.mainVolume1 <= 0 or self.mainOn == False): UpdateDevice(3, 0, str(abs(self.mainVolume1)))
            else: UpdateDevice(3, 2, str(self.mainVolume1))
        return

global _plugin
_plugin = BasePlugin()

def onStart():
    global _plugin
    _plugin.onStart()

def onStop():
    global _plugin
    _plugin.onStop()

def onConnect(Connection, Status, Description):
    global _plugin
    _plugin.onConnect(Connection, Status, Description)

def onMessage(Connection, Data, Status, Extra):
    global _plugin
    _plugin.onMessage(Connection, Data, Status, Extra)

def onCommand(Unit, Command, Level, Hue):
    global _plugin
    _plugin.onCommand(Unit, Command, Level, Hue)

def onNotification(Name, Subject, Text, Status, Priority, Sound, ImageFile):
    global _plugin
    _plugin.onNotification(Name, Subject, Text, Status, Priority, Sound, ImageFile)

def onDisconnect(Connection):
    global _plugin
    _plugin.onDisconnect(Connection)

def onHeartbeat():
    global _plugin
    _plugin.onHeartbeat()

    # Generic helper functions

def UpdateDevice(Unit, nValue, sValue):
    # Make sure that the Domoticz device still exists (they can be deleted) before updating it 
    if (Unit in Devices):
        if (Devices[Unit].nValue != nValue) or (Devices[Unit].sValue != sValue):
            Devices[Unit].Update(nValue, str(sValue))
            Domoticz.Log("Update "+str(nValue)+":'"+str(sValue)+"' ("+Devices[Unit].Name+")")
    return

def DumpConfigToLog():
    for x in Parameters:
        if Parameters[x] != "":
            Domoticz.Debug( "'" + x + "':'" + str(Parameters[x]) + "'")
    Domoticz.Debug("Device count: " + str(len(Devices)))
    for x in Devices:
        Domoticz.Debug("Device:           " + str(x) + " - " + str(Devices[x]))
        Domoticz.Debug("Device ID:       '" + str(Devices[x].ID) + "'")
        Domoticz.Debug("Device Name:     '" + Devices[x].Name + "'")
        Domoticz.Debug("Device nValue:    " + str(Devices[x].nValue))
        Domoticz.Debug("Device sValue:   '" + Devices[x].sValue + "'")
        Domoticz.Debug("Device LastLevel: " + str(Devices[x].LastLevel))
    return
