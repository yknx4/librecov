[
  surface_line_length: 120,
  import_deps: [:ecto, :phoenix, :surface],
  inputs: [
    "{mix,.formatter}.exs",
    "priv/*/seeds.exs",
    "{config,lib,test}/**/*.{ex,exs,sface}",
    "lib/librecov_web/live/**/*.{ex,exs,sface}"
  ],
  subdirectories: ["priv/*/migrations"],
  plugins: [Surface.Formatter.Plugin],
  locals_without_parens: [
    # Formatter tests
    assert_format: 2,
    assert_format: 3,
    assert_same: 1,
    assert_same: 2,

    # Errors tests
    assert_eval_raise: 3,

    # Mix tests
    in_fixture: 2,
    in_tmp: 2
  ]
]
