class foo::broken {
  file {
    "broken file":
      path => "/this/path/should/not/exist",
      mode => "0999";:w

  }
}