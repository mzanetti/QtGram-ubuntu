#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QString>

#include <autogenerated/telegramqml.h>

#include "qtgram.h"

int main(int argc, char *argv[])
{
//    setenv("QT_DEBUG_PLUGINS", "1", 1);
    QCoreApplication::addLibraryPath("/opt/click.ubuntu.com/qtgram-ubuntu.mzanetti/0.1/lib/arm-linux-gnueabihf/");
    QGuiApplication app(argc, argv);

    QString uri = "LibQTelegram";
    TelegramQml::initialize("LibQTelegram");

    qDebug() << "****** loading plugins from" << QCoreApplication::libraryPaths();

    qmlRegisterType<QtGram>("QtGram", 1, 0, "QtGram");

    QQuickView view;
    view.setSource(QUrl(QStringLiteral("qrc:///Main.qml")));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.show();
    return app.exec();
}