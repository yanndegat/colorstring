;;; stashcli command line client

(import :gerbil/gambit
        :std/sugar
        :std/format
        :std/srfi/13
        :std/pregexp
        :std/ref)

(export color color-prefix color-reset color-disabled)


;; color colorizes your strings using the default settings.
;;
;; Strings given to color should use the syntax `[color]` to specify the
;; color for text following. For example: `[blue]Hello` will return "Hello"
;; in blue. See DefaultColors for all the supported colors and attributes.
;;
;; If an unrecognized color is given, it is ignored and assumed to be part
;; of the string. For example: `[hi]world` will result in "[hi]world".
;;
;; A color reset is appended to the end of every string. This will reset
;; the color of following strings when you output this text to the same
;; terminal session.

(def default-color-map
  (hash
   ;; Default foreground/background colors
   ("default" "39")
   ("_default_" "49")

   ;; Foreground colors
   ("black"         "30")
   ("red"           "31")
   ("green"         "32")
   ("yellow"        "33")
   ("blue"          "34")
   ("magenta"       "35")
   ("cyan"          "36")
   ("light_gray"    "37")
   ("dark_gray"     "90")
   ("light_red"     "91")
   ("light_green"   "92")
   ("light_yellow"  "93")
   ("light_blue"    "94")
   ("light_magenta" "95")
   ("light_cyan"    "96")
   ("white"         "97")

   ;; Background colors
   ("_black_"         "40")
   ("_red_"           "41")
   ("_green_"         "42")
   ("_yellow_"        "43")
   ("_blue_"          "44")
   ("_magenta_"       "45")
   ("_cyan_"          "46")
   ("_light_gray_"    "47")
   ("_dark_gray_"     "100")
   ("_light_red_"     "101")
   ("_light_green_"   "102")
   ("_light_yellow_"  "103")
   ("_light_blue_"    "104")
   ("_light_magenta_" "105")
   ("_light_cyan_"    "106")
   ("_white_"         "107")

   ;; Attributes
   ("bold"       "1")
   ("dim"        "2")
   ("underline"  "4")
   ("blink_slow" "5")
   ("blink_fast" "6")
   ("invert"     "7")
   ("hidden"     "8")

   ;; Reset to reset everything to their defaults
   ("reset"      "0")
   ("reset_bold" "21")))

(def parseReRaw "\\[[a-z0-9_-]+\\]")
(def parseRe (pregexp (format "(?i:~a)" parseReRaw)))
(def prefixRe (pregexp (format "^(?i:(~a)+)" parseReRaw)))

;; Colors maps a color string to the code for that color. The code
;; is a string so that you can use more complex colors to set foreground,
;; background, attributes, etc. For example, "boldblue" might be
;; "1;34"
(def color-map (make-parameter default-color-map))


;; Reset, if true, will reset the color after each colorization by
;; adding a reset code at the end.
(def color-reset (make-parameter #t))


;; If true, color attributes will be ignored. This is useful if you're
;; outputting to a location that doesn't support colors and you just
;; want the strings returned.
(def color-disabled (make-parameter #f))

;; Color colorizes a string.
(def (color v)
  (def match (pregexp-match-positions parseRe v))
  (cond
   ((not match) v)
   (else
       (call-with-output-string
        (lambda (port)
          (def last-match [0 :: 0])
          (def colored #f)
          (while match
            ;; Write the text in between this match and the last
            (let* ((m (car match))
                   (key (substring v (+ (car m) 1) (- (cdr m) 1)))
                   (code (hash-get (color-map) key)))
              (write-substring v (cdr last-match) (car m) port)
              (set! last-match m)
              (cond
               (code
                (set! colored #t)
                (when (not (color-disabled)) (write-string (format "\033[~am" code) port)))
               (else (write-substring v (car m) (cdr m) port))))
            (set! match (pregexp-match-positions parseRe v (+ 1 (car last-match)))))
          (write-substring v (cdr last-match) (string-length v) port)
          (when (and colored (color-reset) (not (color-disabled)))
            (write-string "\033[0m" port)))))))

;; color-prefix returns the color sequence that prefixes the given text.
;;
;; This is useful when wrapping text if you want to inherit the color
;; of the wrapped text. For example, "[green]foo" will return "[green]".
;; If there is no color sequence, then this will return "".
(def (color-prefix v)
  (let ((match (pregexp-match prefixRe (string-trim v))))
    (if match (car match) "")))
