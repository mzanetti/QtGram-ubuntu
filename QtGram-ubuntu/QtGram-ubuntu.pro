TEMPLATE = app
TARGET = QtGram-ubuntu
CONFIG += c++11

load(ubuntu-click)

QT += qml quick

INCLUDEPATH += ../../LibQTelegram/

SOURCES += main.cpp \
    qtgram.cpp

HEADERS += \
    qtgram.h

RESOURCES += QtGram-ubuntu.qrc

#LIBS += -L../../build-LibQTelegram-Desktop-Debug -lQTelegram
LIBS += -L../../build-LibQTelegram-turbo_GCC_armhf_ubuntu_sdk_15_04_device_armhf-Debug/ -lQTelegram


QML_FILES += $$files(*.qml,true) \
             $$files(*.js,true)

CONF_FILES +=  QtGram-ubuntu.apparmor \
               icon.svg

AP_TEST_FILES += tests/autopilot/run \
                 $$files(tests/*.py,true)

#show all the files in QtCreator
OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
               $${AP_TEST_FILES} \
               QtGram-ubuntu.desktop

#specify where the config files are installed to
config_files.path = /QtGram-ubuntu
config_files.files += $${CONF_FILES}
INSTALLS+=config_files

libqtelegram.path = $${UBUNTU_CLICK_BINARY_PATH}/..
libqtelegram.files += ../../build-LibQTelegram-turbo_GCC_armhf_ubuntu_sdk_15_04_device_armhf-Debug/libQTelegram.so \
                      ../../build-LibQTelegram-turbo_GCC_armhf_ubuntu_sdk_15_04_device_armhf-Debug/libQTelegram.so.1
INSTALLS+=libqtelegram

pubkey.path = /
pubkey.files += public.key
INSTALLS+=pubkey

#gstplugin.path = $${UBUNTU_CLICK_BINARY_PATH}/../mediaservice/
#gstplugin.files = /usr/lib/arm-linux-gnueabihf/qt5/plugins/mediaservice/libgstmediaplayer.so
INSTALLS += gstplugin

#install the desktop file, a translated version is 
#automatically created in the build directory
desktop_file.path = /QtGram-ubuntu
desktop_file.files = $$OUT_PWD/QtGram-ubuntu.desktop
desktop_file.CONFIG += no_check_exist
INSTALLS+=desktop_file

# Default rules for deployment.
target.path = $${UBUNTU_CLICK_BINARY_PATH}
INSTALLS+=target
