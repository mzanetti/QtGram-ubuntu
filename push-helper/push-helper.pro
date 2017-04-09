QT += core
QT -= gui

CONFIG += c++11

load(ubuntu-click)

TARGET = push-helper
CONFIG += console
CONFIG -= app_bundle

TEMPLATE = app

SOURCES += main.cpp

CONF_FILES +=  push-helper.apparmor \
               push-helper.json

config_files.path = /push-helper
config_files.files += $${CONF_FILES}
INSTALLS+=config_files

target.path = $${UBUNTU_CLICK_BINARY_PATH}
INSTALLS+=target
