(import :std/test
        :colorstring/colorstring
        :std/sugar)

(export colorstring-test)

(def colorstring-test
  (test-suite "test :colorstring"
    (color-reset #t)

    (test-case "test color strings"
      (check-equal? (color "foo") "foo")
      (check-equal? (color "[blue]foo") "\033[34mfoo\033[0m")
      (check-equal? (color "foo[blue]foo") "foo\033[34mfoo\033[0m")
      (check-equal? (color "foo[what]foo") "foo[what]foo")
      (check-equal? (color "foo[bold]foo") "foo\033[1mfoo\033[0m")
      (check-equal? (color "[underline]foo[reset]bar") "\033[4mfoo\033[0mbar\033[0m"))

    (test-case "test color-prefix strings"
      (check-equal? (color-prefix "foo") "")
      (check-equal? (color-prefix "[blue]foo") "[blue]")
      (check-equal? (color-prefix "[bold][blue]foo") "[bold][blue]")
      (check-equal? (color-prefix "   [bold][blue]foo") "[bold][blue]"))

    (test-case "test color-reset"
      (color-reset #f)
      (check-equal? (color "[blue]foo") "\033[34mfoo"))
    ))

(run-tests! colorstring-test)
