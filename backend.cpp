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

QJsonObject Backend::loadJson()
{
    QFile file;
    file.setFileName(":/qt6-tree.json");
    file.open(QIODevice::ReadOnly | QIODevice::Text);
    QByteArray content{file.readAll()};
    file.close();
    return QJsonDocument::fromJson(content).object();
}
