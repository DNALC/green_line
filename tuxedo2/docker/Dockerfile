FROM centos

# Install wget
RUN yum update -y \
	&& yum install -y wget

# Install additional packages
RUN yum group install -y "Development Tools"
RUN yum install -y ncurses-devel zlib-devel texinfo gtk+-devel gtk2-devel qt-devel tcl-devel tk-devel kernel-headers kernel-devel readline-devel libcurl-devel bzip2-devel.x86_64 xz-devel.x86_64 java-1.7.0-openjdk openssl-devel unzip bzip2

# Download and install R (may the force be with you...)
RUN wget https://cran.r-project.org/src/base/R-3/R-3.4.2.tar.gz
RUN tar zxvf R-3.4.2.tar.gz
WORKDIR R-3.4.2
RUN ./configure \
	&& make -j4 \
	&& make install

WORKDIR ../

# Download and install Samtools
RUN wget https://github.com/samtools/samtools/releases/download/1.6/samtools-1.6.tar.bz2
RUN tar xjvf samtools-1.6.tar.bz2
WORKDIR samtools-1.6
RUN ./configure \
	&& make \
	&& make install
RUN cp samtools /usr/local/bin/

WORKDIR ../

# Download HiSat2 and add to PATH
RUN wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/downloads/hisat2-2.1.0-Linux_x86_64.zip
RUN unzip hisat2-2.1.0-Linux_x86_64.zip
RUN cp hisat2-2.1.0/hisat2* /usr/local/bin/
RUN cp hisat2-2.1.0/*.py /usr/local/bin/

# Download StringTie and add to PATH
RUN wget http://ccb.jhu.edu/software/stringtie/dl/stringtie-1.3.3b.Linux_x86_64.tar.gz
RUN tar xzvf stringtie-1.3.3b.Linux_x86_64.tar.gz
RUN cp stringtie-1.3.3b.Linux_x86_64/stringtie /usr/local/bin/

# Download gffcompare and install 
RUN git clone https://github.com/gpertea/gclib \ 
	&& git clone https://github.com/gpertea/gffcompare
WORKDIR gffcompare
RUN make release
RUN cp gffcompare /usr/local/bin/

WORKDIR ../

# Install ballgown
RUN yum install -y libxml2-devel.x86_64 libssh2-devel.x86_64
COPY install-ballgown.r .
RUN Rscript install-ballgown.r 

# Clean up
RUN rm -r R-3.4.2 R-3.4.2.tar.gz \
	&& rm -r gclib gffcompare \
	&& rm -r hisat2-2.1.0 hisat2-2.1.0-Linux_x86_64.zip \
	&& rm -r samtools-1.6 samtools-1.6.tar.bz2 \
	&& rm -r stringtie-1.3.3b.Linux_x86_64 stringtie-1.3.3b.Linux_x86_64.tar.gz \
	&& rm install-ballgown.r

# Add runners
COPY run-hisat2.sh /usr/local/bin/
COPY run-stringtie.sh /usr/local/bin/
COPY run-ballgown.r /usr/local/bin/
RUN chmod u+x /usr/local/bin/run-hisat2.sh /usr/local/bin/run-stringtie.sh /usr/local/bin/run-ballgown.r

# Add entrypoints
ADD default_entrypoint.sh /usr/local/bin/
ADD run-tuxedo2.sh /usr/local/bin/
ADD run-hisat2.sh /usr/local/bin/  

WORKDIR /root

ENTRYPOINT ["default_entrypoint.sh"]
