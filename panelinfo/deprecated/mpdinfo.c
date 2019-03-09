/*
 * mpdinfo.c
 * prints the current song state for my lemonbar config
 *
 * easysid - Tuesday, 21 June 2016 12:33 IST
 *
 * Shoutout to the libmpdclient devs for great documentation
 * https://www.musicpd.org/doc/libmpdclient/index.html
 */

#include <stdio.h>
#include <unistd.h>
#include <mpd/client.h>

#include "config.h"


void print_song_info(struct mpd_connection *conn, struct mpd_status *status)
{
    const char *title;
    struct mpd_song *song;
    enum mpd_state state;
    state = mpd_status_get_state(status);
    if (state == MPD_STATE_PLAY || state == MPD_STATE_PAUSE) {
        title = "default title";
        song = mpd_run_current_song(conn);
        if (song != NULL){
            title = mpd_song_get_tag(song, mpd_tag_name_iparse("title") , 0);
            if (state == MPD_STATE_PLAY)
                printf(STR_PLAY, title);
            else
                printf(STR_PAUSE, title);
        }
        mpd_song_free(song);
    }
    else
        printf(STR_STOP);
    printf("\n");
    fflush(stdout);
}

void run_event_loop(struct mpd_connection *conn, enum mpd_idle event)
{
    struct mpd_status *status;
    while (mpd_run_idle_mask(conn, event)) {
        status = mpd_run_status(conn);
        if (status == NULL)
            break;
        print_song_info(conn, status);
        mpd_status_free(status);
    }
}

int main()
{
    struct mpd_connection *conn;
    struct mpd_status *status;
    // Keep trying to connect every INTERVAL seconds
    while (true) {
        /* fprintf(stderr, "\tconnecting ...\n"); */
        conn = mpd_connection_new(NULL, 0, 0);
        status = mpd_run_status(conn);
        if (status != NULL) {
            // Get initial values
            print_song_info(conn, status);
            mpd_status_free(status);
            // Start the idle loop
            run_event_loop(conn, MPD_IDLE_PLAYER);
            /* fprintf(stderr, "\tevent loop has failed\n"); */
        }
        /* fprintf(stderr, "\tconnection declined\n"); */
        mpd_connection_free(conn);
        sleep(INTERVAL);
    }
    return 0;
}
