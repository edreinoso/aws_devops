#!/usr/bin/env python3

from aws_cdk import core

from load_test.load_test_stack import LoadTestStack

app = core.App()
LoadTestStack(app, "load-test")

app.synth()
