#ifndef HTTPREQUEST_H
#define HTTPREQUEST_H

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QObject>
#include <QtQml>

class HttpRequestReply : public QObject
{
    Q_OBJECT
public:
    explicit HttpRequestReply(QNetworkReply *reply);

signals:
    void onFinished(const QString &response);
    void onFailed(int statusCode, const QString &errorMessage);
};

class HttpRequest : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit HttpRequest(QObject *parent = nullptr);

    Q_INVOKABLE HttpRequestReply *get(const QString &url);

signals:

private:
    QNetworkAccessManager qnam;
};

#endif // HTTPREQUEST_H
