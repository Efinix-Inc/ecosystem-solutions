#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QList>
#include <QLineEdit>
#include <QtConcurrent/QtConcurrent>
#include <QPainter>
QT_BEGIN_NAMESPACE
namespace Ui {
class MainWindow;
}
QT_END_NAMESPACE

class VideoRender : public QWidget {
    Q_OBJECT
public:
    VideoRender(QWidget *parent = nullptr) : QWidget(parent) {
        setParent(parent);
        connect(this, SIGNAL(m_update()), this, SLOT(update()));
        vw = vh = 0;
        scale = 1.0f;
    }
    void paintEvent(QPaintEvent *event) {
        (void)event;
        QPainter p(this);
        p.drawImage(0, 0, pix);
    }
    const QSize calc_size(QSize size) {
        QSize rsize;
        rsize.setWidth(size.width());
        float aspect = vw;
        aspect = aspect/vh;
        float rh = size.width() / aspect;
        rsize.setHeight((int)rh);
        return rsize;
    }
signals:
    void m_update();
public:
    QImage pix;
    int vw, vh;
    float scale;
};

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();
    template<typename T>
    void run(const T func) {
            (void)QtConcurrent::run(func);
    }

signals:
    void log_print(QString);
    void log_clear();
    void proc_run(QString, QStringList);
    void got_frame();
    void need_resize();

signals:
    void rx_display(double);
    void tx_display(double);
    void pb_set_range(int, int);
    void pb_set_value(int);
protected:
    bool eventFilter(QObject *watched, QEvent *event) override;
private:
    Ui::MainWindow *ui;
    int ufd, cfd;
    int start;
    QList<QLineEdit*> regs, xg_regs;
};

#endif // MAINWINDOW_H
