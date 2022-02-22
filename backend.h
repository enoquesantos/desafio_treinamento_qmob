#ifndef BACKEND_H
#define BACKEND_H

#include "httprequest.h"

#include <QJsonObject>
#include <QObject>
#include <QtQml>

class Backend : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(HttpRequest *http MEMBER m_httpRequest NOTIFY httpChanged)
public:
    explicit Backend(QObject *parent = nullptr);

    Q_INVOKABLE void log(const QString &message);
    Q_INVOKABLE QJsonObject loadJson();

signals:
    void httpChanged(const HttpRequest *http);

private:
    HttpRequest *m_httpRequest;
};

#endif // BACKEND_H
