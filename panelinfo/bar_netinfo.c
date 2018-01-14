#include <stdio.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>


/* icons from siji */
// #define STR_NET      "N %%{F#FFFAFAFA}\ue048%%{F-}\n"
// #define STR_NONET    "N %%{F#FF999999}\ue217%%{F-}\n"

/* material icons */
#define STR_NET       "N%%{F-}\uf2e8   %%{F-}\n"
#define STR_NONET     "N%%{F#FF999999}\uf2e6   %%{F-}\n"
#define STR_ROUTER    "N%%{F#FFAAAAAA}\uf2e4   %%{F-}\n"

#define _GOOGLE      "8.8.8.8"
#define _ROUTER      "192.168.1.1"
#define INTERVAL     3
#define CYCLES       5

/* detail control */
#define DEBUGFILE "/tmp/bar_sysinfo_toggle"
int DEBUG = 0;


void netinfo()
{
    int router, google;
    int show_net, count;
    char tmp[50];
    FILE *infile;
    show_net = 1;
    count = 0;
    struct timeval timeout;
    timeout.tv_sec = 2;
    timeout.tv_usec = 0;
    struct sockaddr_in GOOG = {AF_INET, htons(53), {inet_addr(_GOOGLE)}, {0}};
    struct sockaddr_in ROUT = {AF_INET, htons(80), {inet_addr(_ROUTER)}, {0}};
    while (1) {
        infile = fopen(DEBUGFILE, "r");
        if (infile)
            fscanf(infile, "%d", &DEBUG);
        fclose(infile);
        tmp[0] = '\0';
        router = socket(AF_INET, SOCK_STREAM, 0);
        setsockopt(router, SOL_SOCKET, SO_RCVTIMEO, (char *)&timeout, sizeof(timeout));
        setsockopt(router, SOL_SOCKET, SO_SNDTIMEO, (char *)&timeout, sizeof(timeout));
        if (connect(router, (struct sockaddr *) &ROUT, sizeof(ROUT)) == 0) {
            google = socket(AF_INET, SOCK_STREAM, 0);
            setsockopt(google, SOL_SOCKET, SO_RCVTIMEO, (char *)&timeout, sizeof(timeout));
            setsockopt(google, SOL_SOCKET, SO_SNDTIMEO, (char *)&timeout, sizeof(timeout));
            if (connect(google, (struct sockaddr *) &GOOG, sizeof(GOOG)) == 0) {
                sprintf(tmp, STR_NET);
                show_net = 0;
                count++;
            }
            else {
                sprintf(tmp, STR_ROUTER);
                show_net = count = 1;
            }
            close(google);
        }
        else {
            sprintf(tmp, STR_NONET);
            show_net = count = 1;
        }
        close(router);
        if( show_net || count < CYCLES || DEBUG)
            printf(tmp);
        else
            printf("N  \n");
        fflush(stdout);
        sleep(INTERVAL);
    }
}

int main()
{
    FILE *dfile;
    dfile = fopen(DEBUGFILE, "w");
    fprintf(dfile, "%d", DEBUG);
    fclose(dfile);
    netinfo();
    return 0;
}
