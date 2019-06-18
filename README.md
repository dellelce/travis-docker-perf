# travis-docker-perf
Can I speed up travis performance for docker build by moving /var/lib/docker to tmpfs?

If I can move the filesystem used to store builds I may gain speed for docker builds that handles lots of files.
