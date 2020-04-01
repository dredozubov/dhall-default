#!/usr/bin/env bats

exe="./dist-newstyle/build/x86_64-osx/ghc-8.6.5/dhall-default-0.1.0.0/x/dhall-default/build/dhall-default/dhall-default"

for input in $(ls test/*.dhall); do
  @test $input {
    $exe --filename $input
    exe_output=$output
    cat $input.result
    [ "$output" = "$exe_output" ]
  };
done
