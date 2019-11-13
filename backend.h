#ifndef BACKEND_H
#define BACKEND_H

#include <stdint.h>
#include <QObject>
#include <QString>
#include <pthread.h>

class BackEnd : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString modbusStatus READ modbusStatusGet NOTIFY modbusStatusChanged)


public:
    explicit BackEnd(QObject *parent = nullptr);
    QString modbusStatusGet();
    void * runRs485Loop(void *);
    uint16_t regs[16];

signals:
    void modbusStatusChanged();



private:
    pthread_t hwdiag_rs485_thread;
    int modbus_status_ok;
    int _runModbusTest();

};

#endif // BACKEND_H
