#include "backend.h"

#include <QDebug>
#include <QFile>
#include <QJsonDocument>

Backend::Backend(QObject *parent)
    : QObject{parent}
    , m_httpRequest{new HttpRequest(this)}
{
}

void Backend::log(const QString &message)
{
    qDebug() << message;
}

QJsonArray Backend::loadJson()
{
    QFile file;
    file.setFileName(":/qtbase-directory-tree.json");
    file.open(QIODevice::ReadOnly | QIODevice::Text);
    QByteArray content{file.readAll()};
    file.close();
    QJsonArray array{QJsonDocument::fromJson(content).object()};
    return array;
}
