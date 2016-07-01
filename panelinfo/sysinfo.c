/*
 * sysinfos.c
 * generate sys infos for my lemonbar config
 *
 * easysid - Friday, 17 June 2016 18:01 IST
 *
 * broadly copied from https://github.com/TrilbyWhite/dwmStatus
 * and other sources on the internet.
 */

#include <stdio.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>

#include "config.h"


#define CPU_FILE       "/proc/stat"
#define RAM_FILE       "/proc/meminfo"
#define AC_ADP_FILE    "/sys/class/power_supply/ADP1/online"
#define BAT_CAP_FILE   "/sys/class/power_supply/BAT0/capacity"
#define CPU_TEMP_FILE  "/sys/class/hwmon/hwmon1/temp2_input"
#define GPU_TEMP_FILE  "/sys/class/hwmon/hwmon2/temp1_input"
#define _SERVER        "8.8.8.8"
#define _PORT          53
#define _TIMEOUT       500000

void print_short_info(char *format)
{
    // Requires only net, battery, and time
    // declare
    int a, c, sock;
    char str[30], tmp[100], status[256];
    FILE *infile;
    time_t now;
    struct tm *lt;
    struct timeval timeout;
    struct sockaddr_in addr = {AF_INET, htons(_PORT), {inet_addr(_SERVER)}, {0}};
    timeout.tv_sec = 0;
    timeout.tv_usec = _TIMEOUT;

    // infinite loop
    for (;;) {
        tmp[0] = status[0] = '\0';

        // Network
        sock = socket(AF_INET, SOCK_STREAM, 0);
        setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, (char *)&timeout, sizeof(timeout));
        setsockopt(sock, SOL_SOCKET, SO_SNDTIMEO, (char *)&timeout, sizeof(timeout));
        if (connect(sock, (struct sockaddr *) &addr, sizeof(addr)) != 0)
            sprintf(tmp, STR_NONET);
        close(sock);
        strcat(status, tmp);

        // Battery
        infile = fopen(AC_ADP_FILE, "r");
        fscanf(infile, "%d\n", &a);
        fclose(infile);
        infile = fopen(BAT_CAP_FILE, "r");
        fscanf(infile, "%d\n", &c);
        fclose(infile);
        if (a == 1)
            sprintf(tmp, STR_AC" ");
        else if (c < 30)
            sprintf(tmp, STR_BATC" ");
        else if (c < 70)
            sprintf(tmp, STR_BATH" ");
        else
            sprintf(tmp, STR_BATF" ");
        strcat(status, tmp);
        if (c < 70){
            sprintf(tmp,"%d ", c);
            strcat(status, tmp);
        }

        // Time
        time(&now);
        lt = localtime(&now);
        strftime(str, sizeof(str),"%H:%M", lt);
        sprintf(tmp, STR_CLK, str);
        strcat(status, tmp);

        printf("%s%s\n", format, status);
        fflush(stdout);
        sleep(INTERVAL);
    }
}

void print_long_info(char *format)
{
    // declare the variables outside the loop
    int sock;
    long a, b, c, d, e, f, g, idle, total, oldidle, oldtotal, total_d, idle_d;
    float used;
    char str[30], tmp[100], status[512];
    FILE *infile;
    time_t now;
    struct tm *lt;
    struct timeval timeout;
    struct sockaddr_in addr = {AF_INET, htons(_PORT), {inet_addr(_SERVER)}, {0}};
    timeout.tv_sec = 0;
    timeout.tv_usec = _TIMEOUT;
    // seed cpu usage values. Saves time in main loop
    infile = fopen(CPU_FILE, "r");
    fscanf(infile, "cpu %ld %ld %ld %ld %ld %ld %ld", &a, &b, &c, &d, &e, &f, &g);
    fclose(infile);
    oldtotal = a+b+c+d+e+f+g;
    oldidle = d+e;

    // infinite loop
    for (;;) {
        tmp[0] = status[0] = '\0';

        // CPU
        infile = fopen(CPU_FILE, "r");
        fscanf(infile, "cpu %ld %ld %ld %ld %ld %ld %ld", &a, &b, &c, &d, &e, &f, &g);
        fclose(infile);
        total = a+b+c+d+e+f+g;
        idle = d+e;
        total_d = total - oldtotal;
        idle_d = idle - oldidle;
        oldtotal = total;
        oldidle = idle;
        used = 0.0;
        if (total_d > 0)
            used = 100*(total_d - idle_d)/total_d;
        sprintf(tmp, STR_CPU, used);
        strcat(status, tmp);

        // RAM
        infile = fopen(RAM_FILE, "r");
        fscanf(infile, "MemTotal: %ld kB\nMemFree: %ld kB\nMemAvailable: %ld kB\
                \nBuffers: %ld kB\nCached: %ld kB", &total, &f, &a, &b, &c);
        fclose(infile);
        used = (total - f - b - c)/1024;
        if (used >= 1000)
            sprintf(tmp, STR_RAM_G, used/1024);
        else
            sprintf(tmp, STR_RAM_M, used);
        strcat(status, tmp);
        strcat(status, STR_SEP);

        // Temperatures
        infile = fopen(CPU_TEMP_FILE, "r");
        fscanf(infile, "%ld\n", &a);
        fclose(infile);
        infile = fopen(GPU_TEMP_FILE, "r");
        fscanf(infile, "%ld\n", &b);
        fclose(infile);
        sprintf(tmp, STR_TEMP, a/1000, b/1000);
        strcat(status, tmp);
        strcat(status, STR_SEP);

        // Network
        sock = socket(AF_INET, SOCK_STREAM, 0);
        setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, (char *)&timeout, sizeof(timeout));
        setsockopt(sock, SOL_SOCKET, SO_SNDTIMEO, (char *)&timeout, sizeof(timeout));
        if (connect(sock, (struct sockaddr *) &addr, sizeof(addr)) != 0)
            sprintf(tmp, STR_NONET);
        else
            sprintf(tmp, STR_NET);
        close(sock);
        strcat(status, tmp);
        strcat(status, STR_SEP);

        // Battery
        infile = fopen(AC_ADP_FILE, "r");
        fscanf(infile, "%ld\n", &a);
        fclose(infile);
        infile = fopen(BAT_CAP_FILE, "r");
        fscanf(infile, "%ld\n", &c);
        fclose(infile);
        if (a == 1)
            sprintf(tmp, STR_AC" %ld%% ", c);
        else if (c < 30)
            sprintf(tmp, STR_BATC" %ld%% ", c);
        else if (c < 70)
            sprintf(tmp, STR_BATH" %ld%% ", c);
        else
            sprintf(tmp, STR_BATF" %ld%% ", c);
        strcat(status, tmp);
        strcat(status, STR_SEP);

        // Time
        time(&now);
        lt = localtime(&now);
        strftime(str, sizeof(str), "%H:%M", lt);
        sprintf(tmp, STR_CLK, str);
        strcat(status, tmp);

        printf("%s%s\n", format, status);
        fflush(stdout);
        sleep(INTERVAL);
    }
}

int main(int argc, char *argv[])
{
    char *format = FORMAT;
    int short_info = 1;
    int opt;
    while ((opt = getopt(argc, argv, "hlf:")) != -1) {
        switch (opt) {
            case 'h':
                printf("-h Help | -l long info | -f format");
                return 0;
                break;
            case 'l':
                short_info = 0;
                break;
            case 'f':
                format = optarg;
                break;
        }
    }
    if (short_info)
        print_short_info(format);
    else
        print_long_info(format);
    return 0;
}

