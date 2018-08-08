FROM centos:7

# Install wget
RUN yum update -y \
	&& yum install -y wget

# Install packages needed to build and compile R and used by prinseq-lite.pl
RUN yum group install -y "Development Tools"
RUN yum install -y epel-release
RUN yum install -y ncurses-devel zlib-devel texinfo gtk+-devel gtk2-devel qt-devel tcl-devel tk-devel kernel-headers kernel-devel readline-devel libcurl-devel bzip2-devel.x86_64 xz-devel.x86_64 java-1.7.0-openjdk openssl-devel perl-Digest-MD5.x86_64 libssh2-devel libxml2-devel.x86_64
RUN yum install -y xml2 libxml2-devel curl curl-devel openssl-devel pandoc
# Download and install R 
RUN yum install -y R

# Download kallisto and copy to bin
RUN wget "https://github.com/pachterlab/kallisto/releases/download/v0.44.0/kallisto_linux-v0.44.0.tar.gz"
RUN tar xf kallisto_linux-v0.44.0.tar.gz
RUN cp kallisto_linux-v0.44.0/kallisto /usr/local/bin/

# Install sleuth
COPY sleuth_install.r .
RUN Rscript sleuth_install.r

# Setup shinyapps.io settings
COPY shiny-apps-setup.r .
RUN Rscript shiny-apps-setup.r

# Download prinseq and copy to bin
RUN wget https://downloads.sourceforge.net/project/prinseq/standalone/prinseq-lite-0.20.4.tar.gz
RUN tar xzvf prinseq-lite-0.20.4.tar.gz
RUN cp prinseq-lite-0.20.4/prinseq-* /usr/local/bin/
RUN chmod u+x /usr/local/bin/prinseq-lite.pl 

# Download samtools, install and copy to bin
RUN wget https://github.com/samtools/samtools/releases/download/1.7/samtools-1.7.tar.bz2
RUN tar xjvf samtools-1.7.tar.bz2
WORKDIR samtools-1.7
RUN ./configure --prefix=/usr/local
RUN make
RUN make install
WORKDIR ../

# Install Agave CLI
RUN git clone https://bitbucket.org/agaveapi/cli.git /opt/bin/agave-cli && chmod -R a+r /opt/bin/agave-cli/bin && rm -rf /opt/bin/agave-cli/.git
ENV PATH=/opt/conda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin:/opt/bin/agave-cli/bin
# Automatically config root user for iplantc.org tenant
RUN /opt/bin/agave-cli/bin/tenants-init -t $AGAVE_TENANT

# Clean up
RUN rm -r kallisto_linux-v0.44.0.tar.gz kallisto_linux-v0.44.0
RUN rm sleuth_install.r
RUN rm -r prinseq-lite-0.20.4.tar.gz prinseq-lite-0.20.4
RUN rm -r samtools-1.7.tar.bz2 samtools-1.7

# Add kallisto, sleuth, and shiny app deployer runners runners
COPY run-kallisto.sh /usr/local/bin/
COPY run-sleuth.r /usr/local/bin/
COPY deploy-shiny-app.r /usr/local/bin/
COPY cleanup.sh /usr/local/bin/ 
RUN chmod u+x /usr/local/bin/run-kallisto.sh
RUN chmod u+x /usr/local/bin/run-sleuth.r
RUN chmod u+x /usr/local/bin/deploy-shiny-app.r
RUN chmod u+x /usr/local/bin/cleanup.sh

# Add entry points
ADD default_entrypoint.sh /opt/bin/ 
ADD run-ks.sh /opt/bin/

# Add additional directories to avoid needing OverlaysFS @ TACC HPC
RUN mkdir -p /work && chown root:root /work
RUN mkdir -p /gpfs && chown root:root /gpfs
RUN mkdir -p /data && chown root:root /data
RUN mkdir -p /home1 && chown root:root /home1
RUN mkdir -p /scratch && chown root:root /scratch


WORKDIR /root
COPY app.R /usr/local/bin/
RUN chmod u+x /usr/local/bin/app.R

ENTRYPOINT ["default_entrypoint.sh"]
