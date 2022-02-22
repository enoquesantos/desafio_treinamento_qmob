#include "httprequest.h"

HttpRequestReply::HttpRequestReply(QNetworkReply *reply)
    : QObject{reply}
{
    connect(reply, &QNetworkReply::finished, this, [=]() {
        if (reply->error()) {
            const QString &errorMessage{reply->errorString()};

            int status{0};
            QVariant statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);
            if (statusCode.isValid()) {
                status = statusCode.toInt();
            }

            Q_EMIT onFailed(status, errorMessage);
        } else {
            const QString &response{reply->readAll()};
            Q_EMIT onFinished(response);
        }

        reply->deleteLater();
    });

    connect(reply, &QNetworkReply::errorOccurred, this, [=](QNetworkReply::NetworkError code) {
        int status{reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt()};
        const QString &errorMessage{reply->errorString()};
        Q_EMIT onFailed(status, errorMessage);
        reply->deleteLater();
    });
}

HttpRequest::HttpRequest(QObject *parent)
    : QObject{parent}
{}

HttpRequestReply *HttpRequest::get(const QString &url)
{
    QNetworkRequest req{QUrl(url)};
    return new HttpRequestReply{qnam.get(req)};
}
