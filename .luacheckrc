std = "+vim"
globals = { "vim" }
ignore = { "^_", "self" }
exclude_files = {
  "lua/matcha/palette/",
  "previews/",
}
read_globals = {
  describe = true,
  it = true,
  equals = true,
  equals_deep = true,
  assert_true = true,
  hex = true,
}
allow_defined_top = true
