#!/usr/bin/env bb

(require 
  '[clojure.java.shell :refer [sh]]
  '[clojure.string :as string]
  '[babashka.fs :as fs])

(defrecord File [:name :lines])

(defn read-file
  [filename]
  (->File filename (string/split (slurp filename) #"\n")))

(defn get-environment-variables
  []
  (into {} (map #(string/split % #"=" 2) (string/split (:out (sh "env")) #"\n"))))

(def environment-variables (get-environment-variables))
(def rc-file (fs/path (get environment-variables "HOME") ".zshrc"))

(defn rc-block-start?
  [line]
  (string/starts-with? line "#### START "))

(defn rc-block-end?
  [line]
  (string/starts-with? line "#### END   "))

(defn get-block-name
  [line]
  (nth (re-find #"^#### ..... ([^ ]+).*" line) 1))

(defn get-block-names
  [^File file]
  (map get-block-name (filter rc-block-start? (:lines file))))

(get-block-names (read-file (.toString rc-file)))
