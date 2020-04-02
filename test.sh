#!/usr/bin/env bats

exe="/usr/local/bin/dhall-default"

for input in $(ls test/*.dhall); do
  @test $input {
    exe_output=$($exe --filename $input)
    result_output=$(cat $input.result)
    [ "$exe_output" = "$result_output" ]
  };
done
