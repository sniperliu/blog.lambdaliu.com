{:title "Parse Bencoding with Clojure in Parsec style"
 :layout :post
 :tags ["clojure" "bencoding" "parsec"]}

Want to implement Bittorrent client in Clojure.

As first step,  I implemented the Bencoding which torrent file is encoded.

I did some research, read some implementation in Haskell and found one Bencoding implementation in Clojure, but it's in raw style and could not handle some invalid condition, like "i-0e" etc.

So I wonder why could not I implement one like what Haskeller did with Parsec.

With that in mind, I find [the/parsatron](https://github.com/youngnh/parsatron).

And implement something like below

```clojure
(defparser ben-string []
  (let->> [length (positive)
           _ (p/char \:)
           chs (p/times length (p/any-char))]
    (p/always (apply str chs))))

(defparser ben-integer []
  (p/between (p/char \i) (p/char \e) (integer)))

(defparser ben-list []
  (p/between (p/char \l) (p/char \e) (p/many (ben-value))))

(defparser ben-map []
  (let->> [ds (p/between (p/char \d)
                         (p/char \e)
                         (p/many1 (let->> [k (ben-string)
                                           v (ben-value)]
                                    (p/always [k v]))))]
    (p/always (into (sorted-map) ds))))

(defparser ben-value []
  (p/choice (ben-string) (ben-integer) (ben-list) (ben-map)))
```
Gist: [bencoding.clj](https://gist.github.com/sniperliu/91993c79e03f52831c6b)

Note:
- the/parsatron seems not actively being maintained now.
-  It only use String or sequence of token as input may be a minus.
-  But I am quite glad to implement the bencoding logic with it. And thanks [youngnh](https://github.com/youngnh) for the brilliant implementation.
