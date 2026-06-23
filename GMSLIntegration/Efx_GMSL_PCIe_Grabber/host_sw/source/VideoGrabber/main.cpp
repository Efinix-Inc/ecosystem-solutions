#include "mainwindow.h"

#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QFont font("Monospace");
    font.setStyleHint(QFont::TypeWriter);
    MainWindow w;
    //w.setFont(font);
    w.show();
    return a.exec();
}
