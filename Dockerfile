FROM centos/ruby-25-centos7

ENV RAILS_ENV=development
ENV RACK_ENV=development
ENV SECRET_KEY_BASE=cannot-be-blank-for-production-env-when-building
ENV RAILS_SERVE_STATIC_FILES=1

USER root

# for minimagick gem
RUN yum install -y ImageMagick

# Install yarn
RUN wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo && \
    rpm -Uvh --nodeps $(repoquery --location yarn)

# reduce image size
RUN yum clean all -y && rm -rf /var/cache/yum

# copy files needed for assembly into container
ADD ./images/docker/root /

RUN \
  # Call restore-artifacts sscript when assembling
  sed '/Installing application source/i $STI_SCRIPTS_PATH/restore-artifacts' \
    -i $STI_SCRIPTS_PATH/assemble && \
  # Call post-assemble script when assembling
  echo -e "\n\$STI_SCRIPTS_PATH/post-assemble" >> $STI_SCRIPTS_PATH/assemble

COPY . /tmp/src

RUN $STI_SCRIPTS_PATH/assemble

USER 1001
