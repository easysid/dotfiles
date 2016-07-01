#/bin/bash

# include theme_config
source ~/.scripts/theme_config

# define colors. Use #RRGGBB format. alpha is defined separately
color_cpu="c678dd"
color_temp="${red}"
color_net="${blue}"
color_nonet="${grey1}"
color_ac="${foreground}"
color_batf="${foreground}"
color_bath="${yellow}"
color_batc="${red}"
color_clk="${foreground}"
color_mpd_play="${foreground}"
color_mpd_stop="${grey1}"
color_separator="${grey2}"
# alpha
alpha="FF"

# define icons
icon_cpu='\ue082'
icon_ram='\ue028'
icon_temp='\ue0ca'
icon_net='\ue19c'
icon_ac='\ue041'
icon_batf='\ue1ff'
icon_bath='\ue1fe'
icon_batc='\ue1fd'
icon_mpd='\ue1a6'

# commands for click areas
cmd_cpu="dzen_popup_toggle.sh sysinfo"
cmd_ram="dzen_popup_toggle.sh diskinfo"
cmd_net="dzen_popup_toggle.sh netinfo"
cmd_clk="dzen_popup_toggle.sh calendar"
cmd_mpd1="mpc toggle > /dev/null"
cmd_mpd2="dzen_popup_toggle.sh musicinfo"

interval=3
format_info="S"
format_mpd="M"
mpd_max_len=40

# generate config.h
cat << EOF
/*
*  Macros for commands, colors, and icons.
*  Use genconfig.sh to generate
*/

#define FORMAT       "${format_info}"
#define INTERVAL     ${interval}

/* CPU and RAM */
#define STR_CPU      " %%{F#${alpha}${color_cpu} A:${cmd_cpu}:}${icon_cpu}%%{F-} %.0f%%%%{A} "
#define STR_RAM_M    " %%{F#${alpha}${color_cpu} A:${cmd_ram}:}${icon_ram}%%{F-} %.0fM%%{A} "
#define STR_RAM_G    " %%{F#${alpha}${color_cpu} A:${cmd_ram}:}${icon_ram}%%{F-} %.2fG%%{A} "

/* internet connection */
#define STR_NET      "%%{F#${alpha}${color_net} A:${cmd_net}:} ${icon_net} %%{F- A}"
#define STR_NONET    "%%{F#${alpha}${color_nonet} A:${cmd_net}:} ${icon_net} %%{F- A}"

/* temperatures */
#define STR_TEMP     " %%{F#${alpha}${color_temp}}${icon_temp}%%{F-} %ld° %%{F#${alpha}${color_temp}}${icon_temp}%%{F-} %ld° "

/* clock */
#define STR_CLK      " %%{F#${alpha}${color_clk} A:${cmd_clk}:}${icon_clk}%%{F-}%s%%{A} "

/* ac and battery status */
#define STR_AC       " %%{F#${alpha}${color_ac}}${icon_ac}%%{F-}"
#define STR_BATF     " %%{F#${alpha}${color_batf}}${icon_batf}%%{F-}"
#define STR_BATH     " %%{F#${alpha}${color_bath}}${icon_bath}%%{F-}"
#define STR_BATC     " %%{F#${alpha}${color_batc}}${icon_batc}%%{F-}"

/* mpd status */
#define STR_PLAY     "${format_mpd} %%{F#${alpha}${color_mpd_play} A:${cmd_mpd1}:}${icon_mpd}%%{A F-} %%{A: ${cmd_mpd2}:}%.${mpd_max_len}s%%{A} "
#define STR_PAUSE    "${format_mpd} %%{F#${alpha}${color_mpd_play} A:${cmd_mpd1}:}${icon_mpd}%%{A F#${alpha}${color_mpd_stop}} %%{A:${cmd_mpd2}:}%.${mpd_max_len}s%%{F- A} "
#define STR_STOP     "${format_mpd} %%{F#${alpha}${color_mpd_stop}}${icon_mpd}%%{F-} "

/* field separator for long info */
#define STR_SEP      "%{F#${alpha}${color_separator}}|%{F-}"
EOF
