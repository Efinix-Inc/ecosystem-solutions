#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QDebug>
#include <QThread>
#include <QPushButton>
#include <QLineEdit>
#include <QSocketNotifier>
#include <QTimer>
#include <QCheckBox>
#include <QComboBox>
#include <QFile>
#include <QProcess>
#include <QFileDialog>

#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <QCryptographicHash>
#include <QCamera>
#include <QMediaCaptureSession>
//#include <QCameraViewfinder>
//#include <QVideoProbe>
#include <QtMultimedia/QVideoSink>
#include <QColorSpace>
//#include <QCameraViewfinderSettings>
#include <QGraphicsView>
#include <QGraphicsVideoItem>
#include <QGraphicsItem>
#include <mutex>
#include <deque>
#include <QLayoutItem>
#include <QProgressBar>
#include <QImageCapture>
#include <QVideoSink>
#include <boost/lockfree/queue.hpp>
#include <atomic>
extern "C" {
#include <libavformat/avformat.h>
#include <libavcodec/avcodec.h>
#include <libavdevice/avdevice.h>
#include <libavutil/avutil.h>
#include <libavutil/imgutils.h>
#include <libswscale/swscale.h>
}
std::mutex desc_mtx;
std::atomic<bool> got_one_frame;

typedef enum {
    RANDOM = 0,
    FDATA = 1
} PKT_TYPE_T;

typedef struct {
    uint16_t magic;
    uint16_t cid;
    uint16_t pkt_type;
    uint32_t block_size;
    uint64_t total_size;
    uint32_t pad_size;
    uint16_t nsize;
    uint8_t name[224];
} pkt_hdr_t;

typedef uint64_t check_t;
#define CHECK_MAX 0xffffffffffffffff

#define STOP_10GE_AXIS

#define STOP_10GE_AXIS_RX

/*
#define V_HEIGHT 480
#define V_WIDTH 640
#define BPP 4
#define FRAME_BLOCK_SIZE (V_WIDTH * V_HEIGHT * BPP)
#define FRAME_BASE (0UL)
#define FRAME_SIZE (0x80000000UL / FRAME_BLOCK_SIZE * FRAME_BLOCK_SIZE)
*/


#define MEM_BLOCK_SIZE (2 * 1024 * 1024ULL)
#define RW_MAX_SIZE    (2*1024*1024*1024LL)
#define USER_BAR_SIZE  (8192)

#define MEM_BASE       (0x80000000ULL)
#define MEM_SIZE       (0x80000000ULL)
//#define MEM_SIZE       (0x10000000ULL)

#define MEM_HIGH       (MEM_BASE + MEM_SIZE)

#define CMEM_BASE      (0x00000000ULL)
#define CMEM_SIZE      (0x80000000ULL)
//#define CMEM_SIZE      (0x10000000ULL)
#define CMEM_HIGH      (CMEM_BASE + CMEM_SIZE)


#define CMEM_LAST      (CMEM_HIGH - MEM_BLOCK_SIZE)

#define PAGE_SIZE      (4096)

#define YOLO_BOX_SIZE             16*8
#define YOLO_BOX_OBJECTNESS_SIZE  16*8*2 +64

#define BBOX_MAX            16
#define TOTAL_BOX_SIZE				(BBOX_MAX * 8)
#define DUMMY_BYTE_SIZE				(64 - 8)
#define TOTAL_BOX_BUFFER_SIZE		(8 + TOTAL_BOX_SIZE + DUMMY_BYTE_SIZE)

#define master_control_status_A  0xD1
#define master_control_input_A   0xD2

#define master_control_status_B  0xD3
#define master_control_input_B   0xD4

#define master_control_status_C  0xD5
#define master_control_input_C   0xD6


volatile uint32_t *uaddr, *caddr;
int ufd, cfd;
int h2c_fd, c2h_fd;
volatile bool quit = false;
volatile bool send_no_stop = false;
volatile bool send_once = false;

volatile bool file_recv = false;

volatile bool dev_switching = false;
volatile bool video_play = false;
volatile bool video_play_start =false;

QString current_pcie;

volatile uint32_t last_out_frame_index = 0;
volatile uint32_t out_frame_index = 0;

volatile uint32_t last_in_frame_index = 0;
volatile uint32_t in_frame_index = 0;

volatile uint8_t yolobox [YOLO_BOX_SIZE];
volatile uint8_t yolobox_objectness [YOLO_BOX_OBJECTNESS_SIZE];


boost::lockfree::queue<char*> *s_frames;
boost::lockfree::queue<char*> *r_frames;

int s_frame_count;
char *old_s_frame[4];
char *vc_frame[4];

uint8_t s_frame_flg[4];

static uint64_t frame_block_offset = 0x40;


static uint64_t frame_block_size = 1920*1080*4 + frame_block_offset;//640*480*4 ;

static uint64_t read_frame_block_size = 1920*1080*4 + frame_block_offset;//640*480*4 ;


static uint64_t cframe_base =  0x800000UL + 0x8ul;
static uint64_t cframe_size = (0x2000000UL / frame_block_size * frame_block_size);
static uint64_t cframe_high = cframe_base + cframe_size;
static uint64_t frame_base   = 0x800000UL + 0x8ul;
static uint64_t frame_size = ( 0x2000000UL / frame_block_size * frame_block_size);
static uint64_t frame_high = frame_base + frame_size;

static uint64_t yolo_box_base = 0x02800000UL;
static uint64_t yolo_box_size = YOLO_BOX_SIZE;

static uint64_t yolo_box_objectness_base = yolo_box_base + TOTAL_BOX_BUFFER_SIZE;
static uint64_t yolo_box_objectness_size = YOLO_BOX_OBJECTNESS_SIZE;

uint32_t last_FrameInputIndex = 0;

void set_frame_size(int w, int h, int bpp) {
    frame_block_size = w * h * bpp +  frame_block_offset;
    cframe_base =  0x800000UL + 0x8ul;
    cframe_size = (0x2000000UL / frame_block_size * frame_block_size);
    cframe_high = cframe_base + cframe_size;

    frame_base =  0x800000UL + 0x8ul;
    frame_size = (0x2000000UL / frame_block_size * frame_block_size);
    frame_high = frame_base + frame_size;
}


int frameInProcess[4];
int frameProcess_ptr;

int TotalFrameCount;
int FrameCount[4];


int CurrentTotalFrameCount;
int CurrentFrameCount[4];

static unsigned char brightness_lut[256];

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    start = 0;
    uaddr = 0;
    caddr = 0;
    ufd = -1;
    cfd = -1;
    h2c_fd = c2h_fd = -1;

    s_frames = new boost::lockfree::queue<char*>(128);
    r_frames = new boost::lockfree::queue<char*>(128);

    s_frame_count=0;
    old_s_frame[0] = new char[frame_block_size];
    old_s_frame[1] = new char[frame_block_size];
    old_s_frame[2] = new char[frame_block_size];
    old_s_frame[3] = new char[frame_block_size];

    vc_frame[0] =  new char[frame_block_size];
    vc_frame[1] =  new char[frame_block_size];
    vc_frame[2] =  new char[frame_block_size];
    vc_frame[3] =  new char[frame_block_size];


    s_frame_flg [0] =0;
    s_frame_flg [1] =0;
    s_frame_flg [2] =0;
    s_frame_flg [3] =0;
    video_play_start = false;

    ui->log_window->setFontFamily("Monospace");

    connect(this, &MainWindow::proc_run, [=](QString cmd, QStringList args) {
        qDebug() << "got this signal" << cmd << args;
        QProcess *fork_proc = new QProcess(this);

        connect(fork_proc, &QProcess::readyReadStandardOutput, [=](){
            QString output =fork_proc->readAllStandardOutput();
            qDebug() << "done" << output;
            this->log_print(output);
            fork_proc->deleteLater();
        });
        fork_proc->start(cmd, args, QProcess::ReadWrite);
        fork_proc->waitForFinished();
    });

    ui->log_window->clear();
    auto read_to_buffer = [=](int fd, char *buffer, uint64_t size,
                              uint64_t base) -> uint64_t
    {
        ssize_t rc;
        uint64_t count = 0;
        char *buf = buffer;
        off_t offset = base;
        int loop = 0;

        while (count < size) {
            uint64_t bytes = size - count;

            //if (offset)
            {
                desc_mtx.lock();
                rc = lseek(fd, offset, SEEK_SET);
                desc_mtx.unlock();
                if (rc != offset) {
                    qDebug() << "read from offset" << QString::asprintf("%lx/%lx, %s", rc, offset, strerror(errno));
                    return -EIO;
                } else {
                    //qDebug() << QString::asprintf("read from buffer lseek: %lx", offset);
                }
            }

            /* read data from file into memory buffer */
            desc_mtx.lock();
            rc = read(fd, buf, bytes);
            desc_mtx.unlock();
            if (rc < 0) {
                return -EIO;
            }

            count += rc;
            if (rc != (ssize_t)bytes) {
                emit this->log_print(QString::asprintf("read underflow 0x%lx/0x%lx @ 0x%lx.\n",
                                                       rc, bytes, offset));
                break;
            }

            buf += bytes;
            offset += bytes;
            loop++;
        }

        if (count != size && loop)
            emit this->log_print(QString::asprintf("read underflow 0x%lx/0x%lx.\n",
                                                   count, size));
       // emit this->log_print(QString::asprintf("Read Buffer 0x%lx/0x%lx @ 0x%lx.\n",
       //                                        count, size,base));
        return count;
    };


    auto write_from_buffer = [=](int fd, char *buffer, uint64_t size,
                                 uint64_t base) -> uint64_t
    {
        ssize_t rc;
        uint64_t count = 0;
        char *buf = buffer;
        off_t offset = base;
        int loop = 0;
        //qDebug() << "need write data" << base << size;

        uint32_t rd_ctl = uaddr[0xa0];
        while(rd_ctl & 0x2) {
            usleep(1000);
            rd_ctl = uaddr[0xa0];
        }
        //qDebug() << "fire!!!";

        while (count < size) {
            uint64_t bytes = size - count;
            //if (offset)
            {
                desc_mtx.lock();
                rc = lseek(fd, offset, SEEK_SET);
                desc_mtx.unlock();
                if (rc != offset) {
                    emit this->log_print(QString::asprintf("w %d seek off 0x%lx != 0x%lx. %s",
                                                           fd, rc, offset, strerror(errno)));
                    return -EIO;
                }
            }
            desc_mtx.lock();
            rc = write(fd, buf, bytes);
            desc_mtx.unlock();
            if (rc < 0) {
                emit this->log_print(QString::asprintf("write 0x%lx @ 0x%lx failed %ld.\n",
                                                       bytes, offset, rc));
                perror("write file");
                return -EIO;
            }

            count += rc;
            if (rc != (ssize_t)bytes) {
                emit this->log_print(QString::asprintf("write underflow 0x%lx/0x%lx @ 0x%lx.\n",
                                                       rc, bytes, offset));
                //break;
            }
            buf += bytes;
            offset += bytes;
            loop++;
        }

#ifndef STOP_10GE_AXIS
        uaddr[0xa1] = base >> 32;
        //uaddr[0xa1] = base >> 32;

        uaddr[0xa2] = base & 0xffffffff;
        //uaddr[0xa2] = base & 0xffffffff;

        uaddr[0xa3] = size & 0xffffffff;
        //uaddr[0xa3] = size & 0xffffffff;

        //qDebug() << QString::asprintf("write rd: %x, read: %x", size & 0xffffffff, uaddr[0xa3]);

        uaddr[0xa0] = 9;
//uaddr[0xa0] = 9;
#endif


        if (count != size && loop)
            emit this->log_print(QString::asprintf("write underflow 0x%lx/0x%lx.\n",
                                                   count, size));
        return count;
    };

    connect(this, &MainWindow::log_print, [&](QString msg) {
        ui->log_window->append(msg);
    });

    connect(this, &MainWindow::log_clear, [&](){
        ui->log_window->clear();
    });

    auto pcie_dma_initial = [=]() {
        dev_switching = true;
        if(ufd > 0) {
            ::close(ufd);
            ufd = -1;
        }

        if(uaddr != MAP_FAILED) {
            munmap((void *)uaddr, USER_BAR_SIZE);
            uaddr = NULL;
        }

        int nufd = open("/dev/pcie_dma0_user", O_RDWR|O_SYNC);
        h2c_fd = open("/dev/pcie_dma0_h2d_0", O_RDWR);
        c2h_fd = open("/dev/pcie_dma0_d2h_0", O_RDWR);

        ui->log_window->clear();
        if(nufd < 0) {
            ui->log_window->append(QString::asprintf("open pcie_dma_user failed: %s", strerror(errno)));
            return;
        }
        volatile uint32_t *naddr = (uint32_t *)mmap(0, USER_BAR_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, nufd, 0);
        if(naddr == MAP_FAILED) {
            ui->log_window->append(QString::asprintf("map pcie_dma_user failed: %s", strerror(errno)));
            ::close(nufd);
            nufd = -1;
            return;
        }
        ui->log_window->append("open pcie_dma_user successed! BAR_SIZE: " + QString::asprintf("%X", USER_BAR_SIZE));
        ui->log_window->append("FRAME BASE: " + QString::asprintf("%llX", frame_base) + " FRAME SIZE: " + QString::asprintf("%llX", frame_size) + "FRAME HIGH: " + QString::asprintf("%llX", frame_high));
        ui->log_window->append("CFRAME BASE: " + QString::asprintf("%llX", cframe_base) + " CFRAME SIZE: " + QString::asprintf("%llX", cframe_size) + " CFRAME HIGH: " + QString::asprintf("%llX", cframe_high));

        ui->log_window->append("Frame Block Size: " + QString::asprintf("%llX", frame_block_size) );



        ufd = nufd;
        uaddr = naddr;
        //reset rd module

        uint64_t boardID = uaddr[0xd0];
        ui->log_window->append("Block Status :0x" + QString::asprintf("%llX", boardID) );
        uint64_t master_status = uaddr[0xd1];
        ui->log_window->append("master_status: " + QString::asprintf("%llX", master_status) );


        uaddr[0xa0] = 0x0;
        uaddr[0xa0] = 0x8;

        //xgmii packet max length
        uaddr[0x405] = 0x2000;


        //reset xgmii module
        uaddr[0x402] = 0x80000000;
        uaddr[0x402] = 0x40003;

        dev_switching = false;
    };
    pcie_dma_initial();

    connect(this, &MainWindow::rx_display, [=](double v) {
        ui->rx_lcd->setText(QString::asprintf("%.2f", v));
    });
    connect(this, &MainWindow::tx_display, [=](double v) {
        ui->tx_lcd->setText(QString::asprintf("%.2f", v));
    });

    connect(this, &MainWindow::rx_display, [=](double v) {
        ui->vc0_lcd->setText(QString::asprintf("%.2f", v));
    });

    connect(this, &MainWindow::rx_display, [=](double v) {
        ui->vc1_lcd->setText(QString::asprintf("%.2f", v));
    });

    connect(this, &MainWindow::rx_display, [=](double v) {
        ui->vc2_lcd->setText(QString::asprintf("%.2f", v));
    });

    connect(this, &MainWindow::rx_display, [=](double v) {
        ui->vc3_lcd->setText(QString::asprintf("%.2f", v));
    });

    auto vc0 = new VideoRender();
    vc0->setMaximumSize(16777215, 16777215);
    vc0->setSizePolicy(QSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding));

    auto vc1 = new VideoRender();
    vc1->setMaximumSize(16777215, 16777215);
    vc1->setSizePolicy(QSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding));

    auto vc2 = new VideoRender();
    vc2->setMaximumSize(16777215, 16777215);
    vc2->setSizePolicy(QSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding));

    auto vc3 = new VideoRender();
    vc3->setMaximumSize(16777215, 16777215);
    vc3->setSizePolicy(QSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding));



    auto send_frames = [=]() {



        qDebug() << ("write frame thread begin...");

        struct timespec st, ed;

        float bsize = 0;

        out_frame_index = 0;

        in_frame_index = 0;



        s_frame_count=0;
        for(uint64_t base = frame_base; video_play; ) {
            if(quit)
                break;



            if(!s_frames->empty() )
            {
            //    s_frames->pop(old_s_frame[out_frame_index]);
            //    s_frame_flg[out_frame_index]=1;

                char* framePtr;
                if (s_frames->pop(framePtr)) {
                    memcpy(old_s_frame[out_frame_index], framePtr, frame_block_size);
                    free(framePtr); // ✅ Release memory
                }


            }
            else
            {
                last_out_frame_index;

                memcpy(old_s_frame[out_frame_index], old_s_frame[last_out_frame_index] , frame_block_size);

                s_frame_flg[out_frame_index]=1;
            }

            last_out_frame_index = out_frame_index;
            out_frame_index ++;
            if (out_frame_index>=4)
                out_frame_index = 0;




        }



        qDebug() << ("send frame thread stoped...");
    };

    auto tune_frames = [=]() {
        qDebug() << ("tune Frame colour thread begin...");
        while(!quit) {
            if(ufd <0 || uaddr == MAP_FAILED) {
                usleep(1000);
                continue;
            } else {
                break;
            }
        }


        while(video_play && !quit) {

           // continue;

            if (frameInProcess[frameProcess_ptr] ==1)
            {
                if(frameProcess_ptr==0)
                {
                    memcpy(vc0->pix.bits(), vc_frame[0], frame_block_size - frame_block_offset);
                    vc0->update();

                }


                if(frameProcess_ptr==1)
                {
                    memcpy(vc1->pix.bits(),  vc_frame[1], frame_block_size - frame_block_offset);
                    vc1->update();

                }


                if(frameProcess_ptr==2)
                {
                    memcpy(vc2->pix.bits(),  vc_frame[2], frame_block_size - frame_block_offset);
                    vc2->update();
                }



                if(frameProcess_ptr==3)
                {
                    memcpy(vc3->pix.bits(),  vc_frame[3], frame_block_size - frame_block_offset);
                    vc3->update();
                }

                frameInProcess[frameProcess_ptr] = 0;
            }

            if(frameProcess_ptr>=3)
                frameProcess_ptr =0;
            else
                frameProcess_ptr++;

        }

        qDebug() << ("rtune Frame colour thread stoped...");
    };

    auto read_frames = [=]() {
        qDebug() << ("read frame thread begin...");
        while(!quit) {
            if(ufd <0 || uaddr == MAP_FAILED) {
                usleep(1000);
                continue;
            } else {
                break;
            }
        }

        while(video_play && !quit) {


            uint64_t FrameInputIndex = uaddr[master_control_status_A];

            if(last_FrameInputIndex != FrameInputIndex)
            {


                last_FrameInputIndex = FrameInputIndex;
                uint64_t FrameInputChannel = uaddr[master_control_status_B];
                //usleep(1000*1000);
                if(FrameInputChannel<4)
                {
                    while(frameInProcess[FrameInputChannel]==1)
                    {

                    }

                     TotalFrameCount ++;
                    FrameCount[FrameInputChannel] ++;

                    read_to_buffer(c2h_fd, (char *)vc_frame[FrameInputChannel], frame_block_size - frame_block_offset, frame_base +frame_block_size*FrameInputChannel);
                     frameInProcess[FrameInputChannel]=1;
                }

            }


/*
            if(last_FrameInputIndex != FrameInputIndex)
            {
                TotalFrameCount ++;

                last_FrameInputIndex = FrameInputIndex;
                uint64_t FrameInputChannel = uaddr[master_control_status_B];
                //usleep(1000*1000);

                if(FrameInputChannel==0)
                {
                     read_to_buffer(c2h_fd, (char *)vc_frame[0], frame_block_size - frame_block_offset, frame_base +frame_block_size*0);

                    memcpy(vc0->pix.bits(), vc_frame[0], frame_block_size - frame_block_offset);
                    vc0->update();
                }


                if(FrameInputChannel==1)
                {


                    read_to_buffer(c2h_fd, (char *)vc_frame[1], frame_block_size - frame_block_offset, frame_base +frame_block_size*1);
                    memcpy(vc1->pix.bits(),  vc_frame[1], frame_block_size - frame_block_offset);
                   vc1->update();
                }


                if(FrameInputChannel==2)
                {
                    read_to_buffer(c2h_fd, (char *)vc_frame[2], frame_block_size - frame_block_offset, frame_base +frame_block_size*2);
                    memcpy(vc2->pix.bits(),  vc_frame[2], frame_block_size - frame_block_offset);
                    vc2->update();
                }



                if(FrameInputChannel==3)
                {
                    read_to_buffer(c2h_fd, (char *)vc_frame[3], frame_block_size - frame_block_offset, frame_base +frame_block_size*3);
                    memcpy(vc3->pix.bits(),  vc_frame[3], frame_block_size - frame_block_offset);
                    vc3->update();
                }

            }

*/


        }
     //   free(mrbuf);
        qDebug() << ("read frame thread stoped...");
    };


    ui->gv_vc0->setScene(new QGraphicsScene(this));
    ui->gv_vc0->scene()->addWidget(vc0);


    //mc->setVideoOutput(svi);
    //mc->setCamera(camera);

    //ui->vc1->addWidget(vc1);
    ui->gv_vc1->setScene(new QGraphicsScene(this));
    ui->gv_vc1->scene()->addWidget(vc1);

    ui->gv_vc2->setScene(new QGraphicsScene(this));
    ui->gv_vc2->scene()->addWidget(vc2);

    ui->gv_vc3->setScene(new QGraphicsScene(this));
    ui->gv_vc3->scene()->addWidget(vc3);


  //  ui->gv_vc0->installEventFilter(this);


    auto get_video = [=]() -> int {
        const char *input_filename = "/dev/video0";
        AVFormatContext *fmt_ctx = NULL;
        AVDictionary *options = NULL;
        int ret;
        qDebug() << "hello frame";
        // Initialize FFmpeg library
        avdevice_register_all();

        // Set input options
        av_dict_set(&options, "framerate", "30", 0);
        //av_dict_set(&options, "video_size", "3840x2160", 0);
        av_dict_set(&options, "video_size", "1920x1080", 0);
        av_dict_set(&options, "input_format", "mjpeg", 0); // Specify MJPEG format

        // Find the video input format
        const AVInputFormat *iformat = av_find_input_format("video4linux2");
        if (!iformat) {
            fprintf(stderr, "Could not find input format 'video4linux2'\n");
            return -1;
        }

        // Open the input device
        if ((ret = avformat_open_input(&fmt_ctx, input_filename, iformat, &options)) < 0) {
            fprintf(stderr, "Could not open input device '%s'\n", input_filename);
            return -1;
        }

        // Retrieve stream information
        if ((ret = avformat_find_stream_info(fmt_ctx, NULL)) < 0) {
            fprintf(stderr, "Could not find stream information\n");
            avformat_close_input(&fmt_ctx);
            return -1;
        }

        // Find the first video stream
        int video_stream_index = -1;
        for (unsigned int i = 0; i < fmt_ctx->nb_streams; i++) {
            AVStream *stream = fmt_ctx->streams[i];
            if (stream->codecpar->codec_type == AVMEDIA_TYPE_VIDEO) {
                video_stream_index = i;
                break;
            }
        }
        if (video_stream_index == -1) {
            fprintf(stderr, "Could not find a video stream in the input device\n");
            avformat_close_input(&fmt_ctx);
            return -1;
        }

        // Get the codec parameters for the video stream
        AVCodecParameters *codecpar = fmt_ctx->streams[video_stream_index]->codecpar;

        // Find the decoder for the video stream
        AVCodec *codec = const_cast<AVCodec *>(avcodec_find_decoder(codecpar->codec_id));
        if (!codec) {
            fprintf(stderr, "Unsupported codec!\n");
            avformat_close_input(&fmt_ctx);
            return -1;
        }

        // Allocate a codec context for the decoder
        AVCodecContext *codec_ctx = avcodec_alloc_context3(codec);
        if (!codec_ctx) {
            fprintf(stderr, "Could not allocate video codec context\n");
            avformat_close_input(&fmt_ctx);
            return -1;
        }

        // Copy codec parameters to codec context
        if ((ret = avcodec_parameters_to_context(codec_ctx, codecpar)) < 0) {
            fprintf(stderr, "Failed to copy codec parameters to codec context\n");
            avcodec_free_context(&codec_ctx);
            avformat_close_input(&fmt_ctx);
            return -1;
        }

        // Open the codec
        if ((ret = avcodec_open2(codec_ctx, codec, NULL)) < 0) {
            fprintf(stderr, "Could not open codec\n");
            avcodec_free_context(&codec_ctx);
            avformat_close_input(&fmt_ctx);
            return -1;
        }

        // Allocate packet and frame
        AVPacket *packet = av_packet_alloc();
        AVFrame *frame = av_frame_alloc();
        if (!packet || !frame) {
            fprintf(stderr, "Could not allocate packet or frame\n");
            avcodec_free_context(&codec_ctx);
            avformat_close_input(&fmt_ctx);
            return -1;
        }

        printf("Start reading frames...\n");
        // Read frames from the device
        auto dst_pix_fmt = AV_PIX_FMT_RGBA;
        AVFrame *rgb_frame = av_frame_alloc();
        auto sws_ctx = sws_getContext(
            codec_ctx->width,
            codec_ctx->height,
            codec_ctx->pix_fmt,
            codec_ctx->width,
            codec_ctx->height,
            dst_pix_fmt,
            SWS_FAST_BILINEAR,
            0,
            0,
            0
            );
        av_image_alloc(rgb_frame->data, rgb_frame->linesize, codec_ctx->width, codec_ctx->height, AV_PIX_FMT_ARGB, 1);
        {

            if(video_play_start==false)
            {
                vc0->pix = QImage(codec_ctx->width, codec_ctx->height, QImage::Format_RGB32);
                vc1->pix = QImage(codec_ctx->width, codec_ctx->height, QImage::Format_RGB32);
                vc2->pix = QImage(codec_ctx->width, codec_ctx->height, QImage::Format_RGB32);
                vc3->pix = QImage(codec_ctx->width, codec_ctx->height, QImage::Format_RGB32);

                video_play_start= true;
            }


            vc0->vw = codec_ctx->width;
            vc0->vh = codec_ctx->height;

            vc1->vw = codec_ctx->width;
            vc1->vh = codec_ctx->height;


            vc2->vw = codec_ctx->width;
            vc2->vh = codec_ctx->height;

            vc3->vw = codec_ctx->width;
            vc3->vh = codec_ctx->height;


            vc0->resize(QSize(vc1->vw, vc1->vh));
            vc1->resize(QSize(vc1->vw, vc1->vh));
            vc2->resize(QSize(vc1->vw, vc1->vh));
            vc3->resize(QSize(vc1->vw, vc1->vh));

            ui->gv_vc0->resetTransform();
            ui->gv_vc1->resetTransform();
            ui->gv_vc2->resetTransform();
            ui->gv_vc3->resetTransform();

            float sc = ui->gv_vc1->width();
            sc = sc / vc1->vw;
            ui->gv_vc0->scale(sc, sc);
            ui->gv_vc1->scale(sc, sc);
            ui->gv_vc2->scale(sc, sc);
            ui->gv_vc3->scale(sc, sc);

            vc1->scale = sc;
            set_frame_size(codec_ctx->width, codec_ctx->height, 4);

            ui->log_window->append("codec_ctx->width: " + QString::asprintf("%llX", codec_ctx->width) + " codec_ctx->height: " + QString::asprintf("%llX", codec_ctx->height) );

            ui->log_window->append("FRAME BASE: " + QString::asprintf("%llX", frame_base) + " FRAME SIZE: " + QString::asprintf("%llX", frame_size) + " FRAME HIGH: " + QString::asprintf("%llX", frame_high));
            ui->log_window->append("CFRAME BASE: " + QString::asprintf("%llX", cframe_base) + " CFRAME SIZE: " + QString::asprintf("%llX", cframe_size) + " CFRAME HIGH: " + QString::asprintf("%llX", cframe_high));
            ui->log_window->append("Frame Block Size: " + QString::asprintf("%llX", frame_block_size) );
        }
        while (av_read_frame(fmt_ctx, packet) >= 0 && !quit && video_play) {
            // Check if the packet belongs to the video stream
            if (packet->stream_index == video_stream_index) {
                // Send the packet to the decoder
                ret = avcodec_send_packet(codec_ctx, packet);
                if (ret < 0) {
                    fprintf(stderr, "Error sending a packet for decoding\n");
                    break;
                }

                // Receive frames from the decoder
                while (ret >= 0) {
                    ret = avcodec_receive_frame(codec_ctx, frame);
                    if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF)
                        break; // Need more packets or end of stream
                    else if (ret < 0) {
                        fprintf(stderr, "Error during decoding\n");
                        goto end;
                    }
                    sws_scale(
                        sws_ctx,
                        frame->data,
                        frame->linesize,
                        0,
                        codec_ctx->height,
                        rgb_frame->data,
                        rgb_frame->linesize
                        );
                    char *fbuf;
                    posix_memalign((void **)&fbuf, PAGE_SIZE, frame_block_size);
                    //memcpy(fbuf, (char *)rgb_frame->data[0], frame_block_size);//frame->width * frame->height * 4);
                    //memcpy(vc0->pix.bits(), (char *)rgb_frame->data[0], frame_block_size);//frame->width * frame->height * 4);
                    //    vc0->update();
                    if(!s_frames->push(fbuf))
                        free(fbuf);
                    av_frame_unref(frame);
                }
            }
            // Free the packet for the next reading
            av_packet_unref(packet);
        }

    end:
        // Clean up
        av_frame_free(&frame);
        av_frame_free(&rgb_frame);
        av_packet_free(&packet);
        avcodec_free_context(&codec_ctx);
        avformat_close_input(&fmt_ctx);
        sws_freeContext(sws_ctx);
        av_dict_free(&options);

        printf("Finished reading frames.\n");
        return 0;
    };
    connect(this, &MainWindow::need_resize, [=]() {
        if(!video_play)
            return;
        qDebug() << "scale Start";

        auto nsize = vc1->calc_size(ui->gv_vc0->size());
        //svi->setSize(nsize);
        float sc = 1.0 / vc1->scale;
        ui->gv_vc0->scale(sc, sc);
        ui->gv_vc1->scale(sc, sc);
        ui->gv_vc2->scale(sc, sc);
        ui->gv_vc3->scale(sc, sc);

        vc1->resize(QSize(vc1->vw, vc1->vh));
        sc = ui->gv_vc1->width();
        sc = sc / vc1->vw;
        ui->gv_vc0->scale(sc, sc);
        ui->gv_vc1->scale(sc, sc);
        ui->gv_vc2->scale(sc, sc);
        ui->gv_vc3->scale(sc, sc);

        qDebug() << "scale " << sc;
        vc1->scale = sc;


    });
    connect(this, &MainWindow::got_frame, [=]() {
        if(r_frames->empty())
            return;
        char *pix;
        r_frames->pop(pix);
        memcpy(vc1->pix.bits(), pix, frame_block_size);
        free(pix);
        emit vc1->m_update();
        ui->last_time->setText(QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss"));
    });

    connect(ui->video_play, &QPushButton::clicked, [=]() {
        if(ufd < 0)
            return;
        if(!video_play) {
            //camera->start();
            qDebug() << "start ffmpeg...";
            ui->video_play->setText("Stop");
            vc0->pix = QImage(1920, 1080, QImage::Format_RGBA8888);
            vc1->pix = QImage(1920, 1080,  QImage::Format_RGBA8888);
            vc2->pix = QImage(1920, 1080,  QImage::Format_RGBA8888);
            vc3->pix = QImage(1920, 1080,  QImage::Format_RGBA8888);

            vc0->vw = 1920;
            vc0->vh = 1080;
            vc1->vw = 1920;
            vc1->vh = 1080;
            vc2->vw = 1920;
            vc2->vh = 1080;

            vc3->vw = 1920;
            vc3->vh = 1080;


            vc0->resize(QSize(vc1->vw, vc1->vh));
            vc1->resize(QSize(vc1->vw, vc1->vh));
            vc2->resize(QSize(vc1->vw, vc1->vh));
            vc3->resize(QSize(vc1->vw, vc1->vh));

            ui->gv_vc0->resetTransform();
            ui->gv_vc1->resetTransform();
            ui->gv_vc2->resetTransform();
            ui->gv_vc3->resetTransform();

            float sc = ui->gv_vc1->width();
            sc = sc / vc1->vw;
            ui->gv_vc0->scale(sc, sc);
            ui->gv_vc1->scale(sc, sc);
            ui->gv_vc2->scale(sc, sc);
            ui->gv_vc3->scale(sc, sc);

            vc1->scale = sc;
            set_frame_size(1920, 1080, 4);

            frameInProcess[0]=0;
            frameInProcess[1]=0;
            frameInProcess[2]=0;
            frameInProcess[3]=0;

            frameProcess_ptr =0;

            TotalFrameCount=0;
            CurrentTotalFrameCount=0;

            FrameCount[0] = 0;
            FrameCount[1] = 0;
            FrameCount[2] = 0;
            FrameCount[3] = 0;

            CurrentFrameCount[0] = 0;
            CurrentFrameCount[1] = 0;
            CurrentFrameCount[2] = 0;
            CurrentFrameCount[3] = 0;

          //  float factor = 1.3f; // 130% 亮度
          //  for (int i = 0; i < 256; ++i) {
          //      int newValue = (int)(i * factor);
          //      brightness_lut[i] = (newValue > 255) ? 255 : (unsigned char)newValue;
          //  }



            video_play = true;
         //   emit this->run(get_video);
         //   emit this->run(send_frames);
            emit this->run(read_frames);
            emit this->run(tune_frames);
        } else {
            //camera->stop();
            ui->video_play->setText("Start");
            video_play = false;
        }
    });
    auto timer = new QTimer(this);
    connect(timer, &QTimer::timeout, [=](){
        if(!video_play)
            return;

        CurrentTotalFrameCount = TotalFrameCount;

        TotalFrameCount = 0;

        CurrentFrameCount[0] = FrameCount[0];
        CurrentFrameCount[1] = FrameCount[1];
        CurrentFrameCount[2] = FrameCount[2];
        CurrentFrameCount[3] = FrameCount[3];

        FrameCount[0] = 0;
        FrameCount[1] = 0;
        FrameCount[2] = 0;
        FrameCount[3] = 0;

        int totalRX = CurrentTotalFrameCount *(frame_block_size - frame_block_offset) /4 /1000/1000;

        ui->rx_lcd->setText(QString::asprintf("%d", totalRX ) );

        ui->vc0_lcd->setText(QString::asprintf("%d", CurrentFrameCount[0]));
        ui->vc1_lcd->setText(QString::asprintf("%d", CurrentFrameCount[1]));
        ui->vc2_lcd->setText(QString::asprintf("%d", CurrentFrameCount[2]));
        ui->vc3_lcd->setText(QString::asprintf("%d", CurrentFrameCount[3]));

    });
    timer->start(1000);
}

MainWindow::~MainWindow()
{
    quit = true;

    delete[] old_s_frame[0];
    delete[] old_s_frame[1];
    delete[] old_s_frame[2];
    delete[] old_s_frame[3];

    delete[] vc_frame[0];
    delete[] vc_frame[1];
    delete[] vc_frame[2];
    delete[] vc_frame[3];


    delete ui;
}

bool MainWindow::eventFilter(QObject *watched, QEvent *event)
{
    (void)watched;
    if(event->type() == QEvent::Resize) {
        emit this->need_resize();
    }
    return false;
}
