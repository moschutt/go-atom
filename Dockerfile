FROM golang

ENV ATOM_VERSION v1.40.1

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      fakeroot \
      gconf2 \
      gconf-service \
      git \
      gvfs-bin \
      libasound2 \
      libcap2 \
      libgconf-2-4 \
      libgcrypt20 \
      libgtk2.0-0 \
      libgtk-3-0 \
      libnotify4 \
      libnss3 \
      libx11-xcb1 \
      libxkbfile1 \
      libxss1 \
      libxtst6 \
      libgl1-mesa-glx \
      libgl1-mesa-dri \
      policykit-1 \
      python \
      xdg-utils
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN curl -L https://github.com/atom/atom/releases/download/v1.40.1/atom-amd64.deb > /tmp/atom.deb && \
    dpkg -i /tmp/atom.deb && \
    rm -f /tmp/atom.deb
RUN useradd -d /home/atom -m atom

USER atom
RUN mkdir -p /home/atom/go

COPY packages.txt /tmp
RUN apm install --packages-file /tmp/packages.txt

COPY config.cson /home/atom/.atom/config.cson

#EXPOSE 6060
#EXPOSE 8000
#EXPOSE 8080

WORKDIR /home/atom/go

RUN echo "PATH=$PATH:$(go env GOPATH)/bin" >> ~/.bashrc
RUN echo "GOPATH=$(go env GOPATH)" >> ~/.bashrc

CMD ["/bin/true"]
