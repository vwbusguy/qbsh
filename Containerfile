FROM fedora:34

COPY qbsh /usr/bin

ENTRYPOINT qbsh
