FROM python:3.12
LABEL maintainer="justin4758@naver.com"

ENV streamlinkCommit=57dacf7bc9ee1f5793f8aa3c715220ded19653f6

#ENV streamlinkVersion=6.4.2
#ENV PATH "${HOME}/.local/bin:${PATH}"

#ADD https://github.com/streamlink/streamlink/releases/download/${streamlinkVersion}/streamlink-${streamlinkVersion}.tar.gz /opt/

#RUN apt-get update && apt-get install gosu

#RUN pip3 install versioningit

#RUN tar -xzf /opt/streamlink-${streamlinkVersion}.tar.gz -C /opt/ && \
#	rm /opt/streamlink-${streamlinkVersion}.tar.gz && \
#	cd /opt/streamlink-${streamlinkVersion}/ && \
#	python3 setup.py install

RUN apt-get update && apt-get install gosu && apt-get install python3-pip -y

RUN pip3 install --upgrade git+https://github.com/streamlink/streamlink.git@${streamlinkCommit}

RUN apt-get update -y && \
    apt-get install -y ffmpeg && \
    apt-get install -y jq
	
RUN  echo 'export PATH="${HOME}/.local/bin:${PATH}"'

RUN mkdir /home/download
RUN mkdir /home/script
RUN mkdir /home/plugins

RUN git clone https://github.com/Damianonymous/streamlink-plugins.git
RUN cp /streamlink-plugins/*.py /home/plugins/

COPY ./streamlink-recorder.sh /home/script/
COPY ./entrypoint.sh /home/script

RUN ["chmod", "+x", "/home/script/entrypoint.sh"]

ENTRYPOINT [ "/home/script/entrypoint.sh" ]

CMD /bin/sh ./home/script/streamlink-recorder.sh ${streamOptions} ${streamLink} ${streamQuality} ${streamName}
