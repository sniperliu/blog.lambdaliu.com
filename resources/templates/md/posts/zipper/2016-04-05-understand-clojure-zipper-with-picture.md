{:title "Understand clojure.zip with picture"
 :layout :post
 :tags ["clojure" "zipper" "graphviz"]}

Recently I am reading "Clojure Recipes". In Chapter 11 & 12, both use clojure.zip/zipper to extract the information from map. It took me some time to understand zipper. So I would like to share the experience.

I read below articles<a name="articles"></a>
1. [Getting Acquainted With Clojure Zippers](http://josf.info/blog/2014/03/21/getting-acquainted-with-clojure-zippers/) (More structure, and easier to understand)
2. ["Editing" Trees in Clojure](http://www.exampler.com/blog/2010/09/01/editing-trees-in-clojure-with-clojurezip)
3. [Zipper from Haskell Wiki](https://wiki.haskell.org/Zipper)

> "The Zipper is an idiom that uses the idea of “context” to the means of manipulating locations in a data structure."

Wait a minute, if we only have data structure like list, vector or simple map, why we need zipper to help?
The answer is no, zipper is more focused on tree structure.

A picture is worth a thousands words.

```clojure
(require '[clojure.zipper :as zip])
(use 'rhizome.viz)
```

## zipper a vector
```clojure
(def t [1 [:a :b] 2 3 [40 50 60]])
(def z (zip/vector-zip vector? seq  (fn [_ c] c) t))
;; Visualize the structure
(view-tree sequential? seq t
           :node->descriptor (fn [n] {:label n}))
```
![zipper-01](img/zipper_01.png)

## zipper a map
```clojure
(def m {:a 3 :b {:x true :y false} :c 4})
(def z (zip/zipper
        (fn [x] (or (map? x) (map? (nth x 1))))
        (fn [x] (seq (if (map? x) x (nth x 1))))
        (fn [x children]
          (if (map? x)
            (into {} children)
            (assoc x 1 (into {} children))))
        m))
;; Visualize the structure
(view-tree (fn [x] (or (map? x) (map? (nth x 1))))
           (fn [x] (seq (if (map? x) x (nth x 1))))
	   m
	   :node->descriptor (fn [n] {:label n}))
```
![zipper-02](img/zipper_02.png)

## So ....
One of important function of zipper is to convert data structure like vector, list, map etc into a tree.

To zipper vector, we tell every element of a vector is the child, while the vector is their parent node, then we recurse.

To zipper map, we tell every map entry of the map is the child of root, which is the map itself, if the value of the map entry is a map, then the map entry is the parent of the child.

# But is above Zipper?
The answer is No!! Above is only part of zipper.

Another powerful function of zipper is that it provides the context which include the navigation or path information, like up/down(parent/child), left/right(sibliing), next(along depth first path) and the paths to go to current nodes. Which is fully described in above [3 articles](#articles).

I think with above graphs, you will be more clear about what the codes & example in the articles.

# Misc
To enhance our understanding, an interesting example from [clojuredocs](https://clojuredocs.org/clojure.zip/zipper)
```clojure
(def m {:a 3 :b {:x true :y false} :c 4})
(def z (map-zipper m)) ;; refer above zipper map
;;
(-> z
    zip/down
    (zip/edit (fn [[k v]] [k (inc v)]))
    zip/root)
;;=> {:a 4, :b {:x true, :y false}, :c 4}
```
And let's check z.
```clojure
(println (zip/node z))
;;=> {:a 3, :b {:x true, :y false}, :c 4}
```
The change of the child node reflects back to the whole tree, instead of change a new child node.

It tells us 2 things
1. zipper strictly follow the functional programming's rule - no side effect
2. zipper provide us a powerful way to modify complex structure, while we only need to focus on the specific child node, which is not like function like map.