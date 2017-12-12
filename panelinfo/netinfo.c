#include <stdio.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>


/* icons from siji */
// #define STR_NET      "N %%{F#FFFAFAFA}\ue048%%{F-}\n"
// #define STR_NONET    "N %%{F#FF999999}\ue217%%{F-}\n"

/* material icons */
#define STR_NET      "N %%{F#FFFAFAFA}\uf2e8%%{F-} \n"
#define STR_NONET    "N %%{F#FF999999}\uf2e6%%{F-} \n"

#define _SERVER      "8.8.8.8"
#define _PORT        53
#define INTERVAL     3

int main()
{
    int sock;
    struct sockaddr_in addr = {AF_INET, htons(_PORT), {inet_addr(_SERVER)}, {0}};
    while (1) {
        sock = socket(AF_INET, SOCK_STREAM, 0);
        if (connect(sock, (struct sockaddr *) &addr, sizeof(addr)) == 0)
            printf(STR_NET);
        else
            printf(STR_NONET);
        fflush(stdout);
        close(sock);
        sleep(INTERVAL);
    }
    return 0;
}
