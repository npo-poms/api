#!/usr/bin/env bash

echo "##teamcity[testStarted name='pages']"

echo "##teamcity[testStdOut name='pages' out='text']"
echo "##teamcity[testStdErr name='pages' out='error text']"
echo "##teamcity[testFinished name='pages' duration='50']"
