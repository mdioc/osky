(lang dune 3.16)

(name osky)

(generate_opam_files true)

(source
 (github mdioc/osky))

(authors "mdioc")

(maintainers "mdioc")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name osky)
 (synopsis "OCaml cli for bluesky")
 (description "OCaml cli for bluesky to learn OCaml")
 (depends ocaml dune eio eio_main piaf core core_unix yojson)
 (tags
  (topics "learning" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
