FROM ubuntu:20.04

COPY ./quick_setup.sh ./
RUN ./quick_setup.sh -f --skip-interactive
