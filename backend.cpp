#include <iostream>
#include <pthread.h>
#include <unistd.h>
#include <modbus/modbus.h>
#include <errno.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <termios.h>

#include "backend.h"
#include <QDebug>

typedef void * (*THREADFUNCPTR)(void *);

BackEnd::BackEnd(QObject *parent) : QObject(parent)
{
    int err;
    err = pthread_create(&hwdiag_rs485_thread, NULL, (THREADFUNCPTR) &BackEnd::runRs485Loop, this);
    if (err) {
        std::cout << "RS485 Thread creation failed : " << strerror(err);
    }

    modbus_status_ok = 0;
}

int BackEnd::_runModbusTest(void)
{
    modbus_t *ctx;
    int ret, i;

    /* Modbus UART uses ttymxc4 */
    ctx = modbus_new_rtu("/dev/ttymxc4", 19200, 'N', 8, 1);
    if (ctx == nullptr) {
        qWarning("Unable to create the libmodbus context\n");
        if (modbus_status_ok == 1) {
            emit modbusStatusChanged();
            modbus_status_ok = 0;
        }
        return -1;
    }

    modbus_set_slave(ctx, 1);
    modbus_rtu_set_serial_mode(ctx, MODBUS_RTU_RS485);
    modbus_rtu_set_rts(ctx, MODBUS_RTU_RTS_UP);
    modbus_set_response_timeout(ctx, 0, 200000);

    if (modbus_connect(ctx) == -1) {
        qWarning("Unable to connect to modbus slave\n");
        if (modbus_status_ok == 1) {
            modbus_status_ok = 0;
            emit modbusStatusChanged();
        }
        goto error;
    }


    /* Try 10 times */
    for (i = 0; i < 10; i++) {
        ret = modbus_read_registers(ctx, 0, 16, regs);
        if (ret == 32)
            break;
    }

    for (i = 0; i < 16; i++) {
        qDebug() << "Modbus address" << i << ": " << regs[i];
    }

    if (ret == -1)
        qWarning("Read Modbus registers returned %d : %s\n", ret, modbus_strerror(errno));

    modbus_flush(ctx);
    modbus_close(ctx);

    if (ret == -1 && modbus_status_ok == 1) {
        modbus_status_ok = 0;
        emit modbusStatusChanged();
    } else if (ret > 0 && modbus_status_ok == 0) {
        modbus_status_ok = 1;
        emit modbusStatusChanged();
    }

error:
    modbus_free(ctx);
    return 0;
}


QString BackEnd::modbusStatusGet()
{
    if (modbus_status_ok) {
        return "OK";
    } else {
        return "FAILURE";
    }
}


    /* Thread for Modbus since it runs much slower than the rest */
    void * BackEnd::runRs485Loop(void *)
    {
        while(1) {
            _runModbusTest();
            sleep(1);
        }
    }
