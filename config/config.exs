import Config

project_root  = System.get_env("PROJECT_ROOT")

config :mada_reader,
  make_tree_binary: "#{project_root}/rootmacro/build/make_tree/make_tree",
  tmp_dir: "#{project_root}/tmp"
