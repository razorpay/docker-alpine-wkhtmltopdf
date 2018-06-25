# Razorpay Alpine Wkhtmltopdf Docker Container

## Usage

wkhtmltopdf with qt patches

wkhtmltopdf 0.12.4 with qt patches for alpine. 

Dockerfile modified from https://github.com/madnight/docker-alpine-wkhtmltopdf mostly to ensure support with alpine:3.5 and also to ensure build are happening in a secure environment.

## Package life

This package is supported as is and upgrades will not be provided. @captn3m0 and @venkatvghub are of the opinion that dependencies from Api for wkhtmltopdf should be moved to a separate microservice. This is a possible option.

## Usage

The generated binary from this build, will be available as a release. Images can pick the release directly from the github release or binary.
