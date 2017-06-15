# From image
FROM ubuntu:16.04

MAINTAINER rbjoergensen <rasmus@callofthevoid.dk>

RUN mkdir /test
RUN touch /test/test.file

RUN echo "hello there." > /test/test.file

# CMD ["executable","param1","param2"]
CMD ["tail -f /test/test.file"]