/*
 * bar_sysinfo.c
 * generate sys infos for my lemonbar config
 *
 * easysid - Wednesday, 03 January 2018 17:49 IST
 *
 * show info only when it exceeds a threshold
 * - move network to a different file. I could use threads instead
 * - use an external control for debug
 *
 * broadly copied from https://github.com/TrilbyWhite/dwmsys_status
 * and other sources on the internet.
 */


#include <stdio.h>
#include <string.h>
#include <time.h>
#include <unistd.h>


#define STR_SEP      "    "

/* icons from siji font */
/* CPU and RAM */
// #define STR_CPU      "%%{F#FFFAFAFA}\ue082%%{F-} %.0f%%"
// #define STR_RAM_M    "%%{F#FFFAFAFA}\ue028%%{F-} %.0fM"
// #define STR_RAM_G    "%%{F#FFFAFAFA}\ue028%%{F-} %.2fG"
// /* temperatures */
// #define STR_TEMP     "%%{F#FFFAFAFA}\ue0c9%%{F-} %ld°"
// /* clock and calendar*/
// #define STR_CLK      "C %%{F-}%s"
// #define STR_CAL      "%%{F#FFFAFAFA}\ue268%%{F-} %s "
// /* ac and battery sys_status */
// #define STR_CHG      "%%{F#FFFAFAFA}\ue09e%%{F-} %ld%%"
// #define STR_BAT     "%%{F#FFFAFAFA}\ue08e%%{F-} %ld%%"
// #define STR_BATC     "%%{F#FFe02b18}LOW BATTERY  %ld%%%%{F-}"

/* icons from material design */
/* CPU and RAM */
#define STR_CPU      "%%{F#FFFAFAFA}\uf3e1%%{F-} %.0f%%"
#define STR_RAM_M    "%%{F#FFFAFAFA}\uf3e0%%{F-} %.0fM"
#define STR_RAM_G    "%%{F#FFFAFAFA}\uf3e0%%{F-} %.2fG"
/* temperatures */
#define STR_TEMP     "%%{F#FFFAFAFA}\uf161%%{F-} %ld°"
/* clock and calendar*/
#define STR_CLK      "C %%{F-}%s"
#define STR_CAL      "%%{F#FFFAFAFA}\uf331%%{F-} %s"
/* ac and battery status */
#define STR_CHG      "%%{F#FFFAFAFA}\uf114%%{F-} %ld%%"
#define STR_BAT     "%%{F#FFFAFAFA}\uf116%%{F-} %ld%%"
#define STR_BATC     "%%{F#FFe02b18}LOW BATTERY  %ld%%%%{F-}"

/* input files */
#define CPU_FILE       "/proc/stat"
#define RAM_FILE       "/proc/meminfo"
#define AC_ADP_FILE    "/sys/class/power_supply/ADP1/online"
#define BAT_CAP_FILE   "/sys/class/power_supply/BAT0/capacity"
#define CPU_TEMP_FILE  "/sys/class/hwmon/hwmon1/temp2_input"
#define INTERVAL       1

/* Control values for thresholds */
#define LIM_CPU 40
#define LIM_RAM 1900
#define LIM_TMP 55
#define LIM_BAT_LOW 30
#define CYCLES_COUNT 10

/* detail control */
#define DEBUGFILE "/tmp/bar_sysinfo_toggle"
int DEBUG = 0;


void print_long_info()
{
    char format = 'S';
    // display flags
    int show_cpu, show_ram, show_temp;
    int cpu_count, ram_count, temp_count;
    long a, b, c, d, e, f, g, idle, total, oldidle, oldtotal, total_d, idle_d;
    float used;
    char str[30], tmp[100], bat_cal[100], sys_status[256];
    FILE *infile;
    time_t now;
    struct tm *lt;

    // seed cpu usage values. Saves time in main loop
    infile = fopen(CPU_FILE, "r");
    fscanf(infile, "cpu %ld %ld %ld %ld %ld %ld %ld", &a, &b, &c, &d, &e, &f, &g);
    fclose(infile);
    oldtotal = a+b+c+d+e+f+g;
    oldidle = d+e;
    // initialize the flags
    show_cpu = show_ram = show_temp = 0;
    cpu_count = ram_count = temp_count = CYCLES_COUNT;
    // infinite loop
    for (;;) {
        tmp[0] = sys_status[0] = bat_cal[0] = '\0';
        // Read DEBUG status
        infile = fopen(DEBUGFILE, "r");
        fscanf(infile, "%d", &DEBUG);
        fclose(infile);

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
        if (used > LIM_CPU)
            show_cpu = cpu_count = 1;
        else
            show_cpu = 0;
        if (show_cpu || cpu_count < CYCLES_COUNT || DEBUG) {
            sprintf(tmp, STR_CPU, used);
            strcat(sys_status, tmp);
            strcat(sys_status, STR_SEP);
        }

        // RAM
        infile = fopen(RAM_FILE, "r");
        fscanf(infile, "MemTotal: %ld kB\nMemFree: %ld kB\nMemAvailable: %ld kB\
                \nBuffers: %ld kB\nCached: %ld kB", &total, &f, &a, &b, &c);
        fclose(infile);
        used = (total - f - b - c)/1024;
        if (used > LIM_RAM)
            show_ram = ram_count = 1;
        else
            show_ram = 0;
        if (show_ram || ram_count < CYCLES_COUNT || DEBUG) {
            if (used >= 1000)
                sprintf(tmp, STR_RAM_G, used/1024);
            else
                sprintf(tmp, STR_RAM_M, used);
            strcat(sys_status, tmp);
            strcat(sys_status, STR_SEP);
        }

        // Temperatures
        infile = fopen(CPU_TEMP_FILE, "r");
        fscanf(infile, "%ld\n", &a);
        fclose(infile);
        /* infile = fopen(GPU_TEMP_FILE, "r"); */
        /* fscanf(infile, "%ld\n", &b); */
        /* fclose(infile); */
        a = a/1000;
        if (a > LIM_TMP)
            show_temp = temp_count = 1;
        else
            show_temp = 0;
        if (show_temp || temp_count < CYCLES_COUNT || DEBUG) {
            sprintf(tmp, STR_TEMP, a);
            strcat(sys_status, tmp);
            strcat(sys_status, STR_SEP);
        }

        // Battery
        infile = fopen(AC_ADP_FILE, "r");
        fscanf(infile, "%ld\n", &a);
        fclose(infile);
        infile = fopen(BAT_CAP_FILE, "r");
        fscanf(infile, "%ld\n", &c);
        fclose(infile);
        if (a) {
            sprintf(tmp, STR_CHG, c);
        }
        else {
            if (c < LIM_BAT_LOW)
                sprintf(tmp, STR_BATC, c);
            else
                sprintf(tmp, STR_BAT, c);
        }
        // show only if less than 50%
        if (a == 0 || c < 55 || DEBUG) {
            strcat(bat_cal, tmp);
            strcat(bat_cal, STR_SEP);
        }

        // calendar
        time(&now);
        lt = localtime(&now);
        /* strftime(str, sizeof(str), "%a, %d %b", lt); */
        /* strftime(str, sizeof(str), "%a, %d %b", lt); */
        /* sprintf(tmp, STR_CAL, str); */
        /* strcat(bat_cal, tmp); */

        // Clock
        strftime(str, sizeof(str), "%I:%M %p", lt);
        sprintf(tmp, STR_CLK, str);
        strcat(bat_cal, tmp);

        printf("%c %s\n", format, sys_status);
        /* printf("%s\n", tmp); */
        printf("B %s\n", bat_cal);
        fflush(stdout);
        cpu_count++;
        ram_count++;
        temp_count++;
        sleep(INTERVAL);
    }
}


int main()
{
    FILE *dfile;
    dfile = fopen(DEBUGFILE, "w");
    fprintf(dfile, "%d", DEBUG);
    fclose(dfile);
    print_long_info();
    return 0;
}

