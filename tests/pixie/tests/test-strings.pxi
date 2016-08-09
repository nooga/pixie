(ns pixie.test.test-strings
  (require pixie.test :as t)
  (require pixie.string :as s))

(t/deftest test-starts-with?
  (let [s "heyhohuh"]
    (t/assert= (s/starts-with? s "") true)
    (t/assert= (s/starts-with? s "hey") true)
    (t/assert= (s/starts-with? s "heyho") true)
    (t/assert= (s/starts-with? s s) true)

    (t/assert= (s/starts-with? s "ho") false)
    (t/assert= (s/starts-with? s "foo") false)))

(t/deftest test-ends-with?
  (let [s "heyhohuh"]
    (t/assert= (s/ends-with? s "") true)
    (t/assert= (s/ends-with? s "huh") true)
    (t/assert= (s/ends-with? s "hohuh") true)
    (t/assert= (s/ends-with? s s) true)

    (t/assert= (s/ends-with? s "hey") false)
    (t/assert= (s/ends-with? s "foo") false)))

(t/deftest test-split
  (let [s "hey,ho,huh"]
    (t/assert= (s/split s ",") ["hey" "ho" "huh"])
    (t/assert= (s/split s "h") ["" "ey," "o," "u" ""])))

(t/deftest test-split-lines
  ;; Splits unix-style lines.
  (t/assert= (s/split-lines "bibbidi\nbobbidi\nboo")
             ["bibbidi" "bobbidi" "boo"])
  ;; Splits windows-style lines.
  (t/assert= (s/split-lines "bibbidi\r\nbobbidi\r\nboo")
             ["bibbidi" "bobbidi" "boo"])
  ;; Splits mixed up stuff.
  (t/assert= (s/split-lines "bibbidi\nbobbidi\r\nboo")
             ["bibbidi" "bobbidi" "boo"])
  ;; Doesn't split lonely \r
  (t/assert= (s/split-lines "bibbidi\nbobbidi\rboo")
             ["bibbidi" "bobbidi\rboo"])
  ;; Works with a single line.
  (t/assert= (s/split-lines "BibbidiBobbidiBoo")
             ["BibbidiBobbidiBoo"])
  ;; Works with empty strings.
  (t/assert= (s/split-lines "") [""])
  ;; Nil pass-through.
  (t/assert= (s/split-lines nil) nil))

(t/deftest test-index-of
  (let [s "heyhohuh"]
    (t/assert= (s/index-of s "hey") 0)
    (t/assert= (s/index-of s "ho") 3)
    (t/assert= (s/index-of s "foo") nil)

    (t/assert= (s/index-of s "h" 2) 3)
    (t/assert= (s/index-of s "h" 4) 5)
    (t/assert= (s/index-of s "hey" 0) 0)
    (t/assert= (s/index-of s "hey" 1) nil)

    (t/assert= (s/index-of s "h" 0 0) nil)
    (t/assert= (s/index-of s "h" 1 2) nil)))

(t/deftest test-substring
  (let [s "heyhohuh"]
    (t/assert= (s/substring s 0) s)
    (t/assert= (s/substring s 3) (s/substring s 3 (count s)))
    (t/assert= (s/substring s 0 0) "")
    (t/assert= (s/substring s 0 3) "hey")
    (t/assert= (s/substring s 3 5) "ho")
    (t/assert= (s/substring s 5 8) "huh")
    (t/assert= (s/substring s 3 10000) "hohuh")))

(t/deftest test-upper-case
  (t/assert= (s/lower-case "") "")
  (t/assert= (s/upper-case "hey") "HEY")
  (t/assert= (s/upper-case "hEy") "HEY")
  (t/assert= (s/upper-case "HEY") "HEY")
  (t/assert= (s/upper-case "hey?!") "HEY?!"))

(t/deftest test-lower-case
  (t/assert= (s/lower-case "") "")
  (t/assert= (s/lower-case "hey") "hey")
  (t/assert= (s/lower-case "hEy") "hey")
  (t/assert= (s/lower-case "HEY") "hey")
  (t/assert= (s/lower-case "HEY?!") "hey?!"))

(t/deftest test-capitalize
  (t/assert= (s/capitalize "timothy") "Timothy")
  (t/assert= (s/capitalize "Timothy") "Timothy"))

(t/deftest test-trim
  (t/assert= (s/trim "") "")
  (t/assert= (s/trim "      ") "")
  (t/assert= (s/trim "   hey  ") "hey")
  (t/assert= (s/trim "   h  ey   ") "h  ey"))

(t/deftest test-triml
  (t/assert= (s/triml "") "")
  (t/assert= (s/triml "     ") "")
  (t/assert= (s/triml "   hey") "hey")
  (t/assert= (s/triml "   hey  ") "hey  ")
  (t/assert= (s/triml "   h  ey   ") "h  ey   "))

(t/deftest test-trimr
  (t/assert= (s/trimr "") "")
  (t/assert= (s/trimr "     ") "")
  (t/assert= (s/trimr "hey   ") "hey")
  (t/assert= (s/trimr "   hey  ") "   hey")
  (t/assert= (s/trimr "   h  ey   ") "   h  ey"))

(t/deftest test-trim-newline
  (t/assert= (s/trim-newline "") "")
  (t/assert= (s/trim-newline "\r\n") "")
  (t/assert= (s/trim-newline "hey\r\n") "hey")
  (t/assert= (s/trim-newline "hey\n\r") "hey")
  (t/assert= (s/trim-newline "hey\r") "hey")
  (t/assert= (s/trim-newline "hey\n") "hey")
  (t/assert= (s/trim-newline "hey\r\nthere\r\n") "hey\r\nthere")
  (t/assert= (s/trim-newline "\r\nhey\r\n") "\r\nhey"))

(t/deftest test-replace
  (t/assert= (s/replace "hey,you,there" "," ", ") "hey, you, there")
  (t/assert= (s/replace "hey,you,there" "," "") "heyyouthere")
  (t/assert= (s/replace "&&&" "&" "&&") "&&&&&&")
  (t/assert= (s/replace "oops" "" "WAT") "WAToWAToWATpWATsWAT"))

(t/deftest test-replace-first
  (t/assert= (s/replace-first "hey,you,there" "," ", ") "hey, you,there")
  (t/assert= (s/replace-first "hey,you,there" "," "") "heyyou,there")
  (t/assert= (s/replace-first "&&&" "&" "&&") "&&&&")
  (t/assert= (s/replace-first "oops" "" "WAT") "WAToops"))

(t/deftest test-reverse
  (t/assert= (s/reverse "not a palindrome") "emordnilap a ton")
  (t/assert= (s/reverse "tacocat") "tacocat")
  (t/assert= (s/reverse "") "")
  (t/assert= (s/reverse nil) nil))

(t/deftest test-join
  (t/assert= (s/join []) "")
  (t/assert= (s/join [1]) "1")
  (t/assert= (s/join [1 2 3]) "123")

  (t/assert= (s/join ", " []) "")
  (t/assert= (s/join ", " [1]) "1")

  (t/assert= (s/join ", " [1 2 3]) "1, 2, 3"))

(t/deftest test-char-literals
  (let [s "hey"]
    (t/assert= (nth s 0) \h)
    (t/assert= (nth s 0) \o150)
    (t/assert= (nth s 0) \u0068)

    (t/assert= (nth s 1) \e)
    (t/assert= (nth s 1) \o145)
    (t/assert= (nth s 1) \u0065)

    (t/assert= (nth s 2) \y)
    (t/assert= (nth s 2) \o171)
    (t/assert= (nth s 2) \u0079)))

(t/deftest test-char-conversions
  (t/assert= (int \a) 97)
  (t/assert= (char 97) \a)

  (t/assert= (int \u269b) 0x269b)
  (t/assert= (char 0x269b) \u269b))

(t/deftest test-unicode
  (t/assert= "hâllo" "hâllo"))

(t/deftest test-blank?
  (t/assert= (s/blank? nil) true)
  (t/assert= (s/blank? "") true)
  (t/assert= (s/blank? " ") true)
  (t/assert= (s/blank? " \t \n  \r ") true)
  (t/assert= (s/blank? "  foo  ") false))

(t/deftest test-escape
  (t/assert= (s/escape "foo" {\f \z}) "zoo")
  (t/assert= (s/escape "foo" {\z \f}) "foo")
  (t/assert= (s/escape "foobar" {\f \b \o \e \b \j}) "beejar")
  (t/assert= (s/escape "foo" {}) "foo")
  (t/assert= (s/escape "foo" nil) "foo")
  (t/assert= (s/escape "" {\f \z}) "")
  (t/assert= (s/escape nil {\f \z}) nil))
