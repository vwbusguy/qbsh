FROM fedora:40 as builder

WORKDIR /tmp
RUN dnf install wget gcc g++ alsa-lib{,-devel} binutils findutils libglvnd-{devel,glx} mesa-libGLU{,-devel} zlib-devel -y
RUN wget https://github.com/QB64Team/qb64/releases/download/v2.0.2/qb64_2021-11-07-02-59-19_4d85302_lnx.tar.gz && tar xvzf qb64_2021-11-07-02-59-19_4d85302_lnx.tar.gz
WORKDIR /tmp/qb64
RUN sed -i 's,exit 1,,g' ./setup_lnx.sh
RUN ./setup_lnx.sh 
COPY qbsh.bas /tmp/qbsh.bas
COPY lib/ /tmp/lib/
RUN ./qb64 -x /tmp/qbsh.bas -o /tmp/qbsh

FROM fedora:40 AS tester

COPY --from=builder /tmp/qbsh /usr/local/bin/qbsh
COPY tests/ /tmp/tests/
RUN /tmp/tests/test.qsh

FROM fedora:40

COPY --from=builder /tmp/qbsh /usr/bin/qbsh
ENTRYPOINT qbsh
