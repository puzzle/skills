FROM centos/ruby-25-centos7

USER root

ADD ./root /

# for minimagick gem
RUN yum install -y ImageMagick

# Install yarn
RUN wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo && \
    rpm -Uvh --nodeps $(repoquery --location yarn)

RUN yum clean all -y && rm -rf /var/cache/yum

RUN \
  # Call restore-artifacts sscript when assembling
  sed '/Installing application source/i $STI_SCRIPTS_PATH/restore-artifacts' \
    -i $STI_SCRIPTS_PATH/assemble && \
  # Call post-assemble script when assembling
  echo -e "\n\$STI_SCRIPTS_PATH/post-assemble" >> $STI_SCRIPTS_PATH/assemble

USER 1001

# Workaround for base image: Do not install gems from development and test environments
# See https://github.com/sclorg/rhscl-dockerfiles/issues/26
ENV BUNDLE_WITHOUT=development:test
ENV RAILS_ENV=production
