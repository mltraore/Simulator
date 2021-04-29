import sys
from PySide2.QtWidgets import QApplication
from PyQt5.QtCore import QObject
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtCore import QUrl, pyqtProperty, pyqtSlot, pyqtSignal, QVariant
from simulator import Simulator
import json
import random

class Bridge(QObject):
  def __init__(self):
    QObject.__init__(self)
    self.device_settings = None
    self.device_uuid_list = None
  

  # signal to emit when device_settings is set
  device_settings_sig = pyqtSignal(QVariant)
  
  # signal to emit when device_uuid_list is set
  device_uuid_list_sig = pyqtSignal(list) 
  
  # set device settings
  def set_device_settings(self, settings):
     if self.device_settings != settings:
       self.device_settings = settings
     self.device_settings_sig.emit(self.device_settings)
 
  # get device settings
  def get_device_settings(self):
     return self.device_settings
        
  
  # set device uuid list
  def set_device_uuid_list(self, uuid_list):
     if self.device_uuid_list != uuid_list:
        self.device_uuid_list  = uuid_list
     self.device_uuid_list_sig.emit(self.device_uuid_list)   
          
  
  # get device uuid list
  def get_device_uuid_list(self):
     return self.device_uuid_list 
     

  
  # Slot getting the simulator uuid from QML and set device settings
  @pyqtSlot(str)
  def device_settings_slot(self, uuid):
      simulator = Simulator(uuid)
      settings = simulator.get_settings()
      self.set_device_settings(settings)
        
  # Slot to sending the simulator uuid list to QML
  @pyqtSlot()
  def device_uuid_list_slot(self):
     """
     TODO:
          create a simulator instance here to get current uuid_list
          from mongodb
     """
     simulator = Simulator()
     device_uuid_list, device_type_list = simulator.get_device_uuid_list()
     self.set_device_uuid_list([device_uuid_list,device_type_list])
     
  
  # Slot getting the card info, insert to mongodb  and publish a specific topic
  @pyqtSlot('QString','QString',float)
  def card_info_slot(self, uuid, tpe, fee):
     values = f'{{"uuid":"{uuid}", "command":"get","type":"transaction","data":{{"type":"{tpe}","fee":{fee},"amount": {random.randint(0,100)}}}}}'
     simulator = Simulator()
     simulator.insert_one(values) 
     topic = 'diagnostic.{}.{}.1'.format(tpe,uuid)
     simulator.publish(topic, values)
  
     

  # device settings pyqt property
  simulator_settings = pyqtProperty(QVariant, get_device_settings, notify=device_settings_sig)
  
  # device uuid list pyqt property
  simulator_uuid_list = pyqtProperty(list, get_device_uuid_list, notify=device_uuid_list_sig)


if __name__ == "__main__":
  app = QApplication(sys.argv)
  engine = QQmlApplicationEngine()
  
  # Instance of the python object
  bridge = Bridge()
  
  # Expose the python object to QML
  engine.rootContext().setContextProperty("simulator",bridge)
  
  # Load QML file
  engine.load(QUrl("main.qml"))
  
  # Keep the app working
  sys.exit(app.exec_())
