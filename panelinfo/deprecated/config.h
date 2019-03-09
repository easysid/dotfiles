/*
*  Macros for commands, colors, and icons.
*  Use genconfig.sh to generate
*/

#define FORMAT       "S"
#define INTERVAL     3

/* CPU and RAM */
#define STR_CPU      " %%{F#FFc678dd A:dzen_popup_toggle.sh sysinfo:}\ue082%%{F-} %.0f%%%%{A} "
#define STR_RAM_M    " %%{F#FFc678dd A:dzen_popup_toggle.sh diskinfo:}\ue028%%{F-} %.0fM%%{A} "
#define STR_RAM_G    " %%{F#FFc678dd A:dzen_popup_toggle.sh diskinfo:}\ue028%%{F-} %.2fG%%{A} "

/* internet connection */
#define STR_NET      "%%{F#FF61afef A:dzen_popup_toggle.sh netinfo:} \ue19c %%{F- A}"
#define STR_NONET    "%%{F#FF636d83 A:dzen_popup_toggle.sh netinfo:} \ue19c %%{F- A}"

/* temperatures */
#define STR_TEMP     " %%{F#FFe06c75}\ue0ca%%{F-} %ld° %%{F#FFe06c75}\ue0ca%%{F-} %ld° "

/* clock */
#define STR_CLK      " %%{F#FFabb2bf A:dzen_popup_toggle.sh calendar:}%%{F-}%s%%{A} "

/* ac and battery status */
#define STR_AC       " %%{F#FFabb2bf}\ue041%%{F-}"
#define STR_BATF     " %%{F#FFabb2bf}\ue1ff%%{F-}"
#define STR_BATH     " %%{F#FFd19a66}\ue1fe%%{F-}"
#define STR_BATC     " %%{F#FFe06c75}\ue1fd%%{F-}"

/* mpd status */
#define STR_PLAY     "M %%{F#FFabb2bf A:mpc toggle > /dev/null:}\ue1a6%%{A F-} %%{A: dzen_popup_toggle.sh musicinfo:}%.40s%%{A} "
#define STR_PAUSE    "M %%{F#FFabb2bf A:mpc toggle > /dev/null:}\ue1a6%%{A F#FF636d83} %%{A:dzen_popup_toggle.sh musicinfo:}%.40s%%{F- A} "
#define STR_STOP     "M %%{F#FF636d83}\ue1a6%%{F-} "

/* field separator for long info */
#define STR_SEP      "%{F#FFa0a0a0}|%{F-}"
