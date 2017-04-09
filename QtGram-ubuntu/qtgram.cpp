#include "qtgram.h"
#include <QGuiApplication>

QtGram::QtGram(QObject *parent) : QObject(parent)
{

}

QString QtGram::publicKey() const
{
    return qApp->applicationDirPath() + "/../../../public.key";
}

QString QtGram::emojiPath() const
{

    return "file://" + qApp->applicationDirPath() + "/emoji/";
}
