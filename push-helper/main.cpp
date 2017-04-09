#include <QCoreApplication>
#include <QFile>
#include <QStandardPaths>
#include <QDebug>

int main(int argc, char* argv[])
{
    qDebug() << "Starting reminders app push helper aa";
    QCoreApplication a(argc, argv);
    QCoreApplication::setApplicationName("qtgram-ubuntu.mzanetti");
    qDebug() << "bb";

    QFile inputFile(a.arguments().at(1));
    inputFile.open(QFile::ReadOnly);

    qDebug() << "cc";

    QByteArray data = inputFile.readAll();

    qDebug() << "dd" << data;

//    a.exec();

    qDebug() << "exiting...";
    // Do we want to fire a notification? Here's the place, by writing to the file at args[2]
}
