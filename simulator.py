import paho.mqtt.client as mqtt
import threading
import json
import os
import uuid                    #FIXME  for generating unique ID, IS IT NECESSARY HERE
import configparser            #FIXME  kullanilmiyorsa kaldır
import socket                  #FIXME  kullanilmiyorsa kaldır
import pymongo
import pika


class Simulator:
   def __init__(self, deviceuuid="00D2AFE1-FED4-4A90-B3E9-AD228E202C85"):    
     
      self.deviceuuid = deviceuuid
      self.myclient = pymongo.MongoClient("mongodb://asis:Asd12345!@10.240.1.154:27017/?authSource=admin&readPreference=primary&appname=MongoDB%20Compass&ssl=false")
      self.mydb = self.myclient["simulator"]
           
      self.settings_collection = self.mydb["settings"]     # to get settings
      self.sim  = self.settings_collection.find_one({"uuid": self.deviceuuid})
                    
      self.devices_collection = self.mydb["devices"]       # to get devices
      self.sim  = self.devices_collection.find_one({"uuid": self.deviceuuid})
      self.devicetype = self.sim["type"] 
       
      self.commands_settings = self.mydb["commands"]
          
      self.message_from_subscriber = None
           
      self.client = mqtt.Client(client_id=self.deviceuuid + "_sim", clean_session=False)                   
      t = threading.Thread(target=self.thread_function, args=(self.client, ))
      t.start()
           
   def thread_function(self, client):
      client.on_connect = self.on_connect
      client.on_message = self.on_message
      client.username_pw_set(username="admin", password="Asd12345!")
      client.connect("10.240.1.52", 1883, 60)
      client.loop_forever()

   
   def on_connect(self, client, userdata, flags, rc):
      #print("Connected with result code "+str(rc))                            #FIXME
      client.subscribe([("Communication/Asis/"+self.devicetype+"/HardwareSettings/+/"+self.deviceuuid,1)])
      
   def publish(self, topic, payload): 
      self.client.publish(topic, payload)

 
   def on_message(self, client, userdata, msg):  #TODO
      self.message_from_subscriber = msg

      
   def insert_one(self, values):
      """
        # to see the insertion id 
         
        transaction_id = self.commands_settings.insert_one(json.loads(values)).inserted_id
        print(trans_id)
      """
      self.commands_settings.insert_one(json.loads(values))
      

   def get_settings(self):
      simulator = self.settings_collection.find_one({"uuid": self.deviceuuid})
      settings  = simulator["settings"]
      return settings
   
   def get_device_uuid_list(self):      
      devices = self.devices_collection.find()
      
      device_uuid_list = []
      device_type_list = []
      
      for device in devices:
         device_uuid_list.append(device["uuid"])
         device_type_list.append(device["type"])
     
      return device_uuid_list, device_type_list
      
      
   # to show simulator settings   
   def show_settings(self):
      simulator = self.settings_collection.find_one({"uuid": self.deviceuuid})
      print(simulator["settings"])
      
   
if __name__ == "__main__":
   simulator = Simulator("00D2AFE1-FED4-4A90-B3E9-AD228E202C85")
   print(simulator.message_from_subscriber)
      

